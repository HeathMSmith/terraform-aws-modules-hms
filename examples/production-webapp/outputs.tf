output "alb_dns_name" {
  description = "Public URL for the application"
  value       = module.alb.alb_dns_name
}
output "application_url" {
  description = "Application endpoint"
  value       = "https://${var.domain_name}"
}
output "asg_name" {
  description = "Auto Scaling Group name"
  value       = module.asg.asg_name
}
output "vpc_id" {
  value = module.vpc.vpc_id
}