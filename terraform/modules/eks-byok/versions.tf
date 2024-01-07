terraform {
  required_providers {
    plural = {
      source = "pluralsh/plural"
      version = ">= 0.2.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.57"
    }
  }
}