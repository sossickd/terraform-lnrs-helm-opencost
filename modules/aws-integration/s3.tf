#tfsec:ignore:aws-s3-enable-versioning
#tfsec:ignore:aws-s3-enable-bucket-logging
resource "aws_s3_bucket" "cur-athena" {
  bucket = "${var.cluster_name}-cur-athena"

  force_destroy = true

  tags = merge(var.tags, {
    Name = "${var.cluster_name}-cur-athena"
  })
}

#tfsec:ignore:aws-s3-encryption-customer-key
resource "aws_s3_bucket_server_side_encryption_configuration" "cur-athena" {
  bucket = aws_s3_bucket.cur-athena.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "cur-athena" {
  bucket = aws_s3_bucket.cur-athena.id

  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
}

resource "aws_s3_bucket_ownership_controls" "cur-athena" {
  bucket = aws_s3_bucket.cur-athena.id
  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_policy" "cur-athena" {
  bucket = aws_s3_bucket.cur-athena.id
  policy = jsonencode({
    "Version" : "2008-10-17",
    "Id" : "Policy1335892530063",
    "Statement" : [
      {
        "Sid" : "Stmt1335892150622",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "billingreports.amazonaws.com"
        },
        "Action" : [
          "s3:GetBucketAcl",
          "s3:GetBucketPolicy"
        ],
        "Resource" : "arn:${var.aws.partition}:s3:::${aws_s3_bucket.cur-athena.id}",
        "Condition" : {
          "StringEquals" : {
            "aws:SourceArn" : "arn:aws:cur:us-east-1:${var.aws.account_id}:definition/*",
            "aws:SourceAccount" : "${var.aws.account_id}"
          }
        }
      },
      {
        "Sid" : "Stmt1335892526596",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "billingreports.amazonaws.com"
        },
        "Action" : [
          "s3:PutObject"
        ],
        "Resource" : "arn:${var.aws.partition}:s3:::${aws_s3_bucket.cur-athena.id}/*",
        "Condition" : {
          "StringEquals" : {
            "aws:SourceArn" : "arn:${var.aws.partition}:cur:us-east-1:${var.aws.account_id}:definition/*",
            "aws:SourceAccount" : "${var.aws.account_id}"
          }
        }
      }
    ]
  })
}

resource "aws_s3_bucket_notification" "aws_put_s3_cur_notification" {
  bucket = aws_s3_bucket.cur-athena.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.awscur_initializer.arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = "opencost-prefix/${var.cluster_name}-opencost-report/${var.cluster_name}-cur-report/${var.cluster_name}-cur-report"
  }
}

#tfsec:ignore:aws-s3-enable-bucket-logging
#tfsec:ignore:aws-s3-enable-versioning
resource "aws_s3_bucket" "spotfeed" {
  bucket = "${var.cluster_name}-opencost-spotfeed"

  force_destroy = true

  tags = merge(var.tags, {
    Name = "${var.cluster_name}-opencost-spotfeed"
  })
}

#tfsec:ignore:aws-s3-encryption-customer-key
resource "aws_s3_bucket_server_side_encryption_configuration" "spotfeed" {
  bucket = aws_s3_bucket.spotfeed.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "spotfeed" {
  bucket = aws_s3_bucket.spotfeed.id

  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
}

resource "aws_s3_bucket_ownership_controls" "spotfeed" {
  bucket = aws_s3_bucket.spotfeed.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}
