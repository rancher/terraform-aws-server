
module "TestServerOnly" {
  source                     = "../../../"
  image_id                   = "ami-09b2a1e33ce552e68" # this must be an AMI in your region
  image_admin_group          = "admin"
  image_initial_user         = "ubuntu"
  server_owner               = "terraform"
  server_name                = "test-server-only"
  server_type                = "small"
  server_user                = "terraform"
  server_ssh_key             = "ssh-ed25519 your+public+ssh+key you@example.com"
  server_subnet_name         = "default"
  server_security_group_name = "default"
}
