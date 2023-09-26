locals {
  identifier     = var.identifier # this is a random unique string that can be used to identify resources in the cloud provider
  category       = "securitygroups"
  example        = "specific"
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
  version             = "v0.0.6"
  owner               = local.email
  vpc_name            = "default"
  subnet_name         = "default"
  security_group_name = local.name
  security_group_type = "specific"
  ssh_key_name        = local.key_name
}

module "TestSpecific" {
  depends_on = [
    module.aws_access,
  ]
  source              = "../../../"
  image               = local.image
  owner               = local.email
  name                = local.name
  type                = "small"
  user                = local.username
  ssh_key             = module.aws_access.ssh_key.public_key
  subnet_name         = "default"
  security_group_name = module.aws_access.security_group_name
}
