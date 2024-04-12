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
  email        = "terraform-ci@suse.com"
  category     = "basic"
  example      = "noaccess"
  project_name = "tf-${local.category}-${local.example}-${local.identifier}"
  image        = "sles-15"
  zone         = var.zone
}

resource "random_pet" "server" {
  keepers = {
    # regenerate the pet name when the identifier changes
    identifier = local.identifier
  }
  length = 1
}

module "access" {
  source                     = "rancher/access/aws"
  version                    = "v2.0.0"
  vpc_name                   = "vpc-${local.project_name}"
  vpc_cidr                   = "10.0.255.0/24"            # gives 256 usable addresses from .1 to .254, but AWS reserves .1 to .4 and .255, leaving .5 to .254
  security_group_name        = "fw-${local.project_name}" # quirk, because we name the security groups for this object the same name, this name must be unique
  security_group_type        = "project"
  load_balancer_use_strategy = "skip"
}

# # we are expecting the server to not get a public ip, preventing outside access
# module "this" {
#   depends_on = [
#     module.access,
#   ]
#   source = "../../../" # change this to "rancher/server/aws" per https://registry.terraform.io/modules/rancher/server/aws/latest
#   # version = "v1.1.1" # when using this example you will need to set the version
#   image_type          = local.image
#   server_name         = "${random_pet.server.id}-${local.project_name}"
#   server_type         = "small"
#   subnet_name         = module.access.subnets[keys(module.access.subnets)[0]].tags_all.Name
#   security_group_name = module.access.security_group.tags_all.Name
#   server_domain       = "${random_pet.server.id}-${local.identifier}.${local.zone}"
#   load_balancer_name  = module.access.load_balancer.tags_all.Name
#   add_public_ip       = false
#   setup_server        = false
# }
