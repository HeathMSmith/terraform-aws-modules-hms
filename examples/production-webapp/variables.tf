variable "project_name" {
  description = "Project name"
  type        = string
  default     = "production-webapp"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "prod"
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}
variable "domain_name" {
  description = "Root domain"
  type        = string
}

variable "zone_id" {
  description = "Route 53 Hosted Zone ID"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for EC2 instances"
  type        = string
}
