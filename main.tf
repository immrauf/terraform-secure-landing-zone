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