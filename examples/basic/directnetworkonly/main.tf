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
  example      = "directnetworkonly"
  email        = "terraform-ci@suse.com"
  project_name = "tf-${local.category}-${local.example}-${local.identifier}"
  image        = "sles-15"
  vpc_cidr     = "10.0.255.0/24" # gives 256 usable addresses from .1 to .254, but AWS reserves .1 to .4 and .255, leaving .5 to .254
  subnet_cidr  = "10.0.255.224/28"
  port         = 443 # application port
  protocol     = "tcp" # application protocol
  ip           = chomp(data.http.myip.response_body)
  zone         = var.zone # the zone must already exist in route53 and be globally available
}

data "http" "myip" {
  url = "https://ipinfo.io/ip"
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
  image_type                 = local.image
  server_name                = "${local.project_name}-${random_pet.server.id}"
  server_type                = "small"
  subnet_name                = module.access.subnets[keys(module.access.subnets)[0]].tags_all.Name
  security_group_name        = module.access.security_group.tags_all.Name
  direct_access_use_strategy = "network"
  server_access_addresses    = {
    "runner" = {
      port     = local.port
      protocol = local.protocol
      cidrs    = ["${local.ip}/32"]
    }
  }
}
