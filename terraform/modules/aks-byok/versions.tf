terraform {
  required_providers {
    plural = {
      source = "pluralsh/plural"
      version = ">= 0.2.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.51.0, < 4.0"
    }
  }
}