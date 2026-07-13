data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

module "networking" {
  source = "./modules/networking"

  vpc_cidr    = var.vpc_cidr
  environment = var.environment
}

module "security" {
  source = "./modules/security"

  vpc_id           = module.networking.vpc_id
  environment      = var.environment
  application_port = var.application_port
  database_port    = var.database_port
}

module "nacls" {
  source = "./modules/nacls"

  vpc_id                   = module.networking.vpc_id
  vpc_cidr                 = var.vpc_cidr
  environment              = var.environment
  public_subnet_ids        = module.networking.public_subnet_id_map
  private_app_subnet_ids   = module.networking.private_app_subnet_id_map
  private_db_subnet_ids    = module.networking.private_db_subnet_id_map
  public_subnet_cidrs      = module.networking.public_subnet_cidrs
  private_app_subnet_cidrs = module.networking.private_app_subnet_cidrs
  private_db_subnet_cidrs  = module.networking.private_db_subnet_cidrs
  application_port         = var.application_port
  database_port            = var.database_port
}

module "flow_logs" {
  source = "./modules/flow-logs"

  vpc_id             = module.networking.vpc_id
  environment        = var.environment
  aws_region         = data.aws_region.current.region
  aws_account_id     = data.aws_caller_identity.current.account_id
  log_retention_days = var.flow_log_retention_days
}

module "cloudtrail" {
  source = "./modules/cloudtrail"

  environment               = var.environment
  aws_account_id            = data.aws_caller_identity.current.account_id
  aws_region                = data.aws_region.current.region
  cloudwatch_retention_days = var.cloudtrail_cloudwatch_retention_days
  s3_log_retention_days     = var.cloudtrail_s3_retention_days
}