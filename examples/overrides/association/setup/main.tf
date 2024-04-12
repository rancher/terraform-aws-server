provider "aws" {
  default_tags {
    tags = {
      Id = local.identifier
    }
  }
}

locals {
  identifier     = var.identifier # this is a random unique string that can be used to identify resources in the cloud provider
  category       = "overrides"
  example        = "association"
  email          = "terraform-ci@suse.com"
  name           = "tf-${local.category}-${local.example}-${local.identifier}"
  username       = "tf-${local.identifier}"
  image          = "ami-09b2a1e33ce552e68" # this must be an AMI in your region
  public_ssh_key = var.key
  key_name       = var.key_name
}

module "setup_access" {
  source              = "rancher/access/aws"
  version             = "v1.1.1"
  owner               = local.email
  vpc_name            = local.name
  vpc_cidr            = "10.0.255.0/24" # gives 256 usable addresses from .1 to .254, but AWS reserves .1 to .4 and .255, leaving .5 to .254
  subnet_name         = local.name
  subnet_cidr         = "10.0.255.224/28" # gives 14 usable addresses from .225 to .238, but AWS reserves .225 to .227 and .238, leaving .227 to .237
  security_group_name = local.name
  security_group_type = "specific"
  skip_ssh            = true
}

# module "this" {
#   depends_on = [
#     module.setup_access,
#   ]
#   source              = "../../../../"
#   image_id            = local.image # if you specify an image_id, you must also specify the initial_user, admin_group, and workfolder
#   image_initial_user  = "ec2-user"
#   image_admin_group   = "wheel"
#   image_workfolder    = "~"
#   owner               = local.email
#   name                = local.name
#   type                = "small"
#   user                = local.username
#   ssh_key             = local.public_ssh_key
#   ssh_key_name        = local.key_name
#   subnet_name         = local.name
#   security_group_name = local.name
# }
