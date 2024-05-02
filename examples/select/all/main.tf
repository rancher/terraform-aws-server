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
  category   = "overrides"
  example    = "select_all"
  email      = "terraform-ci@suse.com"
  name       = "tf-${local.category}-${local.example}-${local.identifier}"
  image      = "ami-09b2a1e33ce552e68" # this must be an AMI in your region
  server_id  = var.server
}

module "access" {
  source   = "rancher/access/aws"
  version  = "v2.1.1"
  vpc_name = "${local.project_name}-vpc"
  vpc_cidr = local.vpc_cidr
  subnets = {
    "${local.project_name}-sn" = {
      cidr              = local.subnet_cidr
      availability_zone = data.aws_availability_zones.available.names[0]
      public            = false
    }
  }
  security_group_name        = "${local.project_name}-sg" # quirk, this name must be unique accross object types and can't start with 'sg-'
  security_group_type        = "project"
  load_balancer_use_strategy = "skip"
}

module "this" {
  depends_on = [
    module.access,
  ]
  source = "../../../" # change this to "rancher/server/aws" per https://registry.terraform.io/modules/rancher/server/aws/latest
  # version = "v1.1.1" # when using this example you will need to set the version
  image_type          = local.image
  server_use_strategy = "select"
  server_name         = local.project_name
  subnet_name         = keys(module.access.subnets)[0]
  security_group_name = module.access.security_group.tags_all.Name
}
