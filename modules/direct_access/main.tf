locals {
  use_strategy     = var.use_strategy
  server           = var.server
  image            = var.image
  image_workfolder = (local.image.workfolder == "~" ? "/home/${local.image.user}" : local.image.workfolder)
  access_addresses = var.access_addresses
  ssh              = var.ssh
  add_domain       = var.add_domain
  domain           = var.domain
  add_eip          = var.add_eip
}

resource "aws_security_group" "direct_access" {
  name        = local.server.name
  description = "Security group for server ${local.server.name}"
  vpc_id      = local.server.vpc_id
  tags = {
    Name = local.server.name
  }
}

resource "aws_security_group_rule" "server_ingress" {
  depends_on = [
    aws_security_group.direct_access,
  ]
  for_each          = local.access_addresses
  security_group_id = aws_security_group.direct_access.id
  type              = "ingress"
  from_port         = tonumber(each.key)
  to_port           = tonumber(each.key)
  protocol          = "-1"
  cidr_blocks       = each.value
}

resource "aws_network_interface_sg_attachment" "server_security_group_attachment" {
  depends_on = [
    aws_security_group.direct_access,
  ]
  security_group_id    = aws_security_group.direct_access.id
  network_interface_id = local.server.network_interface_id
}

resource "terraform_data" "setup" {
  count = (local.use_strategy == "ssh" ? 1 : 0)
  triggers_replace = [
    local.server.id
  ]
  connection {
    type        = "ssh"
    user        = local.image.user
    script_path = "${local.image_workfolder}/setup"
    agent       = true
    host        = local.server.public_ip
  }
  provisioner "file" {
    source      = "${path.module}/initial.sh"
    destination = "${local.image_workfolder}/initial.sh"
  }
  provisioner "remote-exec" {
    inline = [<<-EOT
      set -x
      set -e
      sudo chmod +x ${local.image_workfolder}/initial.sh
      sudo ${local.image_workfolder}/initial.sh ${local.image.user} ${local.ssh.user} ${local.server.name} ${local.image.admin_group} ${local.ssh.timeout}
    EOT
    ]
  }
}

resource "terraform_data" "remove_initial_user" {
  count = (local.use_strategy == "ssh" ? 1 : 0)
  triggers_replace = [
    local.server.id,
  ]
  connection {
    type        = "ssh"
    user        = local.ssh.user
    script_path = "${local.ssh.user_workfolder}/remove_initial_user_script"
    agent       = true
    host        = local.server.public_ip
  }
  provisioner "file" {
    source      = "${path.module}/remove_initial_user.sh"
    destination = "${local.ssh.user_workfolder}/remove_initial_user.sh"
  }
  provisioner "remote-exec" {
    inline = [<<-EOT
      set -x
      set -e
      sudo chmod +x ${local.ssh.user_workfolder}/remove_initial_user.sh
      sudo ${local.ssh.user_workfolder}/remove_initial_user.sh ${local.image.user}
    EOT
    ]
  }
}

resource "aws_eip" "created" {
  count  = local.add_eip ? 1 : 0
  domain = "vpc"
}

resource "aws_eip_association" "created" {
  depends_on = [
    aws_eip.created,
  ]
  count                = local.add_eip ? 1 : 0
  allocation_id        = aws_eip.created[0].id
  network_interface_id = local.server.network_interface_id
  allow_reassociation  = true # this should allow the server to be destroyed without the ip changing
}

data "aws_route53_zone" "general_info" {
  name = local.domain.zone
}

resource "aws_route53_record" "created" {
  depends_on = [
    aws_eip.created,
    aws_eip_association.created,
    data.aws_route53_zone.general_info,
  ]
  count           = (local.add_domain ? 1 : 0)
  zone_id         = data.aws_route53_zone.general_info.zone_id
  name            = local.domain.name
  type            = local.domain.type
  ttl             = 300
  records         = flatten([local.domain.ips, [(local.add_eip ? aws_eip.created[0].public_ip : "")]])
  allow_overwrite = true
}
