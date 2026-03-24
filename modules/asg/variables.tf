variable "name" {
  type = string
}

variable "ami_id" {
  type = string
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "subnet_ids" {
  type = list(string)
}

variable "vpc_id" {
  type = string
}

variable "target_group_arn" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}
variable "alb_security_group_id" {
  description = "Security group of the ALB"
  type        = string
}
variable "environment" {
  description = "Environment name (e.g. dev, prod)"
  type        = string
}