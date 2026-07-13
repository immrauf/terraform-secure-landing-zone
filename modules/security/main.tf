resource "aws_security_group" "load_balancer" {
  name        = "secure-landing-zone-${var.environment}-alb-sg"
  description = "Controls traffic to the public application load balancer"
  vpc_id      = var.vpc_id

  tags = {
    Name = "secure-landing-zone-${var.environment}-alb-sg"
    Tier = "public"
  }
}

resource "aws_security_group" "application" {
  name        = "secure-landing-zone-${var.environment}-app-sg"
  description = "Controls traffic to private application workloads"
  vpc_id      = var.vpc_id

  tags = {
    Name = "secure-landing-zone-${var.environment}-app-sg"
    Tier = "private-app"
  }
}

resource "aws_security_group" "database" {
  name        = "secure-landing-zone-${var.environment}-db-sg"
  description = "Controls traffic to private database workloads"
  vpc_id      = var.vpc_id

  tags = {
    Name = "secure-landing-zone-${var.environment}-db-sg"
    Tier = "private-db"
  }
}

resource "aws_vpc_security_group_ingress_rule" "load_balancer_https" {
  security_group_id = aws_security_group.load_balancer.id

  description = "Allow public HTTPS traffic"
  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 443
  to_port     = 443
  ip_protocol = "tcp"

  tags = {
    Name = "allow-public-https"
  }
}

#Outbound 
resource "aws_vpc_security_group_egress_rule" "load_balancer_to_application" {
  security_group_id = aws_security_group.load_balancer.id

  description                  = "Allow load balancer traffic to the application tier"
  referenced_security_group_id = aws_security_group.application.id
  from_port                    = var.application_port
  to_port                      = var.application_port
  ip_protocol                  = "tcp"

  tags = {
    Name = "allow-alb-to-application"
  }
}

#Inbound
resource "aws_vpc_security_group_ingress_rule" "application_from_load_balancer" {
  security_group_id = aws_security_group.application.id

  description                  = "Allow application traffic only from the load balancer"
  referenced_security_group_id = aws_security_group.load_balancer.id
  from_port                    = var.application_port
  to_port                      = var.application_port
  ip_protocol                  = "tcp"

  tags = {
    Name = "allow-application-from-alb"
  }
}

resource "aws_vpc_security_group_egress_rule" "application_https_outbound" {
  security_group_id = aws_security_group.application.id

  description = "Allow HTTPS outbound for updates and approved external services"
  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 443
  to_port     = 443
  ip_protocol = "tcp"

  tags = {
    Name = "allow-application-https-outbound"
  }
}

resource "aws_vpc_security_group_egress_rule" "application_to_database" {
  security_group_id = aws_security_group.application.id

  description                  = "Allow application traffic to the database tier"
  referenced_security_group_id = aws_security_group.database.id
  from_port                    = var.database_port
  to_port                      = var.database_port
  ip_protocol                  = "tcp"

  tags = {
    Name = "allow-application-to-database"
  }
}

resource "aws_vpc_security_group_ingress_rule" "database_from_application" {
  security_group_id = aws_security_group.database.id

  description                  = "Allow database traffic only from the application tier"
  referenced_security_group_id = aws_security_group.application.id
  from_port                    = var.database_port
  to_port                      = var.database_port
  ip_protocol                  = "tcp"

  tags = {
    Name = "allow-database-from-application"
  }
}