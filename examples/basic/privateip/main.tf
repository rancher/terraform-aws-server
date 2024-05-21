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
  category     = "basic"
  example      = "basic"
  email        = "terraform-ci@suse.com"
  project_name = "tf-${substr(md5(join("-", [local.category, local.example, md5(local.identifier)])), 0, 5)}-${local.identifier}"
  image        = "sles-15"
  vpc_cidr     = "10.0.0.0/16"
  subnet_cidr  = "10.0.248.0/24"
  private_ip   = "10.0.248.230" # must be within the subnet cidr range
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
  security_group_name        = "${local.project_name}-sg"
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
  server_name         = "${local.project_name}-${random_pet.server.id}"
  server_type         = "small"
  subnet_name         = module.access.subnets[keys(module.access.subnets)[0]].tags_all.Name
  private_ip          = local.private_ip
  security_group_name = module.access.security_group.tags_all.Name
}
