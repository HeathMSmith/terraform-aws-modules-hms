# 🚀 Production Web Application on AWS (Terraform)

## 📌 Overview

This project provisions a production-style, highly available web application infrastructure on AWS using Terraform.

It demonstrates secure, scalable, and cost-aware architecture patterns aligned with real-world cloud engineering practices.

---

## 🧱 Architecture

This environment deploys a fully private, load-balanced web application using:

- Multi-AZ VPC
- Public subnets for Application Load Balancer (ALB)
- Private subnets for EC2 instances (no public IPs)
- Auto Scaling Group (ASG) for compute layer
- Application Load Balancer with HTTPS (ACM)
- Route53 for DNS
- AWS Systems Manager (SSM) for instance access
- VPC Interface Endpoints (no NAT required)

---

## 🖼️ Architecture Diagram

![Architecture](./architecture.png)

---

## 🔐 Security Design

- EC2 instances are deployed in private subnets with no public IPs
- No SSH access is allowed
- Access is managed via AWS Systems Manager (SSM)
- Security groups enforce least-privilege access:
  - ALB allows HTTP/HTTPS from the internet
  - EC2 instances only accept traffic from the ALB
- No direct inbound access to compute layer

---

## 🌐 HTTPS Configuration

- TLS certificates are provisioned using AWS Certificate Manager (ACM)
- DNS validation is automated via Route53
- HTTP traffic is automatically redirected to HTTPS

---

## ⚡ Scalability

- Auto Scaling Group dynamically adjusts capacity
- Target tracking policy based on CPU utilization
- Load balancer distributes traffic across instances

---

## 🔐 Private Connectivity Design (Key Feature)

This architecture operates entirely within private subnets without requiring outbound internet access.

- No NAT Gateway is used
- AWS Systems Manager (SSM) access is enabled via VPC Interface Endpoints
- Private DNS is enabled for seamless AWS service resolution
- All communication with AWS services remains within the VPC

---

## 💰 Cost Optimization

- Eliminates NAT Gateway (~$30/month savings)
- Uses VPC Interface Endpoints for AWS service access
- Minimal always-on infrastructure footprint

---

## 🛠️ Deployment Instructions

### 1. Initialize Terraform

```bash
terraform init
```

### 2. Review Execution Plan

```bash
terraform plan
```

### 3. Apply Infrastructure

```bash
terraform apply
```

---

## 📥 Inputs

Example `terraform.tfvars`:

```hcl
ami_id      = "ami-xxxxxxxx"
domain_name = "example.com"
zone_id     = "ZXXXXXXXXXXXX"
```

---

## 📤 Outputs

- ALB DNS name (entry point to application)

---

## 🧪 Testing

### Verify Application

- Open the ALB DNS name in a browser
- Confirm HTTPS is working
- Page displays instance hostname and timestamp

---

### Test Load Balancing

```bash
for i in {1..10}; do curl http://<alb-dns>; done
```

Verify responses come from multiple instances.

---

### Test Auto Scaling

1. Connect to instance via SSM
2. Generate CPU load:

```bash
yes > /dev/null &
yes > /dev/null &
```

3. Observe:
- CPU utilization increase in CloudWatch
- New instance launched by ASG

---

## 🧠 Key Design Decisions

- Used private subnets for compute to reduce attack surface
- Eliminated SSH in favor of SSM Session Manager
- Avoided NAT Gateway to reduce cost and simplify architecture
- Enabled private AWS service access using VPC Interface Endpoints
- Implemented modular Terraform structure for reusability

---

## 🧩 Project Structure

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

## 🎯 Purpose

This project demonstrates:

- Infrastructure as Code (Terraform)
- AWS networking and security best practices
- Scalable and highly available system design
- Cost-aware cloud architecture
- Real-world debugging and operational validation

---

## 🚀 Next Steps (Potential Enhancements)

- Add CloudWatch alarms and dashboards
- Integrate CI/CD pipeline (GitHub Actions)
- Add centralized logging (CloudWatch Logs / S3)
- Introduce multi-environment support (dev/stage/prod)
