# ------------------------------
# Security Group
# ------------------------------
resource "aws_security_group" "this" {
  name   = "${var.instance_name}-sg"
  vpc_id = var.vpc_id

  # HTTP access (for web server later)
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # Outbound (required)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}

# ------------------------------
# IAM Role for SSM
# ------------------------------
resource "aws_iam_role" "this" {
  name = "${var.instance_name}-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "this" {
  name = "${var.instance_name}-profile"
  role = aws_iam_role.this.name
}

# ------------------------------
# EC2 Instance
# ------------------------------
resource "aws_instance" "this" {
  ami           = var.ami_id
  instance_type = var.instance_type

  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [aws_security_group.this.name]
  iam_instance_profile        = aws_iam_instance_profile.this.name
  associate_public_ip_address = true

  tags = merge(var.tags, {
    Name = var.instance_name
  })
}