resource "aws_network_acl" "public" {
  vpc_id = var.vpc_id

  tags = {
    Name = "secure-landing-zone-${var.environment}-public-nacl"
    Tier = "public"
  }
}

resource "aws_network_acl" "private_app" {
  vpc_id = var.vpc_id

  tags = {
    Name = "secure-landing-zone-${var.environment}-private-app-nacl"
    Tier = "private-app"
  }
}

resource "aws_network_acl" "private_db" {
  vpc_id = var.vpc_id

  tags = {
    Name = "secure-landing-zone-${var.environment}-private-db-nacl"
    Tier = "private-db"
  }
}

resource "aws_network_acl_association" "public" {
  for_each = var.public_subnet_ids

  network_acl_id = aws_network_acl.public.id
  subnet_id      = each.value
}

resource "aws_network_acl_association" "private_app" {
  for_each = var.private_app_subnet_ids

  network_acl_id = aws_network_acl.private_app.id
  subnet_id      = each.value
}

resource "aws_network_acl_association" "private_db" {
  for_each = var.private_db_subnet_ids

  network_acl_id = aws_network_acl.private_db.id
  subnet_id      = each.value
}

resource "aws_network_acl_rule" "public_inbound_https" {
  network_acl_id = aws_network_acl.public.id
  rule_number    = 100
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 443
  to_port        = 443
}

resource "aws_network_acl_rule" "public_inbound_app_return" {
  network_acl_id = aws_network_acl.public.id
  rule_number    = 110
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = var.vpc_cidr
  from_port      = 1024
  to_port        = 65535
}

resource "aws_network_acl_rule" "public_inbound_internet_return" {
  network_acl_id = aws_network_acl.public.id
  rule_number    = 120
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 1024
  to_port        = 65535
}

resource "aws_network_acl_rule" "public_outbound_application" {
  network_acl_id = aws_network_acl.public.id
  rule_number    = 100
  egress         = true
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = var.vpc_cidr
  from_port      = var.application_port
  to_port        = var.application_port
}

resource "aws_network_acl_rule" "public_outbound_https" {
  network_acl_id = aws_network_acl.public.id
  rule_number    = 110
  egress         = true
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 443
  to_port        = 443
}

resource "aws_network_acl_rule" "public_outbound_client_return" {
  network_acl_id = aws_network_acl.public.id
  rule_number    = 120
  egress         = true
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 1024
  to_port        = 65535
}

resource "aws_network_acl_rule" "private_app_inbound_application" {
  for_each = {
    for index, cidr in var.public_subnet_cidrs :
    tostring(index) => cidr
  }

  network_acl_id = aws_network_acl.private_app.id
  rule_number    = 100 + tonumber(each.key)
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = each.value
  from_port      = var.application_port
  to_port        = var.application_port
}

resource "aws_network_acl_rule" "private_app_inbound_ephemeral" {
  network_acl_id = aws_network_acl.private_app.id
  rule_number    = 120
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 1024
  to_port        = 65535
}

resource "aws_network_acl_rule" "private_app_outbound_https" {
  network_acl_id = aws_network_acl.private_app.id
  rule_number    = 100
  egress         = true
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 443
  to_port        = 443
}

resource "aws_network_acl_rule" "private_app_outbound_database" {
  for_each = {
    for index, cidr in var.private_db_subnet_cidrs :
    tostring(index) => cidr
  }

  network_acl_id = aws_network_acl.private_app.id
  rule_number    = 110 + tonumber(each.key)
  egress         = true
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = each.value
  from_port      = var.database_port
  to_port        = var.database_port
}

resource "aws_network_acl_rule" "private_app_outbound_public_return" {
  for_each = {
    for index, cidr in var.public_subnet_cidrs :
    tostring(index) => cidr
  }

  network_acl_id = aws_network_acl.private_app.id
  rule_number    = 120 + tonumber(each.key)
  egress         = true
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = each.value
  from_port      = 1024
  to_port        = 65535
}

resource "aws_network_acl_rule" "private_db_inbound_database" {
  for_each = {
    for index, cidr in var.private_app_subnet_cidrs :
    tostring(index) => cidr
  }

  network_acl_id = aws_network_acl.private_db.id
  rule_number    = 100 + tonumber(each.key)
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = each.value
  from_port      = var.database_port
  to_port        = var.database_port
}

resource "aws_network_acl_rule" "private_db_outbound_application_return" {
  for_each = {
    for index, cidr in var.private_app_subnet_cidrs :
    tostring(index) => cidr
  }

  network_acl_id = aws_network_acl.private_db.id
  rule_number    = 100 + tonumber(each.key)
  egress         = true
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = each.value
  from_port      = 1024
  to_port        = 65535
}