locals {
  category       = "size"
  example        = "xxl"
  email          = "terraform-ci@suse.com"
  name           = "terraform-aws-server-test-${local.category}-${local.example}"
  username       = "terraform-ci"
  image          = "sles-15"
  size           = "xxl"
  public_ssh_key = var.key      # I don't normally recommend this, but it allows tests to supply their own key
  key_name       = var.key_name # A lot of troubleshooting during critical times can be saved by hard coding variables in root modules
  # root modules should be secured properly (including the state), and should represent your running infrastructure
}

# selecting the vpc, subnet, and ssh key pair, generating a security group specific to the runner
module "aws_access" {
  source              = "github.com/rancher/terraform-aws-access"
  owner               = local.email
  vpc_name            = "default"
  subnet_name         = "default"
  security_group_name = local.username
  security_group_type = "specific"
  ssh_key_name        = local.key_name
}

module "TestXxl" {
  depends_on                 = [module.aws_access]
  source                     = "../../../"
  image                      = local.image
  server_owner               = local.email
  server_name                = local.name
  server_type                = local.size
  server_user                = local.username
  server_ssh_key             = local.public_ssh_key
  server_subnet_name         = "default"
  server_security_group_name = module.aws_access.security_group.name
}
