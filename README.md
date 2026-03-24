# AWS Infrastructure Projects (Terraform)

This repository contains modular Terraform configurations and multiple AWS architecture examples, ranging from foundational setups to production-style environments.

---

## ⭐ Featured Project (Start Here)

### Production Web Application (Highly Available)

A production-style AWS architecture designed with security, scalability, and cost efficiency in mind.

**Key features:**

* Application Load Balancer + Auto Scaling Group
* Private EC2 instances (no public IPs)
* AWS Systems Manager (SSM) for access (no SSH)
* VPC Interface Endpoints (no NAT Gateway required)
* HTTPS via ACM + Route53

**What makes this project stand out:**

* Fully private architecture with no internet dependency for management
* Real-world validation of scaling and load balancing
* Troubleshooting of SSM connectivity in a private VPC

👉 [View Project](./examples/production-webapp)

---

## 📚 Additional Examples

These examples demonstrate foundational AWS and Terraform concepts:

### EC2 with VPC

* Basic compute deployment within a custom VPC
* Security groups and networking fundamentals
  👉 `examples/ec2-with-vpc`

---

### VPC Basics

* Custom VPC with subnets, route tables, and internet gateway
  👉 `examples/vpc-basic`

---

### S3 Basics

* Secure S3 bucket configuration with encryption and lifecycle policies
  👉 `examples/s3-basic`

---

## 🧱 Terraform Modules

Reusable modules used across examples:

* VPC
* ALB
* Auto Scaling Group
* ACM

---

## 🎯 Purpose

This repository demonstrates:

* Infrastructure as Code (Terraform)
* AWS networking and security best practices
* Progressive architecture design (basic → production)
* Real-world validation and troubleshooting

---

## 🧠 How to Use

Each example is self-contained. Navigate into any example directory and run:

```bash
terraform init
terraform apply
```
