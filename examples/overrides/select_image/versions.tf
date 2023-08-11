terraform {
  required_version = ">= 1.2.0"
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = ">= 2.4"
    }
  }
}