provider "aws" {
  default_tags {
    tags = {
      Id    = local.identifier
      Owner = local.email
    }
  }
}

locals {
  identifier = var.identifier # this is a random unique string that can be used to identify resources in the cloud provider
  email      = "terraform-ci@suse.com"
  types      = module.types.types
  image_info = { for k, v in local.types : k => module.images[k] }
  image_ids  = { for k, v in local.types : k => local.image_info[k].id }
}
module "types" {
  source       = "../../../modules/image"
  use_strategy = "skip"
}
module "images" {
  depends_on = [
    module.types,
  ]
  for_each     = toset(keys(local.types))
  source       = "../../../modules/image"
  use_strategy = "find"
  type         = each.key
}
module "this" {
  depends_on = [
    module.types,
    module.images,
  ]
  source = "../../../" # change this to "rancher/server/aws" per https://registry.terraform.io/modules/rancher/server/aws/latest
  # version = "v2.0.0" # when using this example you will need to set the version
  server_use_strategy = "skip"
  image_use_strategy  = "select"
  image = {
    id          = values(local.image_ids)[0]
    user        = "ec2-user"
    admin_group = "wheel"
    workfolder  = "~"
  }
}
