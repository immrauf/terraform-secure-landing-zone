output "public_network_acl_id" {
  description = "ID of the public subnet Network ACL"
  value       = aws_network_acl.public.id
}

output "private_app_network_acl_id" {
  description = "ID of the private application Network ACL"
  value       = aws_network_acl.private_app.id
}

output "private_db_network_acl_id" {
  description = "ID of the private database Network ACL"
  value       = aws_network_acl.private_db.id
}