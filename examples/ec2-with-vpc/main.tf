provider "aws" {
  region = "us-east-1"
}

# ------------------------------
# VPC Module
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
# EC2 Module
# ------------------------------
module "ec2" {
  source = "../../modules/ec2"

  instance_name = "hms-ec2-demo"

  ami_id = "ami-0c02fb55956c7d316" # Amazon Linux 2 (us-east-1)

  subnet_id = module.vpc.public_subnet_ids[0]
  vpc_id    = module.vpc.vpc_id

  tags = {
    Project = "terraform-modules"
  }
}

# ------------------------------
# ALB
# ------------------------------
module "alb" {
  source = "../../modules/alb"

  name        = "hms-alb"
  vpc_id      = module.vpc.vpc_id
  subnet_ids  = module.vpc.public_subnet_ids
  instance_id = module.ec2.instance_id

  tags = {
    Project = "terraform-modules"
  }
}