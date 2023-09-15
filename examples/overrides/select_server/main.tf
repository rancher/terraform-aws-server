module "TestSelectServer" {
  source   = "../../../"
  image_id = "ami-09b2a1e33ce552e68" # this must be an image in your region, it should be the image used to create the server_id
  id       = "i-05d05c6c07c007054"   # this must be an instance in your region
}
