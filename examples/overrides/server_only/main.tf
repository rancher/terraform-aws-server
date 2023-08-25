
locals {
  category       = "overrides"
  example        = "server-only"
  email          = "terraform-ci@suse.com"
  name           = "terraform-aws-server-test-${local.category}-${local.example}"
  username       = "terraform-ci"
  image          = "ami-09b2a1e33ce552e68" # this must be an AMI in your region
  public_ssh_key = var.key                 # I don't normally recommend this, but it allows tests to supply their own key
  key_name       = var.key_name            # A lot of time troubleshooting during critical times can be saved by hard coding variables in root modules
  # root modules should be secured properly (including the state), and should represent your running infrastructure
}

# selecting the vpc, subnet, and ssh key pair, generating a security group specific to the runner
module "aws_access" {
  source              = "github.com/rancher/terraform-aws-access"
  owner               = local.email
  vpc_name            = "default"
  subnet_name         = "default"
  security_group_name = local.name
  security_group_type = "specific"
  ssh_key_name        = local.key_name
}

# aws_access returns a security group object from the aws api, but the name attribute isn't the same as the Name tag
# this is an rare example of when the name attribute is different than the Name tag
module "TestServerOnly" {
  depends_on                 = [module.aws_access]
  source                     = "../../../"
  image_id                   = local.image # if you specify an image_id, you must also specify the admin_group and initial_user
  image_admin_group          = "wheel"     # if you specify an image_id, you must also specify the admin_group and initial_user
  image_initial_user         = "ec2-user"  # if you specify an image_id, you must also specify the admin_group and initial_user
  server_owner               = local.email
  server_name                = local.name
  server_type                = "small"
  server_user                = local.username
  server_ssh_key             = local.public_ssh_key
  server_subnet_name         = "default"
  server_security_group_name = local.name # WARNING: security_group.name isn't the same as security_group->tags->Name
}
