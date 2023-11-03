terraform {
  required_version = ">= 1.3.3, != 1.3.4"

  required_providers {
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
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.63.0"
    }
    time = {
      source  = "hashicorp/time"
      version = ">= 0.9"
    }
    random = {
      source = "hashicorp/random"
    }
  }
}
