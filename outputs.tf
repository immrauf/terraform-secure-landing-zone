output "vpc_id" {
  description = "ID of the secure landing zone VPC"
  value       = module.networking.vpc_id
}

output "vpc_cidr" {
  description = "CIDR block assigned to the secure landing zone VPC"
  value       = module.networking.vpc_cidr
}