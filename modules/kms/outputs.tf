output "key_id" {
  description = "ID of the security-logs KMS key"
  value       = aws_kms_key.security_logs.key_id
}

output "key_arn" {
  description = "ARN of the security-logs KMS key"
  value       = aws_kms_key.security_logs.arn
}

output "alias_name" {
  description = "Alias assigned to the security-logs KMS key"
  value       = aws_kms_alias.security_logs.name
}