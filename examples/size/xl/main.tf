module "TestXl" {
  source                   = "../../../"
  image                    = "sles-15"
  server_owner             = "terraform"
  server_name              = "test-xl"
  server_type              = "xl"
  server_user              = "terraform"
  server_ssh_key           = "ssh-abc yOur+key name@example.com"
  server_subnet_id         = "tf-test"
  server_security_group_id = "tf-test"
}
