locals {
  select                                  = (var.id != "" ? true : false)
  create                                  = (var.id == "" ? true : false)
  id                                      = var.id
  name                                    = var.name
  owner                                   = var.owner
  user                                    = var.user
  subnet                                  = var.subnet # the name of the subnet to find
  eip                                     = var.eip    # should we deploy a public elastic ip with the server?
  default_ip                              = (length(data.aws_subnet.general_info) > 0 ? cidrhost(data.aws_subnet.general_info[0].cidr_block, -2) : "")
  ip                                      = (var.ip == "" ? local.default_ip : var.ip) # specify the private ip to assign to the server (must be within the subnet)
  ipv4                                    = (strcontains(local.ip, ":") ? "" : local.ip)
  ipv6                                    = (strcontains(local.ip, ":") ? local.ip : "")
  security_group                          = var.security_group
  security_group_association_force_create = var.security_group_association_force_create
  type                                    = (local.create ? local.types[var.type] : {})
  image_id                                = var.image_id
  initial_user                            = var.image_initial_user
  initial_user_home                       = "/home/${local.initial_user}"
  initial_workspace                       = replace(var.image_workfolder, "~", "") # WARNING! '~' can't go to the server! you will see "scp: permission denied" errors
  workfolder                              = (local.initial_workspace == "" ? local.initial_user_home : local.initial_workspace)
  admin_group                             = var.image_admin_group
  default_cloudinit_script                = <<-EOT
  #!/bin/sh
  echo "default script..."
  EOT
  cloudinit_script                        = (var.cloudinit_script == "" ? local.default_cloudinit_script : var.cloudinit_script)
  cloudinit_timeout                       = var.cloudinit_timeout
  skip_key                                = var.skip_key                                                                 # skip the association of a keypair to the server
  ssh_key                                 = (local.skip_key ? "" : var.ssh_key)                                          # empty key if not associating a key
  ssh_key_name                            = (local.skip_key ? "" : var.ssh_key_name)                                     # empty key name if not associating a key
  associate_key                           = (local.skip_key ? false : true)                                              # associate key is the opposite of skip_key
  no_public_ip                            = (local.eip ? false : true)                                                   # opposite of add_public_ip
  disable_scripts                         = (var.disable_scripts || local.skip_key || local.no_public_ip ? true : false) # disable scripts if not associating an ssh key or public ip
  enable_scripts                          = (local.disable_scripts ? false : true)                                       # enable scripts is the opposite of disable scripts
}
# WARNING! When selecting a server it is assumed that no additional resources are required (unless forcing security group creation)
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


resource "aws_eip" "created" {
  count = (local.create && local.eip ? 1 : 0)
  depends_on = [
    data.aws_subnet.general_info,
  ]
  domain = "vpc"
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
  lifecycle {
    ignore_changes = [
      subnet_id, # this is dependant on the aws subnet lookup and if not ignored will cause the interface to always rebuild
    ]
  }
}

resource "aws_eip_association" "created" {
  count = (local.create && local.eip ? 1 : 0)
  depends_on = [
    data.aws_subnet.general_info,
    aws_network_interface.created,
  ]
  allocation_id        = aws_eip.created[0].id
  network_interface_id = aws_network_interface.created[0].id
  allow_reassociation  = true # this should allow the server to be destroyed without the ip changing
}

data "cloudinit_config" "created" {
  depends_on = [
    aws_eip.created,
    aws_network_interface.created,
    data.aws_subnet.general_info,
  ]
  count         = (local.create ? 1 : 0)
  gzip          = false
  base64_encode = true
  part {
    filename     = "config.sh"
    content_type = "text/x-shellscript"
    content      = local.cloudinit_script
  }
  part {
    filename     = "cloud-config.yaml"
    content_type = "text/cloud-config"
    content = templatefile("${path.module}/cloudinit.tpl", {
      initial_user = local.initial_user
      admin_group  = local.admin_group
      user         = local.user
      ssh_key      = local.ssh_key
      name         = local.name
      ami          = local.image_id
      eip          = length(aws_eip.created) > 0 ? aws_eip.created[0].public_ip : local.ip
      subnet       = data.aws_subnet.general_info[0].id
      az           = data.aws_subnet.general_info[0].availability_zone
    })
  }
}
resource "aws_instance" "created" {
  count = (local.create ? 1 : 0)
  depends_on = [
    data.aws_security_group.general_info,
    data.aws_subnet.general_info,
    data.aws_key_pair.general_info,
    aws_network_interface.created,
    data.cloudinit_config.created,
  ]
  ami           = local.image_id
  instance_type = local.type.id

  # kubernetes expects the primary interface to keep its IP
  #   the server resource will generate a device 0 interface if one is not given
  #   so the only way to control the primary interface is to provide it like this
  # this necessitates the network interface being created before the server
  network_interface {
    network_interface_id = aws_network_interface.created[0].id
    device_index         = 0
  }

  instance_initiated_shutdown_behavior = "stop" # termination can be handled by destroy or separately
  user_data_base64                     = data.cloudinit_config.created[0].rendered
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
    # so what does cause the server to rebuild?
    #   - directly changing: name, instance type, or storage type
    ignore_changes = [
      tags,                          # amazon updates tags automatically, ignore this change
      tags_all,                      # amazon updates tags automatically, ignore this change
      root_block_device[0].tags_all, # amazon updates tags automatically, ignore this change
      availability_zone,             # this is dependant on the aws subnet lookup and if not ignored will cause the server to always rebuild
      network_interface,             # this is dependant on the aws subnet lookup and if not ignored will cause the server to always rebuild
      ami,                           # this is dependant on the aws ami lookup and if not ignored will cause the server to always rebuild
    ]
    replace_triggered_by = [
      aws_eip.created[0].id,
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
