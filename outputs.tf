output "vpc_id" {
  description = "ID of the secure landing zone VPC"
  value       = module.networking.vpc_id
}

output "vpc_cidr" {
  description = "CIDR block assigned to the secure landing zone VPC"
  value       = module.networking.vpc_cidr
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = module.networking.public_subnet_ids
}

output "private_app_subnet_ids" {
  description = "IDs of the private application subnets"
  value       = module.networking.private_app_subnet_ids
}

output "availability_zones" {
  description = "Availability Zones used by the landing zone"
  value       = module.networking.availability_zones
}

output "internet_gateway_id" {
  description = "ID of the landing zone Internet Gateway"
  value       = module.networking.internet_gateway_id
}

output "public_route_table_id" {
  description = "ID of the public route table"
  value       = module.networking.public_route_table_id
}

output "nat_gateway_id" {
  description = "ID of the landing zone NAT Gateway"
  value       = module.networking.nat_gateway_id
}

output "nat_gateway_public_ip" {
  description = "Public IP address assigned to the NAT Gateway"
  value       = module.networking.nat_gateway_public_ip
}

output "private_app_route_table_id" {
  description = "ID of the private application route table"
  value       = module.networking.private_app_route_table_id
}

output "private_db_subnet_ids" {
  description = "IDs of the isolated private database subnets"
  value       = module.networking.private_db_subnet_ids
}

output "private_db_route_table_id" {
  description = "ID of the isolated private database route table"
  value       = module.networking.private_db_route_table_id
}

output "db_subnet_group_name" {
  description = "Name of the RDS database subnet group"
  value       = module.networking.db_subnet_group_name
}

output "db_subnet_group_arn" {
  description = "ARN of the RDS database subnet group"
  value       = module.networking.db_subnet_group_arn
}

output "load_balancer_security_group_id" {
  description = "ID of the public load-balancer security group"
  value       = module.security.load_balancer_security_group_id
}

output "application_security_group_id" {
  description = "ID of the private application security group"
  value       = module.security.application_security_group_id
}

output "database_security_group_id" {
  description = "ID of the private database security group"
  value       = module.security.database_security_group_id
}

output "public_network_acl_id" {
  description = "ID of the public Network ACL"
  value       = module.nacls.public_network_acl_id
}

output "private_app_network_acl_id" {
  description = "ID of the private application Network ACL"
  value       = module.nacls.private_app_network_acl_id
}

output "private_db_network_acl_id" {
  description = "ID of the private database Network ACL"
  value       = module.nacls.private_db_network_acl_id
}

output "vpc_flow_log_id" {
  description = "ID of the VPC Flow Log"
  value       = module.flow_logs.flow_log_id
}

output "vpc_flow_log_group_name" {
  description = "CloudWatch log-group name for VPC Flow Logs"
  value       = module.flow_logs.cloudwatch_log_group_name
}

output "vpc_flow_log_group_arn" {
  description = "CloudWatch log-group ARN for VPC Flow Logs"
  value       = module.flow_logs.cloudwatch_log_group_arn
}

output "vpc_flow_logs_role_arn" {
  description = "IAM role ARN used to publish VPC Flow Logs"
  value       = module.flow_logs.flow_logs_role_arn
}

output "cloudtrail_arn" {
  description = "ARN of the multi-Region CloudTrail trail"
  value       = module.cloudtrail.trail_arn
}

output "cloudtrail_s3_bucket_name" {
  description = "Name of the S3 bucket containing CloudTrail logs"
  value       = module.cloudtrail.s3_bucket_name
}

output "cloudtrail_cloudwatch_log_group_name" {
  description = "CloudWatch log group receiving CloudTrail events"
  value       = module.cloudtrail.cloudwatch_log_group_name
}

output "cloudtrail_cloudwatch_role_arn" {
  description = "IAM role used by CloudTrail for CloudWatch delivery"
  value       = module.cloudtrail.cloudwatch_role_arn
}

output "security_logs_kms_key_id" {
  description = "ID of the customer-managed KMS key for security logs"
  value       = module.kms.key_id
}

output "security_logs_kms_key_arn" {
  description = "ARN of the customer-managed KMS key for security logs"
  value       = module.kms.key_arn
}

output "security_logs_kms_alias" {
  description = "Alias of the customer-managed KMS key for security logs"
  value       = module.kms.alias_name
}

output "guardduty_detector_id" {
  description = "ID of the GuardDuty detector"
  value       = module.guardduty.detector_id
}

output "guardduty_detector_arn" {
  description = "ARN of the GuardDuty detector"
  value       = module.guardduty.detector_arn
}

output "guardduty_s3_protection_status" {
  description = "Status of GuardDuty S3 Protection"
  value       = module.guardduty.s3_protection_status
}

output "guardduty_rds_protection_status" {
  description = "Status of GuardDuty RDS Protection"
  value       = module.guardduty.rds_protection_status
}

output "security_hub_arn" {
  description = "ARN of the Security Hub CSPM subscription"
  value       = module.security_hub.security_hub_arn
}

output "security_hub_fsbp_subscription_arn" {
  description = "Subscription ARN for AWS Foundational Security Best Practices"
  value       = module.security_hub.fsbp_subscription_arn
}

output "security_hub_cis_subscription_arn" {
  description = "Subscription ARN for the CIS AWS Foundations Benchmark"
  value       = module.security_hub.cis_subscription_arn
}

output "config_configuration_recorder_name" {
  description = "Name of the AWS Config configuration recorder"
  value       = module.config.configuration_recorder_name
}

output "config_delivery_channel_name" {
  description = "Name of the AWS Config delivery channel"
  value       = module.config.delivery_channel_name
}

output "config_s3_bucket_name" {
  description = "Name of the S3 bucket storing AWS Config data"
  value       = module.config.config_bucket_name
}

output "config_service_role_arn" {
  description = "ARN of the AWS Config service-linked role"
  value       = module.config.config_role_arn
}

output "config_retention_period_days" {
  description = "AWS Config historical information retention period"
  value       = module.config.retention_period_days
}

output "config_rule_names" {
  description = "Names of the AWS Config managed compliance rules"
  value       = module.config_rules.rule_names
}

output "config_rule_arns" {
  description = "ARNs of the AWS Config managed compliance rules"
  value       = module.config_rules.rule_arns
}

output "config_rule_count" {
  description = "Number of AWS Config managed compliance rules"
  value       = module.config_rules.rule_count
}

output "default_security_group_id" {
  description = "ID of the landing-zone default security group"
  value       = module.networking.default_security_group_id
}

output "security_alert_topic_arn" {
  description = "SNS topic used for security notifications"
  value       = module.security_alerting.security_alert_topic_arn
}

output "security_metric_filter_names" {
  description = "CloudWatch security metric filters"
  value       = module.cloudwatch_monitoring.metric_filter_names
}

output "security_alarm_names" {
  description = "CloudWatch security alarms"
  value       = module.cloudwatch_monitoring.alarm_names
}

output "cloudtrail_log_group_name" {
  description = "CloudWatch log group receiving CloudTrail events"
  value       = module.cloudtrail.cloudwatch_log_group_name
}