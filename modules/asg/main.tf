resource "aws_security_group" "this" {
  name_prefix = "${var.name}-asg-sg-"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [] #allow ALB later if needed
    cidr_blocks     = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_launch_template" "this" {
  name_prefix   = "${var.name}-lt-"
  image_id      = var.ami_id
  instance_type = var.instance_type
  iam_instance_profile {
    name = aws_iam_instance_profile.this.name
  }
  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [aws_security_group.this.id]
  }

  user_data = base64encode(
    <<-EOF
    #!/bin/bash

    mkdir -p /var/www/html

    echo "<h1>ASG Web Server 🚀</h1>" > /var/www/html/index.html

    # Use Python built-in HTTP server (already installed)
    nohup python3 -m http.server 80 --directory /var/www/html &
  EOF
  )

  tag_specifications {
    resource_type = "instance"

    tags = var.tags
  }
}

resource "aws_autoscaling_group" "this" {
  name             = var.name
  min_size         = 1
  max_size         = 2
  desired_capacity = 1

  vpc_zone_identifier = var.subnet_ids
  target_group_arns   = [var.target_group_arn]

  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = var.name
    propagate_at_launch = true
  }
}

resource "aws_iam_role" "this" {
  name = "${var.name}-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "this" {
  name = "${var.name}-profile"
  role = aws_iam_role.this.name
}
  