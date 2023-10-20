variable "partition" {
  description = "AWS partition."
  type        = string
  nullable    = false
}

variable "account_id" {
  description = "The account ID."
  type        = string
  nullable    = true
  default     = ""
}

variable "oidc_issuer_url" {
  description = "The OIDC issuer url."
  type        = string
  nullable    = false
}

variable "iam_name" {
  description = "The name of the IAM role."
  type        = string
  nullable    = false
}

variable "iam_description" {
  description = "The description of the IAM role."
  type        = string
  nullable    = true
  default     = null
}

variable "iam_subjects" {
  description = "Subjects who can assume the identity."
  type        = list(string)
  nullable    = false
}

variable "iam_policy" {
  description = "The policy to apply to the IAM role."
  type        = string
  nullable    = true
  default     = null
}

variable "iam_policy_attachments" {
  description = "Map of policy ARNs to attach."
  type        = map(string)
  nullable    = false
  default     = {}
}

variable "tags" {
  description = "Tags to apply to all resources."
  type        = map(string)
  nullable    = false
  default     = {}
}