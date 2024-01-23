provider "aws" {
  region = "us-west-2"
  default_tags {
    tags = {
      Id = local.identifier
    }
  }
}

locals {
  identifier     = var.identifier # this is a random unique string that can be used to identify resources in the cloud provider
  category       = "region"
  example        = "uswest2"
  email          = "terraform-ci@suse.com"
  name           = "tf-aws-server-${local.category}-${local.example}-${local.identifier}"
  username       = "tf-ci-${local.identifier}"
  image          = "sles-15"
  public_ssh_key = var.key      # I don't normally recommend this, but it allows tests to supply their own key
  key_name       = var.key_name # A lot of troubleshooting during critical times can be saved by hard coding variables in root modules
  # root modules should be secured properly (including the state), and should represent your running infrastructure
}

# selecting the vpc, subnet, and ssh key pair, generating a security group specific to the runner
module "aws_access" {
  source              = "rancher/access/aws"
  version             = "v1.0.0"
  owner               = local.email
  vpc_name            = "test"
  subnet_name         = "test"
  security_group_name = local.name
  security_group_type = "specific"
  ssh_key_name        = local.key_name
}
# aws_access returns a security group object from the aws api, but the name attribute isn't the same as the Name tag
# this is an rare example of when the name attribute is different than the Name tag
module "TestUswest2" {
  depends_on = [module.aws_access]
  source     = "../../../" # change this to "rancher/server/aws" per https://registry.terraform.io/modules/rancher/server/aws/latest
  # version = "v0.0.15" # when using this example you will need to set the version
  image               = local.image
  owner               = local.email
  name                = local.name
  type                = "small"
  user                = local.username
  ssh_key             = local.public_ssh_key
  ssh_key_name        = local.key_name
  subnet_name         = "test"
  security_group_name = local.name # WARNING: security_group.name isn't the same as security_group->tags->Name
}
