locals {
  default_policy = {
    "Version" = "2012-10-17"
    "Statement" = [
      {
        "Sid"      = "NoAction"
        "Effect"   = "Allow"
        "Action"   = "none:null"
        "Resource" = "*"
      }
    ]
  }

  subject_prefix = "system:serviceaccount:"

  oidc_host = replace(var.oidc_issuer_url, "https://", "")
  oidc_arn  = "arn:${var.aws.partition}:iam::${var.aws.account_id}:oidc-provider/${local.oidc_host}"

  policy_name = "${var.iam_name}-policy"
}
