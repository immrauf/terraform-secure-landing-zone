output "secret_name" {
  description = "Name of the application secret"
  value       = aws_secretsmanager_secret.application.name
}

output "secret_arn" {
  description = "ARN of the application secret"
  value       = aws_secretsmanager_secret.application.arn
}

output "secret_read_policy_arn" {
  description = "ARN of the least-privilege secret-read policy"
  value       = aws_iam_policy.secret_read_access.arn
}