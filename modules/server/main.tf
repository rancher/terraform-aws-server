locals {
  select            = (var.id != "" ? true : false)
  create            = (var.id == "" ? true : false)
  id                = var.id
  name              = var.name
  owner             = var.owner
  user              = var.user
  ssh_key           = var.ssh_key
  ssh_key_name      = var.ssh_key_name
  security_group    = var.security_group
  subnet            = var.subnet
  type              = (local.create ? local.types[var.type] : {})
  image_id          = var.image_id
  initial_user      = var.image_initial_user
  admin_group       = var.image_admin_group
  workfolder        = ((var.image_workfolder == "~" || var.image_workfolder == "") ? "/home/${local.initial_user}" : var.image_workfolder)
  cloudinit_script  = var.cloudinit_script
  cloudinit_timeout = var.cloudinit_timeout
  user_data = templatefile("${path.module}/cloudinit.tpl", {
    initial_user = local.initial_user
    admin_group  = local.admin_group
    user         = local.user
    ssh_key      = local.ssh_key
    name         = local.name
    script       = local.cloudinit_script
  })
}
# WARNING! When selecting a server it is assumed that no additional resources are required
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

data "aws_key_pair" "general_info" {
  count = (local.create ? 1 : 0)
  filter {
    name   = "tag:Name"
    values = [local.ssh_key_name]
  }
}

resource "aws_instance" "created" {
  count = (local.create ? 1 : 0)
  depends_on = [
    data.aws_security_group.general_info,
    data.aws_subnet.general_info,
    data.aws_key_pair.general_info,
  ]
  ami                                  = local.image_id
  instance_type                        = local.type.id
  subnet_id                            = data.aws_subnet.general_info[0].id
  associate_public_ip_address          = "true"
  instance_initiated_shutdown_behavior = "stop"
  user_data_base64                     = base64encode(local.user_data)
  availability_zone                    = data.aws_subnet.general_info[0].availability_zone
  key_name                             = data.aws_key_pair.general_info[0].key_name

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
  count                = (local.create ? 1 : 0) # attach sg to new server
  security_group_id    = data.aws_security_group.general_info[0].id
  network_interface_id = aws_instance.created[0].network_interface_id
  lifecycle {
    replace_triggered_by = [
      aws_instance.created[0].id,
    ]
  }
}
resource "terraform_data" "initial" {
  count = (local.create ? 1 : 0) # initialize server when creating
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
