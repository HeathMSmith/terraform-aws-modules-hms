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
  lifecycle_rules = [
    {
      id              = "transition-to-ia"
      enabled         = true
      transition_days = 30
      storage_class   = "STANDARD_IA"
    },
    {
      id              = "transition-to-glacier"
      enabled         = true
      transition_days = 90
      storage_class   = "GLACIER"
    }
  ]
  enable_kms_encryption = false
  kms_key_arn           = "<your-kms-key-arn>"
}

