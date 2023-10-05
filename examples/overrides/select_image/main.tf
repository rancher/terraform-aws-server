module "TestSelectImage" {
  source = "../../../" # change this to "rancher/server/aws" per https://registry.terraform.io/modules/rancher/server/aws/latest
  # version = "v0.0.15" # when using this example you will need to set the version
  image = "sles-15"
}
