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

module "kms" {
  source = "./modules/kms"

  environment     = var.environment
  aws_account_id  = data.aws_caller_identity.current.account_id
  aws_region      = data.aws_region.current.region
  cloudtrail_name = "secure-landing-zone-${var.environment}-trail"
}

module "flow_logs" {
  source = "./modules/flow-logs"

  vpc_id             = module.networking.vpc_id
  environment        = var.environment
  aws_region         = data.aws_region.current.region
  aws_account_id     = data.aws_caller_identity.current.account_id
  kms_key_arn        = module.kms.key_arn
  log_retention_days = var.flow_log_retention_days
}

module "cloudtrail" {
  source = "./modules/cloudtrail"

  environment               = var.environment
  aws_account_id            = data.aws_caller_identity.current.account_id
  aws_region                = data.aws_region.current.region
  kms_key_arn               = module.kms.key_arn
  cloudwatch_retention_days = var.cloudtrail_cloudwatch_retention_days
  s3_log_retention_days     = var.cloudtrail_s3_retention_days
}

module "guardduty" {
  source = "./modules/guardduty"

  environment                  = var.environment
  finding_publishing_frequency = var.guardduty_finding_publishing_frequency
  enable_s3_protection         = var.enable_guardduty_s3_protection
  enable_rds_protection        = var.enable_guardduty_rds_protection
}

module "security_hub" {
  source = "./modules/security-hub"

  environment          = var.environment
  aws_region           = data.aws_region.current.region
  enable_fsbp_standard = var.enable_security_hub_fsbp
  enable_cis_standard  = var.enable_security_hub_cis

  depends_on = [
    module.guardduty
  ]
}

module "config" {
  source = "./modules/config"

  environment                 = var.environment
  aws_account_id              = data.aws_caller_identity.current.account_id
  snapshot_delivery_frequency = var.config_snapshot_delivery_frequency
  retention_period_days       = var.config_retention_period_days

  depends_on = [
    module.security_hub
  ]
}

module "config_rules" {
  source = "./modules/config-rules"

  environment      = var.environment
  rule_name_prefix = "secure-landing-zone"

  depends_on = [
    module.config
  ]
}

module "security_alerting" {
  source = "./modules/security-alerting"

  environment = var.environment
  alert_email = var.security_alert_email
}

module "cloudwatch_monitoring" {
  source = "./modules/cloudwatch-monitoring"

  environment               = var.environment
  cloudtrail_log_group_name = module.cloudtrail.cloudwatch_log_group_name
  security_alert_topic_arn  = module.security_alerting.security_alert_topic_arn
}

module "iam_security" {
  source = "./modules/iam-security"

  environment           = var.environment
  trusted_principal_arn = var.trusted_principal_arn
}

module "secrets_manager" {
  source = "./modules/secrets-manager"

  environment = var.environment
  kms_key_arn = module.kms.key_arn
}