terraform {
  required_version = ">= 1.0.0, <= 1.2.6"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 3.68.0"
    }
  }
}