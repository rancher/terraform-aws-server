module "TestCis" {
  source                     = "../../../"
  image                      = "sles-15-cis"
  server_owner               = "terraform"
  server_name                = "test-cis"
  server_type                = "small"
  server_user                = "terraform"
  server_ssh_key             = "ssh-abc yOur+key name@example.com"
  server_subnet_name         = "tf-test"
  server_security_group_name = "tf-test"
}
