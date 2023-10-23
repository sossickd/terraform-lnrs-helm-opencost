#tfsec:ignore:aws-s3-enable-bucket-logging
#tfsec:ignore:aws-s3-enable-versioning
resource "aws_s3_bucket" "spotfeed" {
  count = var.cloud == "aws" ? 1 : 0

  bucket = "${var.cluster_name}-opencost-spotfeed"

  force_destroy = true

  tags = merge(var.tags, {
    Name = "${var.cluster_name}-opencost-spotfeed"
  })
}

#tfsec:ignore:aws-s3-encryption-customer-key
resource "aws_s3_bucket_server_side_encryption_configuration" "spotfeed" {
  count = var.cloud == "aws" ? 1 : 0

  bucket = aws_s3_bucket.spotfeed[0].id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "spotfeed" {
  count = var.cloud == "aws" ? 1 : 0

  bucket = aws_s3_bucket.spotfeed[0].id

  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
}

resource "aws_s3_bucket_ownership_controls" "spotfeed" {
  count = var.cloud == "aws" ? 1 : 0

  bucket = aws_s3_bucket.spotfeed[0].id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_spot_datafeed_subscription" "spotfeed" {
  count = var.cloud == "aws" ? 1 : 0

  bucket = aws_s3_bucket.spotfeed[0].id
  prefix = var.aws.spot_data_prefix
}