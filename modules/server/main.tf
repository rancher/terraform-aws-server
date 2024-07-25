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
  ip_family      = var.ip_family
  server_type    = lookup(local.types, local.type, null)
  security_group = var.security_group # the name of the security group to find and assign to the server
  subnet         = var.subnet         # the name of the subnet to find and assign to the server
  cloudinit      = var.cloudinit      # the cloudinit content to associate with the server

  aws_keypair_use_strategy = var.aws_keypair_use_strategy
  ssh_key                  = var.ssh_key
  ssh_key_name             = var.ssh_key_name

  ip   = var.ip # ip to assign to the server
  ipv4 = ((local.ip_family == "ipv4" || local.ip_family == "dualstack") ? local.ip : "")
  ipv6 = (local.ip_family == "ipv6" ? local.ip : "")
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
    aws_key_pair.created,
  ]
  ami           = local.image.id
  instance_type = data.aws_ec2_instance_type.general_info_create[0].id
  key_name      = (local.aws_keypair_use_strategy != "skip" ? (local.aws_keypair_use_strategy == "create" ? aws_key_pair.created[0].key_name : data.aws_key_pair.ssh_key_selected[0].key_name) : "")

  subnet_id      = data.aws_subnet.general_info_create[0].id
  private_ip     = (local.ipv4 != "" ? local.ipv4 : null)
  ipv6_addresses = (local.ipv6 != "" ? [local.ipv6] : null)

  instance_initiated_shutdown_behavior = "stop" # termination can be handled by destroy or separately
  user_data_base64                     = local.cloudinit
  user_data_replace_on_change          = true # rebuild the server if the user data changes
  availability_zone                    = data.aws_subnet.general_info_create[0].availability_zone
  security_groups                      = [data.aws_security_group.general_info_create[0].id]
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
      subnet_id,                     # this is dependant on the aws subnet lookup and if not ignored will cause the server to always rebuild
      private_ip,                    # this is dependant on the aws subnet lookup and if not ignored will cause the server to always rebuild
      ipv6_addresses,                # this is dependant on the aws subnet lookup and if not ignored will cause the server to always rebuild
      security_groups,               # this is dependant on the aws security group lookup and if not ignored will cause the server to always rebuild
    ]
  }
}
