provider "aws" {
  default_tags {
    tags = {
      Id    = local.identifier
      Owner = local.email
    }
  }
}

locals {
  identifier   = var.identifier # this is a random unique string that can be used to identify resources in the cloud provider
  category     = "select"
  example      = "server"
  email        = "terraform-ci@suse.com"
  project_name = trimsuffix(substr("tf-${local.identifier}-${substr(md5(join("-", [local.category, local.example, md5(local.identifier)])), 0, 5)}", 0, 25), "-")
  types        = module.types.types
  image_info   = { for k, v in local.types : k => module.images[k] }
  image_ids    = { for k, v in local.types : k => local.image_info[k].id }
}

resource "random_pet" "server" {
  keepers = {
    # regenerate the pet name when the identifier changes
    identifier = local.identifier
  }
  length = 1
}

data "aws_availability_zones" "available" {
  state = "available"
}

module "access" {
  source                     = "rancher/access/aws"
  version                    = "v3.1.4"
  vpc_name                   = substr("${local.project_name}-vpc", 0, 32)
  security_group_name        = substr("${local.project_name}-sg", 0, 32) # quirk, this name must be unique accross object types and can't start with 'sg-'
  security_group_type        = "project"
  load_balancer_use_strategy = "skip"
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
module "setup" {
  depends_on = [
    module.access,
    module.images,
  ]
  source = "../../../" # change this to "rancher/server/aws" per https://registry.terraform.io/modules/rancher/server/aws/latest
  # version = "v2.0.0" # when using this example you will need to set the version
  image_use_strategy = "select"
  image = {
    id          = values(local.image_ids)[0]
    user        = "ec2-user"
    admin_group = "wheel"
    workfolder  = "~"
  }
  server_name         = substr("${local.project_name}-${random_pet.server.id}", 0, 32)
  server_type         = "small"
  subnet_name         = keys(module.access.subnets)[0]
  security_group_name = module.access.security_group.tags_all.Name
}

module "this" {
  depends_on = [
    module.setup,
    module.access,
  ]
  source = "../../../" # change this to "rancher/server/aws" per https://registry.terraform.io/modules/rancher/server/aws/latest
  # version = "v2.0.0" # when using this example you will need to set the version
  image_use_strategy = "select"
  image = {
    id          = values(local.image_ids)[0]
    user        = "ec2-user"
    admin_group = "wheel"
    workfolder  = "~"
  }
  server_use_strategy = "select"
  server_id           = module.setup.server.id
}
