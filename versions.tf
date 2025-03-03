terraform {
  required_version = ">= 1.5.0"
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = ">= 2.4"
    }
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.11"
    }
    cloudinit = {
      source  = "hashicorp/cloudinit"
      version = ">= 2.3.3"
    }
  }
}
