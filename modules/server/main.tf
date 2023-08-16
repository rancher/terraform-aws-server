locals {
  select         = (var.id != "" ? true : false)
  create         = (var.id == "" ? true : false)
  id             = var.id
  name           = var.name
  owner          = var.owner
  user           = var.user
  ssh_key        = var.ssh_key
  security_group = var.security_group
  subnet         = var.subnet
  type           = (local.create ? local.types[var.type] : {})
  image_id       = var.image_id
  initial_user   = var.image_initial_user
  admin_group    = var.image_admin_group
}

data "aws_instance" "selected" {
  count       = (local.select ? 1 : 0)
  instance_id = local.id
}

data "aws_ec2_instance_type" "general_info" {
  instance_type = (local.create ? local.type.id : data.aws_instance.selected[0].instance_type)
}

data "aws_security_group" "general_info" {
  count = (local.create ? 1 : 0)
  filter {
    name   = "tag:Name"
    values = [local.security_group]
  }
}

data "aws_subnet" "general_info" {
  count = (local.create ? 1 : 0)
  filter {
    name   = "tag:Name"
    values = [local.subnet]
  }
}

resource "aws_instance" "created" {
  count                                = (local.create ? 1 : 0)
  ami                                  = local.image_id
  instance_type                        = local.type.id
  vpc_security_group_ids               = [data.aws_security_group.general_info[0].id]
  subnet_id                            = data.aws_subnet.general_info[0].id
  associate_public_ip_address          = "true"
  instance_initiated_shutdown_behavior = "terminate"
  user_data                            = <<-EOT
  #cloud-config
  users:
    - default
    - name: ${local.initial_user}
      gecos: ${local.initial_user}
      sudo: ALL=(ALL) NOPASSWD:ALL
      groups: users, ${local.admin_group}
      lock_password: false
      ssh_authorized_keys:
        - ${local.ssh_key}
    - name: ${local.user}
      gecos: ${local.user}
      sudo: ALL=(ALL) NOPASSWD:ALL
      groups: users, ${local.admin_group}
      lock_password: false
      ssh_authorized_keys:
        - ${local.ssh_key}
  EOT

  tags = {
    Name  = local.name
    User  = local.user
    Owner = local.owner
  }

  root_block_device {
    delete_on_termination = true
    volume_size           = local.type.storage
    tags = {
      Name  = local.name
      User  = local.user
      Owner = local.owner
    }
  }

  # there is a potential race condition here:
  #   the initial connection is racing the cloud-init completion
  #   this is why we add the initial user in the cloud-init
  #   then we reconnect with the requested user and remove the initial user
  connection {
    type        = "ssh"
    user        = local.initial_user
    script_path = "/home/${local.initial_user}/initial"
    agent       = true
    host        = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [<<-EOT
      if [ -z $(which cloud-init) ]; then
        echo "cloud-init not found";
        # check for user, if it doesn't exist generate it
        if [ -z $(awk -F: '{ print $1 }' /etc/passwd | grep ${local.user}) ]; then
          sudo addgroup ${local.user}
          sudo adduser -g "${local.user}" -s "/bin/sh" -G "${local.user}" -D ${local.user}
          sudo addgroup ${local.user} ${local.admin_group}
          sudo install -d -m 0700 /home/${local.user}/.ssh
          sudo cp .ssh/authorized_keys /home/${local.user}/.ssh
          sudo chown -R ${local.user}:${local.user} /home/${local.user}
          sudo passwd -d ${local.user}
        fi
        exit 0;
      fi

      max_attempts=15
      attempts=0
      interval=5
      while [ "$(sudo cloud-init status)" != "status: done" ]; do
        echo "cloud init is \"$(sudo cloud-init status)\""
        attempts=$(expr $attempts + 1)
        if [ $attempts = $max_attempts ]; then break; fi
        sleep $interval;
      done
      echo "cloud init is \"$(sudo cloud-init status)\""

      # some images set sshd config to only allow initial user to connect (CIS)
      # add our user to the list of allowed users and restart sshd
      if [ "${local.initial_user}" != "${local.user}" ]; then
        sudo sed -i 's/^AllowUsers.*/& ${local.user}/' /etc/ssh/sshd_config
        sudo systemctl restart sshd
      fi
    EOT
    ]
  }
  lifecycle {
    ignore_changes = [
      tags,
      root_block_device.0.tags,
    ]
  }
}

resource "null_resource" "remove_initial_user" {
  count      = (local.create ? 1 : 0) # clean up initial user when creating
  depends_on = [aws_instance.created]
  connection {
    type        = "ssh"
    user        = local.user
    script_path = "/home/${local.user}/remove_initial"
    agent       = true
    host        = aws_instance.created[0].public_ip
  }

  provisioner "remote-exec" {
    inline = [<<-EOT
      # wait for previous connection to close
      sleep 2
      sudo killall -TERM -u ${local.initial_user}
      # wait for killall to finish
      sleep 2 
      sudo userdel -r ${local.initial_user}
    EOT
    ]
  }
  triggers = {
    server_id = aws_instance.created[0].id
  }
}
