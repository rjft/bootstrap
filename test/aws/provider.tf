terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.57"
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
      source = "hashicorp/local"
      version = "2.4.1"
    }
  }
}

provider "aws" {
  region = "us-east-2"
}

data "aws_eks_cluster" "cluster" {
  name = module.mgmt.cluster_name

  depends_on = [ module.mgmt.cluster_name ]
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.mgmt.cluster_name

  depends_on = [ module.mgmt.cluster_name ]
}

provider "kubernetes" {
  host                   = module.mgmt.cluster_endpoint
  cluster_ca_certificate = base64decode(module.mgmt.cluster_certificate_authority_data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

provider "helm" {
  kubernetes {
    host                   = module.mgmt.cluster_endpoint
    cluster_ca_certificate = base64decode(module.mgmt.cluster_certificate_authority_data)
    token                  = data.aws_eks_cluster_auth.cluster.token
  }
}
