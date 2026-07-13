variable "vpc_id" {
  description = "ID of the VPC where the network ACLs will be created"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block assigned to the landing-zone VPC"
  type        = string
}

variable "environment" {
  description = "Deployment environment name"
  type        = string
}

variable "public_subnet_ids" {
  description = "Map of public subnet IDs"
  type        = map(string)
}

variable "private_app_subnet_ids" {
  description = "Map of private application subnet IDs"
  type        = map(string)
}

variable "private_db_subnet_ids" {
  description = "Map of private database subnet IDs"
  type        = map(string)
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks assigned to the public subnets"
  type        = list(string)
}

variable "private_app_subnet_cidrs" {
  description = "CIDR blocks assigned to private application subnets"
  type        = list(string)
}

variable "private_db_subnet_cidrs" {
  description = "CIDR blocks assigned to private database subnets"
  type        = list(string)
}

variable "application_port" {
  description = "Application service port"
  type        = number
  default     = 8080
}

variable "database_port" {
  description = "Database service port"
  type        = number
  default     = 5432
}