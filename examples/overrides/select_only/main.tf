
module "TestSelectOnly" {
  source    = "../../../"
  image_id  = "ami-yourtestami"  # this must be an AMI in your region
  server_id = "i-yourtestserver" # this must be an instance in your region
}
