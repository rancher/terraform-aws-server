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
  project_name = "tf-${substr(md5(join("-", [local.category, local.example, md5(local.identifier)])), 0, 5)}-${local.identifier}"
  vpc_cidr     = "10.0.255.0/24" # gives 256 usable addresses from .1 to .254, but AWS reserves .1 to .4 and .255, leaving .5 to .254
  subnet_cidr  = "10.0.255.224/28"
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
  source   = "rancher/access/aws"
  version  = "v2.1.2"
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

module "setup" {
  depends_on = [
    module.access,
  ]
  source = "../../../" # change this to "rancher/server/aws" per https://registry.terraform.io/modules/rancher/server/aws/latest
  # version = "v2.0.0" # when using this example you will need to set the version
  image_use_strategy = "select"
  image = {
    id          = "ami-0e8ad69da124219b7" # must be a valid ami in your region
    user        = "ec2-user"
    admin_group = "wheel"
    workfolder  = "~"
  }
  server_name         = local.project_name
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
    id          = "ami-0e8ad69da124219b7" # must be a valid ami in your region
    user        = "ec2-user"
    admin_group = "wheel"
    workfolder  = "~"
  }
  server_use_strategy = "select"
  server_id           = module.setup.server[0].id
}