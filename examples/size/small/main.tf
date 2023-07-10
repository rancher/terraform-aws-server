module "TestSmall" {
  source                     = "../../../"
  image                      = "sles-15"
  server_owner               = "terraform"
  server_name                = "test-small"
  server_type                = "small"
  server_user                = "testsmall"
  server_ssh_key             = "ssh-abc yOur+public+key name@example.com"
  server_subnet_name         = "my-subnet"
  server_security_group_name = "my-security-group"
}
