locals {
  use_strategy = var.use_strategy
  find_type    = var.type
  # tflint-ignore: terraform_unused_declarations
  fail_type = ((local.use_strategy == "find" && local.type == "") ? one([local.type, "missing_find_type"]) : false)
  image     = var.image
  # tflint-ignore: terraform_unused_declarations
  fail_image = ((local.use_strategy == "select" && local.image == null) ? one([local.image, "missing_select_image"]) : false)
  # tflint-ignore: terraform_unused_declarations
  fail_image_id = ((local.use_strategy == "select" && local.image != null && local.image.id == "") ? one([local.image.id, "missing_select_image_id"]) : false)

  # path
  search = (local.use_strategy == "find" ? true : false)
  select = (local.use_strategy == "select" ? true : false)

  # find
  custom_types = var.custom_types
  types        = merge(local.standard_types, local.custom_types)
  type         = (local.search ? local.types[local.find_type] : null)
  owners       = (local.search ? local.type.owners : [])
  architecture = (local.search ? local.type.architecture : "")
  name         = (local.search ? local.type.name : "")
  name_regex   = (local.search ? local.type.name_regex : "")
  product_code = (local.search ? local.type.product_code : "")
  user         = (local.search ? local.type.user : local.image.user)
  admin_group  = (local.search ? local.type.group : local.image.admin_group)
  workfolder   = (local.search ? local.type.workfolder : local.image.workfolder)
  filters      = { for k, v in { "name" = local.name, "product-code" = local.product_code, "architecture" = local.architecture } : k => v if v != "" }
}

data "aws_ami" "search" {
  count       = (local.search ? 1 : 0)
  most_recent = true
  owners      = local.owners
  name_regex  = local.name_regex

  dynamic "filter" {
    for_each = local.filters
    content {
      name   = filter.key
      values = [filter.value]
    }
  }
}

data "aws_ami" "select" {
  count = (local.select ? 1 : 0)
  filter {
    name   = "image-id"
    values = [local.image.id]
  }
}
