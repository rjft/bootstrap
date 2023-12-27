terraform {
  required_version = ">= 1.0"

  backend "s3" {
    bucket = "{{ .Bucket }}"
    key = "{{ .Cluster }}/terraform.tfstate"
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
  }
}

provider "aws" {
  region = "{{ .Region }}"
}
