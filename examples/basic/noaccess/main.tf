provider "aws" {
  default_tags {
    tags = {
      Id = local.identifier
    }
  }
}

locals {
  identifier = var.identifier # this is a random unique string that can be used to identify resources in the cloud provider
  category   = "basic"
  example    = "noaccess"
  email      = "terraform-ci@suse.com"
  name       = "tf-${local.category}-${local.example}-${local.identifier}"
  username   = "tf-${local.identifier}"
}

# selecting the vpc, subnet, and ssh key pair, generating a security group specific to the runner
module "aws_access" {
  source              = "rancher/access/aws"
  version             = "v1.0.0"
  owner               = local.email
  vpc_name            = local.name
  vpc_cidr            = "10.0.255.0/24" # gives 256 usable addresses from .1 to .254, but AWS reserves .1 to .4 and .255, leaving .5 to .254
  subnet_name         = local.name
  subnet_cidr         = "10.0.255.224/28" # gives 14 usable addresses from .225 to .238, but AWS reserves .225 to .227 and .238, leaving .227 to .237
  availability_zone   = "us-west-1b"      # check what availability zones are available in your region before setting this
  security_group_name = local.name
  security_group_type = "internal"
  skip_ssh            = true
}

# we are expecting the server to not get a public ip, preventing outside access
module "this" {
  depends_on = [
    module.aws_access,
  ]
  source = "../../../" # change this to "rancher/server/aws" per https://registry.terraform.io/modules/rancher/server/aws/latest
  # version = "v0.0.15" # when using this example you will need to set the version
  image               = "sles-15"
  owner               = local.email
  name                = local.name
  type                = "small"
  user                = local.username
  subnet_name         = local.name
  security_group_name = local.name
  cloudinit_timeout   = "6"
  skip_key            = true # don't associate an ssh key to the server
  # the config automatically disables scripts when not assigning an ssh key
  #disable_scripts = true # disable running scripts on the server
}
