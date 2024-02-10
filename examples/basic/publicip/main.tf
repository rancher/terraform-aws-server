provider "aws" {
  default_tags {
    tags = {
      Id = local.identifier
    }
  }
}

locals {
  identifier  = var.identifier # this is a random unique string that can be used to identify resources in the cloud provider
  category    = "basic"
  example     = "publicip"
  email       = "terraform-ci@suse.com"
  name        = "tf-${local.category}-${local.example}-${local.identifier}"
  username    = "tf-${local.identifier}"
  subnet_cidr = "10.0.255.224/28" # gives 14 usable addresses from .225 to .238, but AWS reserves .225 to .227 and .238, leaving .228 to .237
}

# selecting the vpc, subnet, and ssh key pair, generating a security group specific to the runner
module "aws_access" {
  source              = "rancher/access/aws"
  version             = "v1.1.1"
  owner               = local.email
  vpc_name            = local.name
  vpc_cidr            = "10.0.255.0/24" # gives 255 usable addresses from .1 to .255, but AWS reserves .1 to .4 and .255, leaving .5 to .254
  subnet_name         = local.name
  subnet_cidr         = local.subnet_cidr
  availability_zone   = "us-west-1b" # check what availability zones are available in your region before setting this
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
  private_ip          = cidrhost(local.subnet_cidr, -2) # get next to last ip from cidr, should be 10.0.255.254
  add_public_ip       = true
  ssh_key             = var.key
  ssh_key_name        = var.key_name
  disable_scripts     = true # disable running scripts on the server, this includes the usual initialization scripts
  # generally you should include a cloud-init script to initialize the server if using this option
  cloudinit_timeout = "10"
  cloudinit_script  = file("${path.root}/init.sh")
}
