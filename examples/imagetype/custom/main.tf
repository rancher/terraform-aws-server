## This example shows how to use the image type search to find images in AWS
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
  custom_types = {
    # tflint-ignore: terraform_deprecated_interpolation
    "${local.identifier}" = {
      user         = "suse"
      group        = "wheel"
      name         = "suse-sle-micro-5-4-byos-v*-hvm-ssd-x86_64"
      name_regex   = ".*"
      product_code = ""
      owners       = ["679593333241", "013907871322"]
      architecture = "x86_64"
      workfolder   = "~"
    }
  }
}

module "this" {
  source       = "../../../modules/image"
  use_strategy = "find"
  type         = local.identifier
  custom_types = local.custom_types
}
