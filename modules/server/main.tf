locals {
  use            = var.use # the strategy to use for selecting or creating a server
  select         = (local.use == "select" ? 1 : 0)
  create         = (local.use == "create" ? 1 : 0)
  id             = var.id   # the id of a server to select
  type           = var.type # the designation from types.tf
  server_type    = lookup(local.types, local.type, null)
  security_group = var.security_group # the name of the security group to find
  subnet         = var.subnet         # the name of the subnet to find
  ip             = var.ip             # ip to assign to the server
  default_ip     = (length(data.aws_subnet.general_info_create) > 0 ? cidrhost(data.aws_subnet.general_info_create[0].cidr_block, -2) : "")
  server_ip      = (local.ip != "" ? local.ip : local.default_ip)
  ipv4           = (strcontains(local.server_ip, ":") ? "" : local.server_ip)
  ipv6           = (strcontains(local.server_ip, ":") ? local.server_ip : "")
  # tflint-ignore: terraform_unused_declarations
  fail_ip = ((local.ipv4 == "" && local.ipv6 == "") ? one([local.server_ip, "ip_not_found"]) : false)
  image   = var.image # the image object from the image module to use for the ec2 instance


  name         = var.name         # the name to give the new server
  eip          = var.eip          # should we deploy a public elastic ip with the server?
  server_ports = var.server_ports # list of ports to allow ingress to the server
  access_ips   = var.access_ips   # list of ip addresses to allow access to the server
  domain_use   = var.domain_use   # the strategy to use for selecting, creating, or skipping a domain
  domain       = var.domain       # the domain to associate with the server
  cloudinit    = var.cloudinit    # the cloudinit content to associate with the server

  # tflint-ignore: terraform_unused_declarations
  fail_type = (local.server_type == null ? one([local.type, "type_not_found"]) : false)

  server_access_ports = [for port in local.server_ports : tostring(port)]

}

# select
# WARNING! When selecting a server nothing else will be done
data "aws_instance" "selected" {
  count       = local.select
  instance_id = local.id
}

data "aws_ec2_instance_type" "general_info_create" {
  count         = local.create
  instance_type = local.server_type.id
}
data "aws_ec2_instance_type" "general_info_select" {
  count         = local.select
  instance_type = data.aws_instance.selected[0].instance_type
}

data "aws_security_group" "general_info_create" {
  count = local.create
  filter {
    name   = "tag:Name"
    values = [local.security_group]
  }
}
data "aws_security_group" "general_info_select" {
  count = local.select
  id    = element(data.aws_instance.selected[0].security_groups, 0).id
}

data "aws_subnet" "general_info_create" {
  count = local.create
  filter {
    name   = "tag:Name"
    values = [local.subnet]
  }
}
data "aws_subnet" "general_info_select" {
  count = local.select
  id    = data.aws_instance.selected[0].subnet_id
}

data "aws_vpc" "general_info_create" {
  count = local.create
  id    = data.aws_security_group.general_info_create[0].vpc_id
}
data "aws_vpc" "general_info_select" {
  count = local.select
  id    = data.aws_security_group.general_info_select[0].vpc_id
}

resource "aws_network_interface" "created" {
  count = local.create
  depends_on = [
    data.aws_subnet.general_info_create,
  ]
  subnet_id      = data.aws_subnet.general_info_create[0].id
  private_ips    = (local.ipv4 != "" ? [local.ipv4] : [])
  ipv6_addresses = (local.ipv6 != "" ? [local.ipv6] : [])
  tags = {
    Name = local.name
  }
  lifecycle {
    ignore_changes = [
      subnet_id, # this is dependant on the aws subnet lookup and if not ignored will cause the interface to always rebuild
    ]
  }
}

resource "aws_instance" "created" {
  count = local.create
  depends_on = [
    data.aws_security_group.general_info_create,
    data.aws_subnet.general_info_create,
    aws_network_interface.created,
  ]
  ami           = local.image.id
  instance_type = data.aws_ec2_instance_type.general_info_create[0].id

  # kubernetes expects the primary interface to keep its IP
  #   the server resource will generate a device 0 interface if one is not given
  #   so the only way to control the primary interface is to provide it like this
  # this necessitates the network interface being created before the server
  network_interface {
    network_interface_id = aws_network_interface.created[0].id
    device_index         = 0
  }

  instance_initiated_shutdown_behavior = "stop" # termination can be handled by destroy or separately
  user_data_base64                     = local.cloudinit
  availability_zone                    = data.aws_subnet.general_info_create[0].availability_zone

  tags = {
    Name = local.name
  }

  root_block_device {
    delete_on_termination = true
    volume_size           = local.server_type.storage
    tags = {
      Name = local.name
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
  }
}

resource "aws_network_interface_sg_attachment" "security_group_attachment" {
  count = local.create
  depends_on = [
    data.aws_security_group.general_info_create,
    aws_instance.created,
    aws_network_interface.created,
  ]
  security_group_id    = data.aws_security_group.general_info_create[0].id
  network_interface_id = aws_network_interface.created[0].id
  lifecycle {
    ignore_changes = [
      security_group_id, # this is dependant on the aws security group lookup and if not ignored will cause the interface to always rebuild
    ]
  }
}
