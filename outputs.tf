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