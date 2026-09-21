variable "aws_region" {
  description = "AWS region where the lab infrastructure will be created"
  type        = string
  default     = "us-east-1"
}
variable "instance_type" {
  description = "EC2 instance type for the lab server"
  type        = string
  default     = "t3.micro"
}
variable "vpc_cidr" {
  description = "CIDR block for the lab VPC"
  type        = string
  default     = "10.0.0.0/16"
}
variable "subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
  default     = "10.0.1.0/24"
}
variable "ssh_allowed_cidr" {
  description = "CIDR block allowed to access the EC2 instance over SSH"
  type        = string
  default     = "119.152.4.117/32"
}
