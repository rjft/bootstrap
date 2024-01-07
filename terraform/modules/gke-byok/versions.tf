terraform {
  required_providers {
    plural = {
      source = "pluralsh/plural"
      version = ">= 0.2.0"
    }
    google = {
      source = "hashicorp/google"
    }
  }
}