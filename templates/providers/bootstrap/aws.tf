terraform {
  required_version = ">= 1.0"

  backend "s3" {
    bucket = "{{ .Bucket }}"
    key = "{{ .Cluster }}/bootstrap/terraform.tfstate"
    region = "{{ .Region }}"
  }

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
      souce = "hashicorp/local"
      version = "2.4.1"
    }
  }
}

provider "aws" {
  region = "{{ .Region }}"
}

data "aws_eks_cluster" "cluster" {
  name = module.aws.cluster.cluster_name
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.aws.cluster.cluster_name
}

provider "kubernetes" {
  host                   = module.aws.cluster.cluster_endpoint
  cluster_ca_certificate = base64decode(module.aws.cluster.cluster_certificate_authority_data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

provider "helm" {
  kubernetes {
    host                   = module.aws.cluster.cluster_endpoint
    cluster_ca_certificate = base64decode(module.aws.cluster.cluster_certificate_authority_data)
    token                  = data.aws_eks_cluster_auth.cluster.token
  }
}