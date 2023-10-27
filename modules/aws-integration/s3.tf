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

resource "aws_s3_bucket_notification" "aws_put_s3_cur_notification" {
  bucket = "${var.cluster_name}-us-east-1-cur-athena"

  lambda_function {
    lambda_function_arn = aws_lambda_function.awscur_initializer.arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = "opencost-prefix/${var.cluster_name}-opencost-report/${var.cluster_name}-cur-report/${var.cluster_name}-cur-report"
  }
}
