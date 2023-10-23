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

resource "aws_s3_bucket_policy" "spotfeed" {
  bucket = aws_s3_bucket.spotfeed.id
  policy = jsonencode({
    "Version" = "2012-10-17"
    "Statement" = [
      {
        "Sid"       = "deny-incorrect-encryption-header"
        "Effect"    = "Deny"
        "Principal" = "*"
        "Action"    = "s3:PutObject"
        "Resource"  = "${aws_s3_bucket.spotfeed.arn}/*"
        "Condition" = {
          "StringNotEquals" = {
            "s3:X-Amz-Server-Side-Encryption" = "AES256"
          }
        }
      },
      {
        "Sid"       = "deny-unencrypted-oject-uploads"
        "Effect"    = "Deny"
        "Principal" = "*"
        "Action"    = "s3:PutObject"
        "Resource"  = "${aws_s3_bucket.spotfeed.arn}/*"
        "Condition" = {
          "Null" = {
            "s3:X-Amz-Server-Side-Encryption" = "true"
          }
        }
      },
      {
        "Sid"       = "only-allow-https-requests"
        "Effect"    = "Deny"
        "Principal" = "*"
        "Action"    = "*"
        "Resource"  = "${aws_s3_bucket.spotfeed.arn}/*"
        "Condition" = {
          "Bool" = {
            "aws:SecureTransport" = "false"
          }
        }
      },
    ]
  })
}

resource "aws_spot_datafeed_subscription" "spotfeed" {
  bucket = aws_s3_bucket.spotfeed.id
  prefix = var.aws_spot_data_prefix
}