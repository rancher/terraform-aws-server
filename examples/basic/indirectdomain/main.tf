provider "aws" {
  default_tags {
    tags = {
      Id    = local.identifier
      Owner = local.email
    }
  }
}
# WARNING! the ACME_SERVER_URL environment variable must be set or certificate validation will fail.
locals {
  identifier   = var.identifier # this is a random unique string that can be used to identify resources in the cloud provider
  category     = "basic"
  example      = "indirectdomain"
  email        = "terraform-ci@suse.com"
  project_name = substr("tf-${substr(md5(join("-", [local.category, local.example, md5(local.identifier)])), 0, 5)}-${local.identifier}", 0, 25)
  lb_target    = substr("${local.project_name}-ping", 0, 32)
  image        = "sles-15"
  port         = 443
  ip           = chomp(data.http.myip.response_body)
  zone         = var.zone # the zone must already exist in route53
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

data "http" "myip" {
  url = "https://ipinfo.io/ip"
  retry {
    attempts     = 2
    min_delay_ms = 1000
  }
}

module "access" {
  source                     = "rancher/access/aws"
  version                    = "v3.0.1"
  vpc_name                   = "${local.project_name}-vpc"
  security_group_name        = "${local.project_name}-sg"
  security_group_type        = "project" # by default only allow access within the vpc
  domain                     = "${local.project_name}.${local.zone}"
  domain_zone                = local.zone
  load_balancer_use_strategy = "create"
  load_balancer_name         = "${local.project_name}-lb"
  load_balancer_access_cidrs = {
    ping = {
      port        = local.port
      protocol    = "tcp"
      cidrs       = ["${local.ip}/32"] # expose this ip for external ingress
      target_name = local.lb_target
    }
  }
}

module "this" {
  depends_on = [
    module.access,
  ]
  source = "../../../" # change this to "rancher/server/aws" per https://registry.terraform.io/modules/rancher/server/aws/latest
  # version = "v1.1.1" # when using this example you will need to set the version
  image_type                   = local.image
  server_name                  = "${local.project_name}-${random_pet.server.id}"
  server_type                  = "small"
  subnet_name                  = keys(module.access.subnets)[0]
  security_group_name          = module.access.security_group.tags_all.Name
  indirect_access_use_strategy = "enable"
  load_balancer_target_groups  = [local.lb_target]
}
