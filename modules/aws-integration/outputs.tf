output "spotfeed-bucket" {
  description = "The name/id spotfeed s3 bucket name."
  value       = aws_s3_bucket.spotfeed.id
}

output "spotfeed-bucket-region" {
  description = "The name/id spotfeed s3 bucket name."
  value       = aws_s3_bucket.spotfeed.region
}