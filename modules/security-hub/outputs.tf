output "security_hub_arn" {
  description = "ARN of the Security Hub CSPM account subscription"
  value       = aws_securityhub_account.main.arn
}

output "fsbp_subscription_arn" {
  description = "Subscription ARN for AWS Foundational Security Best Practices"
  value = var.enable_fsbp_standard ? (
    aws_securityhub_standards_subscription.fsbp[0].id
  ) : null
}

output "cis_subscription_arn" {
  description = "Subscription ARN for the CIS AWS Foundations Benchmark"
  value = var.enable_cis_standard ? (
    aws_securityhub_standards_subscription.cis[0].id
  ) : null
}