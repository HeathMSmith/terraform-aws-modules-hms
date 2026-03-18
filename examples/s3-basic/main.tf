provider "aws" {
  region = "us-east-1"
}

module "s3_bucket" {
  source = "../../modules/s3-bucket"

  bucket_name = "hms-s3-demo-8271"

  tags = {
    Environment = "dev"
    Project     = "terraform-modules"
  }
}