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

variable "aws" {
  description = "AWS configuration."
  type = object({
    partition        = optional(string, "aws")
    account_id       = optional(string, null)
    spot_data_prefix = optional(string, "spot-datafeed")
  })
  nullable = false
  default  = {}
}

#variable "partition" {
#  description = "AWS partition."
#  type        = string
#  nullable    = true
#  default     = "aws"
#}

#variable "account_id" {
#  description = "AWS account id."
#  type        = string
#  nullable    = true
#}

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

#variable "aws_spot_data_prefix" {
#  description = "AWS spot data prefix."
#  type        = string
#  nullable    = true
#  default     = "spot-datafeed"
#}

variable "athena_bucket_name" {
  description = "Athena bucket name."
  type        = string
  nullable    = true
}

variable "athena_region" {
  description = "Athena region."
  type        = string
  nullable    = true
}

variable "athena_database" {
  description = "Athena database."
  type        = string
  nullable    = true
}

variable "athena_table" {
  description = "Athena table."
  type        = string
  nullable    = true
}

variable "tags" {
  description = "Tags to apply to all resources."
  type        = map(string)
  nullable    = false
  default     = {}
}
