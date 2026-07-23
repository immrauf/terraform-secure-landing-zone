output "access_analyzer_name" {
  description = "Name of the IAM Access Analyzer"
  value       = aws_accessanalyzer_analyzer.account.analyzer_name
}

output "break_glass_role_arn" {
  description = "ARN of the emergency access role"
  value = try(
    aws_iam_role.break_glass[0].arn,
    null
  )
}