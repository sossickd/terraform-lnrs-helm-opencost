module "iam_role" {
  count = var.cloud == "aws" ? 1 : 0

  source = "./modules/iam-role"

  partition  = var.aws.partition
  account_id = var.aws.account_id

  oidc_issuer_url = var.cluster_oidc_issuer_url

  iam_name     = "${var.cluster_name}-opencost"
  iam_subjects = ["system:serviceaccount:${var.namespace}:${local.service_account_name}"]

  iam_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : [
          "athena:*"
        ],
        "Resource" : [
          "*"
        ],
        "Effect" : "Allow",
        "Sid" : "AthenaAccess"
      },
      {
        "Action" : [
          "glue:GetDatabase*",
          "glue:GetTable*",
          "glue:GetPartition*",
          "glue:GetUserDefinedFunction",
          "glue:BatchGetPartition"
        ],
        "Resource" : [
          "arn:${var.aws.partition}:glue:*:*:catalog",
          "arn:${var.aws.partition}:glue:*:*:database/${var.cluster_name}-awscur*",
          "arn:${var.aws.partition}:glue:*:*:table/*/*"
        ],
        "Effect" : "Allow",
        "Sid" : "ReadAccessToAthenaCurDataViaGlue"
      },
      {
        "Action" : [
          "s3:GetBucketLocation",
          "s3:GetObject",
          "s3:ListBucket",
          "s3:ListBucketMultipartUploads",
          "s3:ListMultipartUploadParts",
          "s3:AbortMultipartUpload",
          "s3:CreateBucket",
          "s3:PutObject"
        ],
        "Resource" : [
          "arn:${var.aws.partition}:s3:::aws-athena-query-results-*"
        ],
        "Effect" : "Allow",
        "Sid" : "AthenaQueryResultsOutput"
      },
      {
        "Action" : [
          "s3:Get*",
          "s3:List*"
        ],
        "Resource" : [
          "arn:${var.aws.partition}:s3:::*"
        ],
        "Effect" : "Allow",
        "Sid" : "S3ReadAccessToAwsBillingData"
      },
      {
        "Action" : [
          "organizations:ListAccounts",
          "organizations:ListTagsForResource"
        ],
        "Resource" : [
          "*"
        ],
        "Effect" : "Allow",
        "Sid" : "ReadAccessToAccountTags"
      },
      {
        "Sid" : "SpotFeedAccess1",
        "Effect" : "Allow",
        "Action" : [
          "s3:ListStorageLensConfigurations",
          "s3:ListAccessPointsForObjectLambda",
          "s3:GetAccessPoint",
          "s3:PutAccountPublicAccessBlock",
          "s3:GetAccountPublicAccessBlock",
          "s3:ListAllMyBuckets",
          "s3:ListAccessPoints",
          "s3:PutAccessPointPublicAccessBlock",
          "s3:ListJobs",
          "s3:PutStorageLensConfiguration",
          "s3:ListMultiRegionAccessPoints",
          "s3:CreateJob"
        ],
        "Resource" : "*"
      },
      {
        "Sid" : "SpotFeedAccess2",
        "Effect" : "Allow",
        "Action" : "s3:*",
        "Resource" : "arn:${var.aws.partition}:s3:::${module.aws_integration[0].spotfeed-bucket}"
      }
    ]
  })

  tags = var.tags
}
