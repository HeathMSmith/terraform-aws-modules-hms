variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "list of public subnet cidrs"
  type        = list(string)
}

variable "availability_zones" {
  description = "list of availability zones"
  type        = list(string)
}

variable "tags" {
  description = "resource tags"
  type        = map(string)
  default     = {}
}

variable "private_subnet_cidrs" {
  type = list(string)
}