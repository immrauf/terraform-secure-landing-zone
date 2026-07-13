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