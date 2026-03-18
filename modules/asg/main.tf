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

  vpc_security_group_ids = [aws_security_group.this.id]

  user_data = base64encode(
    <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y httpd

    systemctl start httpd
    systemctl enable httpd

    echo "<h1>ASG Web Server</h1>" > /var/www/html/index.html
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
  