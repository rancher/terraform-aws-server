module "TestXxl" {
  source                     = "../../../"
  image                      = "sles-15"
  server_owner               = "terraform"
  server_name                = "test-xxl"
  server_type                = "xxl"
  server_user                = "terraform"
  server_ssh_key             = "ssh-ed25519 your+publicSSHkey you@example.com"
  server_subnet_name         = "tf-test"
  server_security_group_name = "tf-test"
}
