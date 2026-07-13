output "vpc_id" {
  description = "ID of the secure landing zone VPC"
  value       = aws_vpc.main.id
}

output "vpc_cidr" {
  description = "CIDR block assigned to the VPC"
  value       = aws_vpc.main.cidr_block
}