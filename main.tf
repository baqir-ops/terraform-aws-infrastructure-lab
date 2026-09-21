terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}
resource "aws_key_pair" "lab_key" {
  key_name   = "terraform-lab-key"
  public_key = file("~/.ssh/id_ed25519.pub")

  tags = {
    Name = "terraform-lab-key"
  }
}
resource "aws_vpc" "lab_vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "terraform-lab-vpc"
  }
}

resource "aws_subnet" "lab_subnet" {
  vpc_id                  = aws_vpc.lab_vpc.id
  cidr_block              = var.subnet_cidr
  map_public_ip_on_launch = true

  tags = {
    Name = "terraform-lab-subnet"
  }
}
resource "aws_internet_gateway" "lab_igw" {
  vpc_id = aws_vpc.lab_vpc.id

  tags = {
    Name = "terraform-lab-igw"
  }
}
resource "aws_route_table" "lab_public_rt" {
  vpc_id = aws_vpc.lab_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.lab_igw.id
  }

  tags = {
    Name = "terraform-lab-public-rt"
  }
}
resource "aws_route_table_association" "lab_subnet_assoc" {
  subnet_id      = aws_subnet.lab_subnet.id
  route_table_id = aws_route_table.lab_public_rt.id
}
resource "aws_security_group" "lab_sg" {
  name        = "terraform-lab-sg"
  description = "Security group for Terraform lab EC2"
  vpc_id      = aws_vpc.lab_vpc.id

  ingress {
    description = "SSH from my public IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ssh_allowed_cidr]
  }

  egress {
    description = "Allow outbound IPv4 traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "terraform-lab-sg"
  }
}
resource "aws_instance" "lab_server" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.lab_subnet.id
  vpc_security_group_ids      = [aws_security_group.lab_sg.id]
  key_name                    = aws_key_pair.lab_key.key_name
  associate_public_ip_address = true

  user_data_replace_on_change = true

  user_data = <<-EOF
    #!/bin/bash
    set -e

    apt-get update
    apt-get install -y docker.io curl

    systemctl enable docker
    systemctl start docker

    usermod -aG docker ubuntu
  EOF

  tags = {
    Name = "terraform-lab-server"
  }
}
output "instance_id" {
  description = "ID of the Terraform lab EC2 instance"
  value       = aws_instance.lab_server.id
}

output "public_ip" {
  description = "Public IP address of the Terraform lab EC2 instance"
  value       = aws_instance.lab_server.public_ip
}

output "private_ip" {
  description = "Private IP address of the Terraform lab EC2 instance"
  value       = aws_instance.lab_server.private_ip
}

output "vpc_id" {
  description = "ID of the Terraform lab VPC"
  value       = aws_vpc.lab_vpc.id
}
