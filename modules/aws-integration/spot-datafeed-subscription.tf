resource "aws_spot_datafeed_subscription" "spotfeed" {
  bucket = aws_s3_bucket.spotfeed.id
  prefix = var.aws.spot_data_prefix
}