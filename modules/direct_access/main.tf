locals {
  use_strategy     = var.use_strategy
  cloudinit_ignore = var.cloudinit_ignore
  server           = var.server
  image            = var.image
  image_workfolder = (local.image.workfolder == "~" ? "/home/${local.image.user}" : local.image.workfolder)
  access_addresses = var.access_addresses
  ssh              = var.ssh
  add_domain       = var.add_domain
  domain           = var.domain
  add_eip          = var.add_eip
  domain_ips       = flatten(local.domain.ips)
  # tflint-ignore: terraform_unused_declarations
  fail_domain_ips = ((local.add_domain && length(local.domain_ips) == 0) ? one([local.domain_ips, "missing_domain_ips"]) : false)
  all_ips         = compact(concat(local.domain_ips, [(local.add_eip ? aws_eip.created[0].public_ip : "")]))
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
  from_port         = each.value.port
  to_port           = each.value.port
  protocol          = each.value.protocol
  cidr_blocks       = (each.value.ip_family != "ipv6" ? each.value.cidrs : null)
  ipv6_cidr_blocks  = (each.value.ip_family == "ipv6" ? each.value.cidrs : null)
}

resource "aws_network_interface_sg_attachment" "server_security_group_attachment" {
  depends_on = [
    aws_security_group.direct_access,
  ]
  security_group_id    = aws_security_group.direct_access.id
  network_interface_id = local.server.network_interface_id
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
  count = (local.add_domain ? 1 : 0)
  name  = local.domain.zone
}

resource "aws_route53_record" "created" {
  depends_on = [
    aws_eip.created,
    aws_eip_association.created,
    data.aws_route53_zone.general_info,
  ]
  count           = (local.add_domain ? 1 : 0)
  zone_id         = data.aws_route53_zone.general_info[0].zone_id
  name            = local.domain.name
  type            = local.domain.type
  ttl             = 300
  records         = local.all_ips
  allow_overwrite = true
}

resource "terraform_data" "setup" {
  depends_on = [
    aws_eip.created,
    aws_eip_association.created,
    aws_network_interface_sg_attachment.server_security_group_attachment,
    aws_security_group_rule.server_ingress,
    aws_security_group.direct_access,
  ]
  count = (local.use_strategy == "ssh" ? 1 : 0)
  triggers_replace = [
    local.server.id
  ]
  connection {
    type        = "ssh"
    user        = local.image.user
    script_path = "${local.image_workfolder}/setup"
    agent       = true
    host        = (local.add_eip ? aws_eip.created[0].public_ip : local.server.public_ip)
  }
  provisioner "remote-exec" {
    inline = ["echo 'connection successful'"]
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
      sudo ${local.image_workfolder}/initial.sh ${local.image.user} ${local.ssh.user} ${local.server.name} ${local.image.admin_group} ${local.ssh.timeout} ${local.cloudinit_ignore}
    EOT
    ]
  }
}

resource "terraform_data" "remove_initial_user" {
  depends_on = [
    aws_eip.created,
    terraform_data.setup,
    aws_eip_association.created,
    aws_network_interface_sg_attachment.server_security_group_attachment,
    aws_security_group_rule.server_ingress,
    aws_security_group.direct_access,
  ]
  count = (local.use_strategy == "ssh" ? 1 : 0)
  triggers_replace = [
    local.server.id,
  ]
  connection {
    type        = "ssh"
    user        = local.ssh.user
    script_path = "${local.ssh.user_workfolder}/remove_initial_user_script"
    agent       = true
    host        = (local.add_eip ? aws_eip.created[0].public_ip : local.server.public_ip)
  }
  provisioner "remote-exec" {
    inline = ["echo 'connection successful'"]
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
