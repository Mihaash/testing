provider "aws" {
  region = "us-east-1"
}

# Latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# Security Group
resource "aws_security_group" "portfolio_sg" {
  name = "portfolio-security-group"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # 🔐 change to YOUR_IP/32 later
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 Instance
resource "aws_instance" "portfolio_server" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  key_name      = var.key_name

  vpc_security_group_ids = [
    aws_security_group.portfolio_sg.id
  ]

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              amazon-linux-extras install docker -y
              systemctl start docker
              systemctl enable docker
              until docker info > /dev/null 2>&1; do
                sleep 2
              done
              docker rm -f portfolio 2>/dev/null
              docker pull mickey06/testing
              docker run -d -p 80:8080 --name portfolio mickey06/portfolio-app:latest
              EOF
  tags = {
    Name = "portfolio-server"
  }
}
