terraform {
  backend "gcs" {
    bucket = "{{ .Bucket }}"
    prefix = "{{ .Cluster }}/bootstrap"
  }

  required_providers {
    google = {
      source = "hashicorp/google"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
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
  required_version = ">= 0.13"
}

data "google_client_config" "default" {}

provider "helm" {
  kubernetes {
    host                   = module.gcp.cluster.endpoint
    cluster_ca_certificate = base64decode(module.gcp.cluster.ca_certificate)
    token                  = data.google_client_config.current.access_token
  }
}