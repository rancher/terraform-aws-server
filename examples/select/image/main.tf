provider "aws" {
  default_tags {
    tags = {
      Id    = local.identifier
      Owner = local.email
    }
  }
}

locals {
  identifier   = var.identifier # this is a random unique string that can be used to identify resources in the cloud provider
  email        = "terraform-ci@suse.com"
}

module "this" {
  source = "../../../" # change this to "rancher/server/aws" per https://registry.terraform.io/modules/rancher/server/aws/latest
  # version = "v2.0.0" # when using this example you will need to set the version
  server_use_strategy = "skip"
  image_use_strategy = "select"
  image = {
    id          = "ami-0e8ad69da124219b7" # must be a valid ami in your region
    user        = "ec2-user"
    admin_group = "wheel"
    workfolder  = "~"
  }
}
