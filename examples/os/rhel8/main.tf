
module "TestRhel8" {
  source                     = "../../../"
  image                      = "rhel-8"
  server_owner               = "terraform"
  server_name                = "test"
  server_type                = "small"
  server_user                = "terraform"
  server_ssh_key             = "ssh-ed25519 public+ssh+key test@example.com"
  server_subnet_name         = "terraform"
  server_security_group_name = "terraform"
}