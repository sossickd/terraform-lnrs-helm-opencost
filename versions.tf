terraform {
  required_version = ">= 1.3.3, != 1.3.4"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.34.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.9.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.14.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.23.0"
    }
    #azurerm = {
    #  source  = "hashicorp/azurerm"
    #  version = ">= 3.63.0"
    #}
    time = {
      source  = "hashicorp/time"
      version = ">= 0.9"
    }
  }
}
