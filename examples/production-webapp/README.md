# Production Web Application on AWS (Terraform)

## Overview

This project provisions a production-style web application environment in AWS using Terraform. The goal was to build something that reflects how real systems are designed—secure by default, scalable, and cost-conscious.

Instead of just getting something working, I focused on making intentional design decisions and validating them along the way (load balancing, scaling, and private connectivity).

---

## Architecture

This setup includes:

- A custom VPC across two availability zones
- Public subnets for the Application Load Balancer (ALB)
- Private subnets for EC2 instances (no public IPs)
- Auto Scaling Group (ASG) for resilience and scaling
- HTTPS via AWS Certificate Manager (ACM)
- Route53 for DNS
- AWS Systems Manager (SSM) for instance access
- VPC Interface Endpoints for private AWS service connectivity

---

## Architecture Diagram

![Architecture](./architecture.png)

---

## Key Design Decisions

### Private Compute (No Public Access)

All EC2 instances run in private subnets with no public IPs. There is no SSH access. Instead, I used AWS Systems Manager (SSM) for secure, auditable access.

### No NAT Gateway

I initially considered using a NAT Gateway for outbound access, but chose not to in order to reduce cost and simplify the design. Instead, I implemented VPC interface endpoints for SSM so instances can communicate with AWS services privately.

### Security Group Design

- The ALB allows inbound HTTP/HTTPS from the internet
- EC2 instances only allow inbound traffic from the ALB (not from the internet)
- This enforces a clear separation between public and private layers

### HTTPS Everywhere

TLS certificates are provisioned using ACM and validated via Route53. HTTP traffic is redirected to HTTPS at the load balancer.

---

## Scalability

The application is backed by an Auto Scaling Group using a target tracking policy based on CPU utilization.

To validate this, I:
- Generated artificial CPU load on an instance
- Observed CloudWatch metrics
- Confirmed that a new instance launched automatically
- Verified that traffic was distributed across instances

---

## Load Balancing Validation

To confirm the ALB was distributing traffic correctly, I sent multiple requests and verified responses came from different instances (based on hostname output).

---

## Private Connectivity (SSM)

SSM access is enabled using VPC interface endpoints:

- com.amazonaws.us-east-1.ssm
- com.amazonaws.us-east-1.ec2messages
- com.amazonaws.us-east-1.ssmmessages

Private DNS is enabled so instances can resolve AWS service endpoints internally without needing internet access.

---

## Cost Considerations

- No NAT Gateway (avoids unnecessary monthly cost)
- Minimal always-on infrastructure
- Uses managed services where appropriate

---

## Deployment

From the `examples/production-webapp` directory:

```bash
terraform init
terraform plan
terraform apply
```

---

## Inputs

Example `terraform.tfvars`:

```hcl
ami_id      = "ami-xxxxxxxx"
domain_name = "example.com"
zone_id     = "ZXXXXXXXXXXXX"
```

---

## Outputs

- ALB DNS name (entry point to the application)

---

## Project Structure

```
modules/
  vpc/
  alb/
  asg/
  acm/

examples/
  production-webapp/
```

---

## What This Project Demonstrates

- Infrastructure as Code using Terraform
- Secure AWS networking patterns
- Load balancing and auto scaling
- Private service connectivity without NAT
- Real-world debugging and validation

---

## Possible Improvements

If I were to extend this further:

- Add CloudWatch alarms and dashboards
- Introduce CI/CD (GitHub Actions)
- Add centralized logging (S3 / CloudWatch Logs)
- Expand to multiple environments (dev/stage/prod)

---

## Summary

This project was built to reflect how I would approach a real-world AWS deployment—prioritizing security, simplicity, and cost efficiency while still validating that everything works under load.
