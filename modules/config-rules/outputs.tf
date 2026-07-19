output "rule_names" {
  description = "Names of the AWS Config managed rules"
  value = {
    for key, rule in aws_config_config_rule.managed :
    key => rule.name
  }
}

output "rule_arns" {
  description = "ARNs of the AWS Config managed rules"
  value = {
    for key, rule in aws_config_config_rule.managed :
    key => rule.arn
  }
}

output "rule_ids" {
  description = "IDs of the AWS Config managed rules"
  value = {
    for key, rule in aws_config_config_rule.managed :
    key => rule.rule_id
  }
}

output "rule_count" {
  description = "Number of AWS Config managed rules deployed"
  value       = length(aws_config_config_rule.managed)
}