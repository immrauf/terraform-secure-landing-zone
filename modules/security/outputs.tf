output "load_balancer_security_group_id" {
  description = "ID of the public load-balancer security group"
  value       = aws_security_group.load_balancer.id
}

output "application_security_group_id" {
  description = "ID of the private application security group"
  value       = aws_security_group.application.id
}

output "database_security_group_id" {
  description = "ID of the private database security group"
  value       = aws_security_group.database.id
}