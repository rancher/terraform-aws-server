module "TestUbuntu22" {
  source                     = "../../../"
  image                      = "ubuntu-22"
  server_owner               = "terraform"
  server_name                = "test"
  server_type                = "small"
  server_user                = "terraform"
  server_ssh_key             = "ssh-ed25519 your+publicSSHkey test@example.com"
  server_subnet_name         = "test"
  server_security_group_name = "test"
}
