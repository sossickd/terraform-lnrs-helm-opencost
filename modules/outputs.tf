output "fluent_bit_aggregator_role_name" {
  description = "Name of the Fluent bit Aggregator IAM role created by the module."
  value       = module.aws_integration.aws_lambda_function.awscur_initializer.arn
}