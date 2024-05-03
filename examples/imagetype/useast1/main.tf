## This example shows how to use the image type search to find images in AWS
# If you need to find a different AMI or add to the types this should help
provider "aws" {
  default_tags {
    tags = {
      Id    = local.identifier
      Owner = "terraform-ci@suse.com"
    }
  }
  region = "us-east-1"
}

locals {
  identifier = var.identifier # this is a random unique string that can be used to identify resources in the cloud provider
  types = [
    "sles-15",
    "sles-15-byos",
    "sles-15-cis",
    "sle-micro-55-ltd",
    "sle-micro-55-byos",
    "rhel-8-cis",
    "ubuntu-20",
    "ubuntu-22",
    "rocky-8",
    "liberty-7",
    "rhel-8",
    "rhel-9",
  ]
  image_info = { for type in local.types : type => module.this[type] }
}

module "this" {
  for_each     = toset(local.types)
  source       = "../../../modules/image"
  use_strategy = "find"
  type         = each.key
}
