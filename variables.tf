variable "release_name" {
  description = "Name of the release."
  type        = string
  nullable    = false
}

variable "namespace" {
  description = "Namespace to create and install into."
  type        = string
  nullable    = false
}

variable "cluster_name" {
  description = "The name of the EKS cluster that has been created."
  type        = string
  nullable    = false
}

variable "cloud" {
  description = "Cloud that this will be run on. AWS and Azure are currently supported."
  type        = string
  nullable    = false

  validation {
    condition     = contains(["aws", "azure"], var.cloud)
    error_message = "This module supports AWS (aws) and Azure (azure)."
  }
}

variable "partition" {
  description = "AWS partition."
  type        = string
  nullable    = false
  default     = "aws"
}

variable "cluster_oidc_issuer_url" {
  description = "The OIDC issuer url for the cluster."
  type        = string
  nullable    = false
}

variable "enable_ui" {
  description = "Enable UI."
  type        = bool
  nullable    = false
  default     = true
}

variable "ingress_annotations" {
  description = "The annotations for ingress resources."
  type        = map(string)
  nullable    = true
  default     = {}
}

variable "ingress_hostname" {
  description = "Ingress hostname."
  type        = string
  nullable    = true
  default     = ""
}

variable "thanos_enabled" {
  description = "Thanos enabled."
  type        = bool
  nullable    = false
  default     = false
}

#variable "region" {
#  description = "The region."
#  type        = string
#  nullable    = true
#}

variable "tags" {
  description = "Tags to apply to all resources."
  type        = map(string)
  nullable    = false
  default     = {}
}
