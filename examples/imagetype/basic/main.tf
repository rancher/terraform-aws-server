## This example shows how to use the image type search to find images in AWS
# If you need to find a different AMI or add to the types this should help
provider "aws" {
  default_tags {
    tags = {
      Id    = local.identifier
      Owner = "terraform-ci@suse.com"
    }
  }
}

locals {
  identifier  = var.identifier # this is a random unique string that can be used to identify resources in the cloud provider
  types       = module.info.types
  image_info  = { for k, v in local.types : k => module.this[k] }
  image_names = { for k, v in local.types : k => module.this[k].name }
}
module "info" {
  source       = "../../../modules/image"
  use_strategy = "skip"
}
module "this" {
  depends_on   = [module.info]
  for_each     = toset(keys(local.types))
  source       = "../../../modules/image"
  use_strategy = "find"
  type         = each.key
}
