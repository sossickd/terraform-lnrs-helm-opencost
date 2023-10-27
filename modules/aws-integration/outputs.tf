output "spotfeed-bucket" {
  description = "The name/id spotfeed s3 bucket name."
  value       = aws_s3_bucket.spotfeed.id
}

output "spotfeed-bucket-region" {
  description = "The name/id spotfeed s3 bucket name."
  value       = aws_s3_bucket.spotfeed.region
}

output "awscur_initializer_lambda_function_arn" {
  description = "ARN of the AWS CUR Initializer Lambda Function."
  value       = aws_lambda_function.awscur_initializer.arn
}