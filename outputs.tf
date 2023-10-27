output "awscur_initializer_lambda_function_arn" {
  description = "ARN of the AWS CUR Initializer Lambda Function."
  value       = module.aws_integration[0].awscur_initializer_lambda_function_arn
}