terraform {
  required_version = ">=1.3"

  backend "azurerm" {
    storage_account_name = "{{ .Context.StorageAccount }}"
    resource_group_name = "{{ .Project }}"
    container_name = "{{ .Bucket }}"
    key = "{{ .Cluster }}/bootstrap/terraform.tfstate"
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
      version = "3.6.0"
    }
    helm = {
      source = "hashicorp/helm"
      version = "2.12.1"
    }
    local = {
      souce = "hashicorp/local"
      version = "2.4.1"
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

provider "kubernetes" {
  host                   = module.azure.cluster.cluster_fqdn
  cluster_ca_certificate = base64decode(module.azure.cluster.cluster_ca_certificate)
  client_certificate     = base64decode(module.azure.cluster.client_certificate)
  client_key             = base64decode(module.azure.cluster.client_key)
}

provider "helm" {
  kubernetes {
    host                   = module.azure.cluster.cluster_fqdn
    cluster_ca_certificate = base64decode(module.azure.cluster.cluster_ca_certificate)
    client_certificate     = base64decode(module.azure.cluster.client_certificate)
    client_key             = base64decode(module.azure.cluster.client_key)
  }
}