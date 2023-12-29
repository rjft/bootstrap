terraform {
  required_version = ">=1.3"

  backend "azurerm" {
    storage_account_name = "{{ .Context.StorageAccount }}"
    resource_group_name = "{{ .Project }}"
    container_name = "{{ .Bucket }}"
    key = "{{ .Cluster }}/apps/terraform.tfstate"
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.51.0, < 4.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.10"
    }
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}



data "azurerm_kubernetes_cluster" "cluster" {
  name = "{{ .Cluster }}"
  resource_group_name = "{{ .Project }}"
}

provider "kubernetes" {
  host                   = data.azurerm_kubernetes_cluster.cluster.kube_config[0].host
  client_certificate     = base64decode(data.azurerm_kubernetes_cluster.cluster.kube_config[0].client_certificate)
  client_key             = base64decode(data.azurerm_kubernetes_cluster.cluster.kube_config[0].client_key)
  cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.cluster.kube_config[0].cluster_ca_certificate)
}
