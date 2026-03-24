provider "aws" {
  region = var.aws_region
}

########################
# VPC (Networking Layer)
########################
module "vpc" {
  source = "../../modules/vpc"

  vpc_cidr             = "10.0.0.0/16"
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.11.0/24", "10.0.12.0/24"]
  availability_zones   = ["us-east-1a", "us-east-1b"]
}

########################
# ACM (TLS Certificate)
########################
module "acm" {
  source = "../../modules/acm"

  domain_name = var.domain_name
  zone_id     = var.zone_id
}

########################
# ALB (Public Entry Point)
########################
module "alb" {
  source = "../../modules/alb"

  name = var.project_name

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.public_subnet_ids

  certificate_arn = module.acm.certificate_arn

  domain_name = var.domain_name
  zone_id     = var.zone_id

  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}

########################
# ASG (Private Compute Layer)
########################
module "asg" {
  source = "../../modules/asg"

  name        = var.project_name
  environment = var.environment

  vpc_id = module.vpc.vpc_id

  # ⚠️ Confirm your exact output name here:
  subnet_ids = module.vpc.private_subnet_ids
  # If your module uses:
  # subnet_ids = module.vpc.private_app_subnet_ids

  ami_id = var.ami_id

  target_group_arn      = module.alb.target_group_arn
  alb_security_group_id = module.alb.security_group_id

  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}