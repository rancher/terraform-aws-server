
module "TestBasic" {
  source                     = "../../"
  image                      = "sles-15"
  server_owner               = "terraform"
  server_name                = "terraform-test-basic"
  server_type                = "small"
  server_user                = "testbasic"
  server_ssh_key             = "ssh-abc yOur+key name@example.com"
  server_subnet_name         = "subnet-123abc"
  server_security_group_name = "sg-0123abc"
}
