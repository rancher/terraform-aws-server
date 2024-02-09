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
  example        = "select_all"
  email          = "terraform-ci@suse.com"
  name           = "tf-aws-server-${local.category}-${local.example}-${local.identifier}"
  username       = "tf-ci-${local.identifier}"
  image          = "ami-09b2a1e33ce552e68" # this must be an AMI in your region
  public_ssh_key = var.key
  key_name       = var.key_name
  server_id      = var.server
}

# selecting the vpc, subnet, and ssh key pair, generating a security group specific to the runner
module "aws_access" {
  source              = "rancher/access/aws"
  version             = "v1.1.1"
  owner               = local.email
  vpc_name            = "default"
  subnet_name         = "default"
  security_group_name = local.name
  security_group_type = "specific"
  ssh_key_name        = local.key_name
}

module "this" {
  depends_on = [
    module.aws_access,
  ]
  source              = "../../../"
  image_id            = local.image
  image_initial_user  = "ec2-user"
  image_admin_group   = "wheel"
  image_workfolder    = "~"
  owner               = local.email
  name                = local.name
  id                  = local.server_id # server must already exist outside of this terraform config
  subnet_name         = "default"
  security_group_name = local.name
}
