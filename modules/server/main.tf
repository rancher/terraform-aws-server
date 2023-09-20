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
  user_data = templatefile("${path.module}/cloudinit.tpl", {
    initial_user = local.initial_user
    admin_group  = local.admin_group
    user         = local.user
    ssh_key      = local.ssh_key
    name         = local.name
  })
  az = var.availability_zone
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
  availability_zone                    = local.az
  user_data_base64                     = base64encode(local.user_data)

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
    script_path = "/home/${local.initial_user}/initial_script"
    agent       = true
    host        = self.public_ip
  }
  provisioner "file" {
    source      = "${path.module}/initial.sh"
    destination = "/home/${local.initial_user}/initial.sh"
  }
  provisioner "remote-exec" {
    # injecting values with export rather than using a
    # template so that we can automatically check the script with shellcheck
    inline = [<<-EOT
      export USER=${local.user}
      export ADMIN_GROUP=${local.admin_group}
      export INITIAL_USER=${local.initial_user}
      export NAME=${local.name}
      sudo chmod +x /home/${local.initial_user}/initial.sh
      /home/${local.initial_user}/initial.sh
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

  provisioner "file" {
    source      = "${path.module}/remove_initial_user.sh"
    destination = "/home/${local.user}/remove_initial_user.sh"
  }
  provisioner "remote-exec" {
    inline = [<<-EOT
      export INITIAL_USER=${local.initial_user}
      chmod +x /home/${local.user}/remove_initial_user.sh
      /home/${local.user}/remove_initial_user.sh
    EOT
    ]
  }
  triggers = {
    server_id = aws_instance.created[0].id
  }
}
