resource "aws_iam_role" "awscur_crawler_component_function" {
  name = "${var.cluster_name}-awscur-crawler-component-function"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = [
            "glue.amazonaws.com"
          ]
        }
        Action = [
          "sts:AssumeRole"
        ]
      }
    ]
  })
  path = "/"
  managed_policy_arns = [
    "arn:${var.aws.partition}:iam::aws:policy/service-role/AWSGlueServiceRole"
  ]
  force_detach_policies = true
  inline_policy {
    name = "AWSCURCrawlerComponentFunction${var.cluster_name}"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Effect = "Allow"
          Action = [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
          ]
          Resource = "arn:${var.aws.partition}:logs:*:*:*"
        },
        {
          Effect = "Allow"
          Action = [
            "glue:UpdateDatabase",
            "glue:UpdatePartition",
            "glue:CreateTable",
            "glue:UpdateTable",
            "glue:ImportCatalogToGlue"
          ]
          Resource = "*"
        },
        {
          Effect = "Allow"
          Action = [
            "s3:GetObject",
            "s3:PutObject"
          ]
          Resource = "arn:${var.aws.partition}:s3:::${var.cluster_name}-us-east-1-cur-athena/opencost-prefix/${var.cluster_name}-opencost-report/${var.cluster_name}-cur-report/${var.cluster_name}-cur-report*"
        }
      ]
    })
  }

  inline_policy {
    name = "AWSCURKMSDecryption${var.cluster_name}"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Effect = "Allow"
          Action = [
            "kms:Decrypt"
          ]
          Resource = "*"
        }
      ]
    })
  }
}

resource "aws_iam_role" "awscur_crawler_lambda_executor" {
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = [
            "lambda.amazonaws.com"
          ]
        }
        Action = [
          "sts:AssumeRole"
        ]
      }
    ]
  })
  path                  = "/"
  force_detach_policies = true
  inline_policy {
    name = "AWSCURCrawlerLambdaExecutor${var.cluster_name}"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Effect = "Allow"
          Action = [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
          ]
          Resource = "arn:${var.aws.partition}:logs:*:*:*"
        },
        {
          Effect = "Allow"
          Action = [
            "glue:StartCrawler"
          ]
          Resource = "*"
        }
      ]
    })
  }
}

resource "aws_iam_role" "awss3_cur_lambda_executor" {
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = [
            "lambda.amazonaws.com"
          ]
        }
        Action = [
          "sts:AssumeRole"
        ]
      }
    ]
  })
  path                  = "/"
  force_detach_policies = true
  inline_policy {
    name = "AWSS3CURLambdaExecutor${var.cluster_name}"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Effect = "Allow"
          Action = [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
          ]
          Resource = "arn:${var.aws.partition}:logs:*:*:*"
        },
        {
          Effect = "Allow"
          Action = [
            "s3:PutBucketNotification"
          ]
          Resource = "arn:${var.aws.partition}:s3:::${var.cluster_name}-us-east-1-cur-athena"
        }
      ]
    })
  }
}