locals {
  select                                  = (var.id != "" ? true : false)
  create                                  = (var.id == "" ? true : false)
  id                                      = var.id
  name                                    = var.name
  owner                                   = var.owner
  user                                    = var.user
  ip                                      = var.ip # specify the private ip to assign to the server (must be within the subnet)
  ipv4                                    = (strcontains(local.ip, ":") ? "" : local.ip)
  ipv6                                    = (strcontains(local.ip, ":") ? local.ip : "")
  security_group                          = var.security_group
  security_group_association_force_create = var.security_group_association_force_create
  subnet                                  = var.subnet
  type                                    = (local.create ? local.types[var.type] : {})
  image_id                                = var.image_id
  initial_user                            = var.image_initial_user
  admin_group                             = var.image_admin_group
  workfolder                              = ((var.image_workfolder == "~" || var.image_workfolder == "") ? "/home/${local.initial_user}" : var.image_workfolder)
  cloudinit_script                        = var.cloudinit_script
  cloudinit_timeout                       = var.cloudinit_timeout
  skip_key                                = var.skip_key                                           # skip the association of a keypair to the server
  ssh_key                                 = (local.skip_key ? "" : var.ssh_key)                    # empty key if not associating a key
  ssh_key_name                            = (local.skip_key ? "" : var.ssh_key_name)               # empty key name if not associating a key
  associate_key                           = (local.skip_key ? false : true)                        # associate key is the opposite of skip_key
  disable_scripts                         = (var.disable_scripts || local.skip_key ? true : false) # disable scripts if not associating an ssh key
  enable_scripts                          = (local.disable_scripts ? false : true)                 # enable scripts is the opposite of disable scripts
  user_data = templatefile("${path.module}/cloudinit.tpl", {
    initial_user = local.initial_user
    admin_group  = local.admin_group
    user         = local.user
    ssh_key      = local.ssh_key
    name         = local.name
    script       = local.cloudinit_script
  })
}
# WARNING! When selecting a server it is assumed that no additional resources are required (unless forcing group)
data "aws_instance" "selected" {
  count       = (local.select ? 1 : 0)
  instance_id = local.id
}

data "aws_ec2_instance_type" "general_info" {
  instance_type = (local.create ? local.type.id : data.aws_instance.selected[0].instance_type)
}

data "aws_security_group" "general_info" {
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

data "aws_key_pair" "general_info" {
  count = (local.create && local.associate_key ? 1 : 0)
  filter {
    name   = "tag:Name"
    values = [local.ssh_key_name]
  }
}

resource "aws_network_interface" "created" {
  count = (local.create ? 1 : 0)
  depends_on = [
    data.aws_subnet.general_info,
  ]
  subnet_id      = data.aws_subnet.general_info[0].id
  private_ips    = (local.ipv4 != "" ? [local.ipv4] : [])
  ipv6_addresses = (local.ipv6 != "" ? [local.ipv6] : [])
  tags = {
    Name  = local.name
    Owner = local.owner
  }
}

resource "aws_instance" "created" {
  count = (local.create ? 1 : 0)
  depends_on = [
    data.aws_security_group.general_info,
    data.aws_subnet.general_info,
    data.aws_key_pair.general_info,
    aws_network_interface.created,
  ]
  ami           = local.image_id
  instance_type = local.type.id

  #associate_public_ip_address          = false  # this will be handled in interfaces attached to the instance
  network_interface {
    network_interface_id = aws_network_interface.created[0].id
    device_index         = 0
  }
  instance_initiated_shutdown_behavior = "stop" # termination can be handled by destroy or separately
  user_data_base64                     = base64encode(local.user_data)
  availability_zone                    = data.aws_subnet.general_info[0].availability_zone
  key_name                             = (local.associate_key ? data.aws_key_pair.general_info[0].key_name : "")

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
  lifecycle {
    ignore_changes = [
      tags,
      root_block_device.0.tags,
    ]
  }
}


resource "aws_network_interface_sg_attachment" "sg_attachment" {
  count = (local.create || local.security_group_association_force_create ? 1 : 0)
  depends_on = [
    data.aws_security_group.general_info,
    data.aws_subnet.general_info,
    data.aws_key_pair.general_info,
    data.aws_instance.selected,
    aws_instance.created,
    aws_network_interface.created,
  ]
  security_group_id = data.aws_security_group.general_info.id
  network_interface_id = (
    local.create ? aws_network_interface.created[0].id : data.aws_instance.selected[0].network_interface_id
  )
}
resource "terraform_data" "initial" {
  count = ((local.create && local.enable_scripts) ? 1 : 0) # initialize server when creating unless scripts are disabled
  depends_on = [
    data.aws_security_group.general_info,
    data.aws_subnet.general_info,
    data.aws_key_pair.general_info,
    aws_instance.created,
    aws_network_interface_sg_attachment.sg_attachment,
  ]
  triggers_replace = [
    aws_instance.created[0].id,
  ]
  connection {
    type        = "ssh"
    user        = local.initial_user
    script_path = "${local.workfolder}/initial_script"
    agent       = true
    host        = aws_instance.created[0].public_ip
  }
  provisioner "file" {
    source      = "${path.module}/initial.sh"
    destination = "${local.workfolder}/initial.sh"
  }
  provisioner "remote-exec" {
    inline = [<<-EOT
      set -x
      set -e
      sudo chmod +x ${local.workfolder}/initial.sh
      sudo ${local.workfolder}/initial.sh ${local.initial_user} ${local.user} ${local.name} ${local.admin_group} ${local.cloudinit_timeout}
    EOT
    ]
  }
}

resource "terraform_data" "remove_initial_user" {
  count = ((local.create && local.enable_scripts) ? 1 : 0) # remove initial user when creating unless scripts are disabled
  depends_on = [
    data.aws_security_group.general_info,
    data.aws_subnet.general_info,
    data.aws_key_pair.general_info,
    aws_instance.created,
    aws_network_interface_sg_attachment.sg_attachment,
    terraform_data.initial,
  ]
  triggers_replace = [
    aws_instance.created[0].id,
  ]
  connection {
    type        = "ssh"
    user        = local.user
    script_path = "${(local.workfolder == "/home/${local.initial_user}" ? "/home/${local.user}" : local.workfolder)}/remove_initial_user_script"
    agent       = true
    host        = aws_instance.created[0].public_ip
  }

  provisioner "file" {
    source      = "${path.module}/remove_initial_user.sh"
    destination = "${(local.workfolder == "/home/${local.initial_user}" ? "/home/${local.user}" : local.workfolder)}/remove_initial_user.sh"
  }
  provisioner "remote-exec" {
    inline = [<<-EOT
      set -x
      set -e
      sudo chmod +x ${(local.workfolder == "/home/${local.initial_user}" ? "/home/${local.user}" : local.workfolder)}/remove_initial_user.sh
      sudo ${(local.workfolder == "/home/${local.initial_user}" ? "/home/${local.user}" : local.workfolder)}/remove_initial_user.sh ${local.initial_user}
    EOT
    ]
  }
}
