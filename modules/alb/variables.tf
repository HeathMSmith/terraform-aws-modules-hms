variable "name" {
  description = "Name of the ALB"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "subnet_ids" {
  description = "Public subnet IDs"
  type        = list(string)
}

#variable "instance_id" {
#  description = "EC2 instance to attach"
#  type        = string
#}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "certificate_arn" {
  description = "ACM certificate ARN"
  type        = string
}

variable "domain_name" {
  type = string
}

variable "zone_id" {
  type = string
}
variable "allowed_cidr_blocks" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}