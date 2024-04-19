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
    random = {
      source  = "hashicorp/random"
      version = ">= 3.1"
    }
    http = {
      source  = "hashicorp/http"
      version = ">= 3.4"
    }
  }
}