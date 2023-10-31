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

variable "azure" {
  description = "Azure configuration."
  type = object({
    location            = optional(string, null)
    subscription_id     = optional(string, null)
    resource_group_name = optional(string, null)
  })
  nullable = false
  default  = {}
}

variable "cluster_oidc_issuer_url" {
  description = "The OIDC issuer url for the cluster."
  type        = string
  nullable    = false
  default     = ""
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

variable "labels" {
  description = "Labels to be applied to all Kubernetes resources."
  type        = map(string)
  default     = { "lnrs.io/k8s-platform" = "true" }
}

variable "tags" {
  description = "Tags to apply to all resources."
  type        = map(string)
  nullable    = false
  default     = {}
}
