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