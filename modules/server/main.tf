locals {
  use    = var.use   # the strategy to use for selecting or creating a server
  image  = var.image # the image object from the image module to use for the ec2 instance
  select = (local.use == "select" ? 1 : 0)
  create = (local.use == "create" ? 1 : 0)
  id     = var.id   # the id of a server to select
  name   = var.name # the name to give the new server
  type   = var.type # the designation from types.tf
  # tflint-ignore: terraform_unused_declarations
  fail_type      = (local.create == 1 && local.server_type == null ? one([local.type, "type_not_found"]) : false)
  server_type    = lookup(local.types, local.type, null)
  security_group = var.security_group # the name of the security group to find and assign to the server
  subnet         = var.subnet         # the name of the subnet to find and assign to the server
  cloudinit      = var.cloudinit      # the cloudinit content to associate with the server

  aws_keypair_use_strategy = var.aws_keypair_use_strategy
  ssh_key                  = var.ssh_key
  ssh_key_name             = var.ssh_key_name

  ip         = var.ip # private ip to assign to the server
  default_ip = (length(data.aws_subnet.general_info_create) > 0 ? cidrhost(data.aws_subnet.general_info_create[0].cidr_block, -2) : "")
  server_ip  = (local.ip != "" ? local.ip : local.default_ip)
  ipv4       = (strcontains(local.server_ip, ":") ? "" : local.server_ip)
  ipv6       = (strcontains(local.server_ip, ":") ? local.server_ip : "")
  # tflint-ignore: terraform_unused_declarations
  fail_ip = ((local.create == 1 && local.ipv4 == "" && local.ipv6 == "") ? one([local.server_ip, "ip_not_found"]) : false)
}

# select
# WARNING! When selecting a server nothing else will be done
data "aws_instance" "selected" {
  count       = local.select
  instance_id = local.id
}
data "aws_ec2_instance_type" "general_info_select" {
  count         = local.select
  instance_type = data.aws_instance.selected[0].instance_type
}
data "aws_subnet" "general_info_select" {
  count = local.select
  id    = data.aws_instance.selected[0].subnet_id
}
data "aws_vpc" "general_info_select" {
  count = local.select
  id    = data.aws_subnet.general_info_select[0].vpc_id
}

data "aws_ec2_instance_type" "general_info_create" {
  count         = local.create
  instance_type = local.server_type.id
}
data "aws_security_group" "general_info_create" {
  count = local.create
  filter {
    name   = "tag:Name"
    values = [local.security_group]
  }
}
data "aws_subnet" "general_info_create" {
  count = local.create
  filter {
    name   = "tag:Name"
    values = [local.subnet]
  }
}
data "aws_vpc" "general_info_create" {
  count = local.create
  id    = data.aws_security_group.general_info_create[0].vpc_id
}
data "aws_key_pair" "ssh_key_selected" {
  count    = (local.aws_keypair_use_strategy == "select" ? 1 : 0)
  key_name = local.ssh_key_name
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

resource "aws_key_pair" "created" {
  count      = (local.aws_keypair_use_strategy == "create" ? local.create : 0)
  key_name   = local.ssh_key_name
  public_key = local.ssh_key
}

resource "aws_instance" "created" {
  count = local.create
  depends_on = [
    data.aws_security_group.general_info_create,
    data.aws_subnet.general_info_create,
    aws_network_interface.created,
    aws_key_pair.created,
  ]
  ami           = local.image.id
  instance_type = data.aws_ec2_instance_type.general_info_create[0].id
  key_name      = (local.aws_keypair_use_strategy != "skip" ? (local.aws_keypair_use_strategy == "create" ? aws_key_pair.created[0].key_name : data.aws_key_pair.ssh_key_selected[0].key_name) : "")

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
