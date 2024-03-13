locals {
  id           = var.id
  search       = (local.id == "" ? true : false) # search if no id is given
  select       = (local.id == "" ? false : true) # select if id is given
  type         = (local.search ? local.types[var.type] : null)
  owners       = (local.search ? local.type.owners : [])
  architecture = (local.search ? local.type.architecture : null)
  name         = (local.search ? local.type.name : null)

  initial_user = (local.search ? local.type.user : var.initial_user)
  admin_group  = (local.search ? local.type.group : var.admin_group)
  workfolder   = (local.search ? local.type.workfolder : var.workfolder)
}

data "aws_ami" "search" {
  count       = (local.search ? 1 : 0)
  most_recent = true
  owners      = local.owners

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = [local.architecture]
  }

  filter {
    name   = "name"
    values = [local.name]
  }
}

data "aws_ami" "select" {
  count = (local.select ? 1 : 0)
  filter {
    name   = "image-id"
    values = [local.id]
  }
}