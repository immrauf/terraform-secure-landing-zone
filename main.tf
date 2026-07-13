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