resource "aws_security_group" "this" {
  name_prefix = "${var.name}-asg-sg-"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp" #allow ALB later if needed
    security_groups = [var.alb_security_group_id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = var.tags
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

    cat <<EOT > /var/www/html/index.html
    <h1>Production Web App</h1>
    <p>Instance: $(hostname)</p>
    <p>Time: $(date)</p>
    EOT

    cat <<EOT > /var/www/html/health
    healthy
    EOT

    cd /var/www/html
    nohup python3 -m http.server 80 &
    EOF
  )

  tag_specifications {
    resource_type = "instance"
    tags          = var.tags
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

resource "aws_autoscaling_policy" "cpu" {
  name                   = "${var.name}-cpu-policy"
  autoscaling_group_name = aws_autoscaling_group.this.name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 60.0
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
  name = "${var.name}-${var.environment}"
  role = aws_iam_role.this.name
}
  