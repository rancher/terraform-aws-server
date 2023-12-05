locals {
  identifier     = var.identifier # this is a random unique string that can be used to identify resources in the cloud provider
  category       = "basic"
  example        = "basic"
  email          = "terraform-ci@suse.com"
  name           = "tf-aws-server-${local.category}-${local.example}-${local.identifier}"
  username       = "tf-${local.identifier}"
  key_name       = var.key_name
  image          = "sles-15"
  public_ssh_key = var.key # I don't normally recommend this, but it allows tests to supply their own key
  # A lot of troubleshooting during critical times can be saved by hard coding variables in root modules
  # root modules should be secured properly (including the state), and should represent your running infrastructure
}

# selecting the vpc, subnet, and ssh key pair, generating a security group specific to the runner
module "aws_access" {
  source              = "rancher/access/aws"
  version             = "v0.1.1"
  owner               = local.email
  vpc_name            = "default"
  subnet_name         = "default"
  security_group_name = local.name
  security_group_type = "specific"
  ssh_key_name        = local.key_name
}

module "basic" {
  depends_on = [
    module.aws_access,
  ]
  source = "../../../" # change this to "rancher/server/aws" per https://registry.terraform.io/modules/rancher/server/aws/latest
  # version = "v0.0.15" # when using this example you will need to set the version
  image               = local.image
  owner               = local.email
  name                = local.name
  type                = "small"
  user                = local.username
  ssh_key             = module.aws_access.ssh_key.public_key
  ssh_key_name        = local.key_name
  subnet_name         = "default"
  security_group_name = local.name # WARNING: security_group.name isn't the same as security_group->tags->Name
}

module "TestSelectServer" {
  depends_on = [
    module.aws_access,
    module.basic,
  ]
  source   = "../../../"
  image_id = "ami-09b2a1e33ce552e68" # this must be an image in your region, it should be the image used to create the server_id
  id       = module.basic.id  # this must be an instance in your region
}
