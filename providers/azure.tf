terraform {
  required_version = ">=1.3"

  backend "azurerm" {
    storage_account_name = "{{ .Context.StorageAccount }}"
    resource_group_name = "{{ .Project }}"
    container_name = "{{ .Bucket }}"
    key = "{{ .Cluster }}/terraform.tfstate"
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.51.0, < 4.0"
    }
    curl = {
      source  = "anschoewe/curl"
      version = "1.0.2"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.10"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.3.2"
    }
    helm = {
      source = "hashicorp/helm"
      version = "2.12.1"
    }
  }
}

provider "curl" {}

provider "random" {}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}