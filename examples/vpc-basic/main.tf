provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source = "../../modules/vpc"

  vpc_cidr = "10.0.0.10/16"

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