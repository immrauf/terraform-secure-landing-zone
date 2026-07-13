output "vpc_id" {
  description = "ID of the secure landing zone VPC"
  value       = aws_vpc.main.id
}

output "vpc_cidr" {
  description = "CIDR block assigned to the VPC"
  value       = aws_vpc.main.cidr_block
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = values(aws_subnet.public)[*].id
}

output "private_app_subnet_ids" {
  description = "IDs of the private application subnets"
  value       = values(aws_subnet.private_app)[*].id
}

output "availability_zones" {
  description = "Availability Zones used by the networking module"
  value = [
    data.aws_availability_zones.available.names[0],
    data.aws_availability_zones.available.names[1]
  ]
}

output "internet_gateway_id" {
  description = "ID of the VPC Internet Gateway"
  value       = aws_internet_gateway.main.id
}

output "public_route_table_id" {
  description = "ID of the public route table"
  value       = aws_route_table.public.id
}

output "nat_gateway_id" {
  description = "ID of the NAT Gateway used by private application subnets"
  value       = aws_nat_gateway.main.id
}

output "nat_gateway_public_ip" {
  description = "Public Elastic IP assigned to the NAT Gateway"
  value       = aws_eip.nat.public_ip
}

output "private_app_route_table_id" {
  description = "ID of the private application route table"
  value       = aws_route_table.private_app.id
}

output "private_db_subnet_ids" {
  description = "IDs of the isolated private database subnets"
  value       = values(aws_subnet.private_db)[*].id
}

output "private_db_route_table_id" {
  description = "ID of the isolated private database route table"
  value       = aws_route_table.private_db.id
}

output "db_subnet_group_name" {
  description = "Name of the RDS database subnet group"
  value       = aws_db_subnet_group.main.name
}

output "db_subnet_group_arn" {
  description = "ARN of the RDS database subnet group"
  value       = aws_db_subnet_group.main.arn
}