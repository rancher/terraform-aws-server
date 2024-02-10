terraform {
  required_version = ">= 1.5.0, < 1.6"
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = ">= 2.4"
    }
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.11"
    }
    # NOTE: this is only required for the examples
    # this is used by the aws_access module
    http = {
      source  = "hashicorp/http"
      version = ">= 3.4"
    }
  }
}