provider "aws" {
  region = "us-east-1"
}

# ------------------------------
# VPC
# ------------------------------
module "vpc" {
  source = "../../modules/vpc"

  vpc_cidr = "10.0.0.0/16"

  public_subnet_cidrs = [
    "10.0.1.0/24",
    "10.0.2.0/24"
  ]

  availability_zones = [
    "us-east-1a",
    "us-east-1b"
  ]

  tags = {
    Project = "terraform-modules"
  }
}

# ------------------------------
# ACM (SSL Certificate)
# ------------------------------
module "acm" {
  source = "../../modules/acm"

  domain_name = "hmsdev.click"          # 🔁 CHANGE THIS
  zone_id     = "Z01454722VUNO8SQZYLZ8" # 🔁 CHANGE THIS
}

# ------------------------------
# ALB
# ------------------------------
module "alb" {
  source = "../../modules/alb"

  name       = "hms-alb"
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.public_subnet_ids

  certificate_arn = module.acm.certificate_arn
  domain_name     = "hmsdev.click"
  zone_id         = "Z01454722VUNO8SQZYLZ8"
  tags = {
    Project = "terraform-modules"
  }
}

# ------------------------------
# Auto Scaling Group
# ------------------------------
module "asg" {
  source = "../../modules/asg"

  name = "hms-asg"

  ami_id = "ami-0c02fb55956c7d316" # Amazon Linux 2 (us-east-1)

  subnet_ids = module.vpc.public_subnet_ids
  vpc_id     = module.vpc.vpc_id

  target_group_arn = module.alb.target_group_arn

  tags = {
    Project = "terraform-modules"
  }
}