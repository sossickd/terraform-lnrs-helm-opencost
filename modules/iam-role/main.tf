resource "aws_iam_role" "default" {
  name        = var.iam_name
  description = var.iam_description

  assume_role_policy = jsonencode({
    "Version" = "2012-10-17"
    "Statement" = [
      {
        "Sid"    = "IRSAAssume"
        "Action" = "sts:AssumeRoleWithWebIdentity"
        "Effect" = "Allow"
        "Principal" = {
          "Federated" = local.oidc_arn
        }
        "Condition" = {
          "StringEquals" = {
            "${local.oidc_host}:aud" = "sts.amazonaws.com"
          }
          "StringLike" = {
            "${local.oidc_host}:sub" = [for x in var.iam_subjects : startswith(x, local.subject_prefix) ? x : "${local.subject_prefix}${x}"]
          }
        }
      }
    ]
  })

  tags = merge(var.tags, { Name = var.iam_name })
}

#tfsec:ignore:aws-iam-no-policy-wildcards
resource "aws_iam_role_policy" "default" {
  name = local.policy_name
  role = aws_iam_role.default.id

  policy = coalesce(var.iam_policy, jsonencode(local.default_policy))
}

resource "aws_iam_role_policy_attachment" "default" {
  for_each = var.iam_policy_attachments

  role       = aws_iam_role.default.name
  policy_arn = each.value
}
