## This example shows how to use the image sub module to get information about an AMI
# If you need to find a different AMI or add to the types this should help
provider "aws" {
  default_tags {
    tags = {
      Id    = local.identifier
      Owner = "terraform-ci@suse.com"
    }
  }
}

locals {
  identifier = var.identifier # this is a random unique string that can be used to identify resources in the cloud provider
}

module "simple" {
  source       = "../../../modules/image"
  use_strategy = "select"
  image = {
    id          = "ami-0e8ad69da124219b7"
    user        = "ec2-user"
    admin_group = "wheel"
    workfolder  = "~"
  }
}
