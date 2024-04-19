locals {
  use_strategy = var.use_strategy
  find_type    = var.type
  # tflint-ignore: terraform_unused_declarations
  fail_type = ((local.use_strategy == "find" && local.type == "") ? one([local.type, "missing_find_type"]) : false)
  image     = var.image
  # tflint-ignore: terraform_unused_declarations
  fail_image = ((local.use_strategy == "select" && local.image["id"] == "") ? one([local.image, "missing_select_image_id"]) : false)

  # path
  search = (local.use_strategy == "find" ? true : false)
  select = (local.use_strategy == "select" ? true : false)

  # find
  type         = (local.search ? local.types[local.find_type] : null)
  owners       = (local.search ? local.type.owners : [])
  architecture = (local.search ? local.type.architecture : null)
  name         = (local.search ? local.type.name : null)
  name_regex   = (local.search ? local.type.name_regex : null)
  user         = (local.search ? local.type.user : local.image.user)
  admin_group  = (local.search ? local.type.group : local.image.admin_group)
  workfolder   = (local.search ? local.type.workfolder : local.image.workfolder)
}

data "aws_ami" "search" {
  count       = (local.search ? 1 : 0)
  most_recent = true
  owners      = local.owners
  name_regex  = local.name_regex

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
    values = [local.image["id"]]
  }
}
