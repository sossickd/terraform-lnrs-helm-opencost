output "id" {
  description = "The name of the role."
  value       = aws_iam_role.default.id
}

output "name" {
  description = "The name of the role."
  value       = aws_iam_role.default.name
}

output "arn" {
  description = "The Amazon Resource Name (ARN) specifying the role."
  value       = aws_iam_role.default.arn
}
