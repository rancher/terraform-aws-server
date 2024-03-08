provider "aws" {
  default_tags {
    tags = {
      Id = local.identifier
    }
  }
}

locals {
  identifier = var.identifier # this is a random unique string that can be used to identify resources in the cloud provider
  category   = "overrides"
  example    = "association"
  email      = "terraform-ci@suse.com"
  setup      = "tf-${local.category}-${local.example}-${local.identifier}"
  name       = "tf-${local.category}-${local.example}-${local.identifier}-sut"
  image      = "ami-09b2a1e33ce552e68" # this must be an AMI in your region
  key_name   = var.key_name
  server_id  = var.server
}

module "access" {
  source              = "rancher/access/aws"
  version             = "v1.1.1"
  owner               = local.email
  vpc_name            = local.setup
  subnet_name         = local.setup
  security_group_name = local.name
  security_group_type = "specific"
  ssh_key_name        = local.key_name
}

module "this" {
  depends_on = [
    module.access,
  ]
  source              = "../../../"
  image_id            = local.image
  image_initial_user  = "ec2-user"
  image_admin_group   = "wheel"
  image_workfolder    = "~"
  owner               = local.email
  name                = local.name
  id                  = local.server_id # server must already exist outside of this terraform config, see ./setup/
  subnet_name         = local.setup
  security_group_name = local.name

  # usually when selecting a server nothing is created,
  # with this flag we force the association of the new security group on the server
  security_group_association_force_create = true
}
