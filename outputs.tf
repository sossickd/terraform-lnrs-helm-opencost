output "awscur_initializer_lambda_function_arn" {
  description = "ARN of the AWS CUR Initializer Lambda Function."
  value       = module.aws_integration.aws_lambda_function.awscur_initializer.arn
}