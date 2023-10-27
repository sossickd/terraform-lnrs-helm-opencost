variable "cluster_name" {
  description = "The name of the EKS cluster that has been created."
  type        = string
  nullable    = false
}

variable "aws" {
  description = "AWS configuration."
  type = object({
    partition        = optional(string, "aws")
    account_id       = optional(string, "")
    spot_data_prefix = optional(string, "spot-datafeed")
  })
  nullable = false
  default  = {}
}

variable "tags" {
  description = "Tags to apply to all resources."
  type        = map(string)
  nullable    = false
  default     = {}
}
