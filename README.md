# Terraform AWS Infrastructure Lab

Hands-on Terraform project that provisions AWS networking, security, and an Ubuntu EC2 server with Docker.

## Architecture

The infrastructure includes:

- AWS VPC
- Public subnet
- Internet Gateway
- Public route table
- Route table association
- Security Group
- AWS key pair
- Ubuntu 24.04 EC2 instance
- Docker installed using Terraform user data

## Architecture Flow

Internet
    |
    v
Internet Gateway
    |
    v
Public Route Table
    |
    v
Public Subnet (10.0.1.0/24)
    |
    v
Ubuntu EC2 (t3.micro)
    |
    v
Docker

## Terraform Resources

| Resource | Purpose |
|---|---|
| VPC | Isolated AWS network |
| Subnet | Public network segment |
| Internet Gateway | Internet connectivity |
| Route Table | Routes public traffic |
| Security Group | Controls inbound and outbound traffic |
| Key Pair | SSH authentication |
| EC2 Instance | Ubuntu server host |

## Prerequisites

- Ubuntu/Linux environment
- Terraform
- AWS CLI
- AWS account
- AWS credentials configured
- Existing SSH public key at ~/.ssh/id_ed25519.pub

Verify Terraform:

    terraform version

Verify AWS authentication:

    aws sts get-caller-identity

## Configuration

Create your local variable file:

    cp terraform.tfvars.example terraform.tfvars

Edit the file:

    nano terraform.tfvars

Set your SSH allowed CIDR:

    ssh_allowed_cidr = "YOUR_PUBLIC_IP/32"

The terraform.tfvars file is intentionally excluded from Git because it contains environment-specific configuration.

## Deploy

Initialize Terraform:

    terraform init

Format the configuration:

    terraform fmt

Validate the configuration:

    terraform validate

Review the execution plan:

    terraform plan

Apply the infrastructure:

    terraform apply

Review the proposed changes and confirm with:

    yes

## View Outputs

Display all Terraform outputs:

    terraform output

Get the EC2 public IP:

    terraform output -raw public_ip

SSH into the server:

    ssh ubuntu@$(terraform output -raw public_ip)

## Verify Docker

After connecting to the EC2 instance:

    docker --version

Test Docker:

    docker run hello-world

A successful hello-world execution confirms that Docker is installed and working.

## Destroy Infrastructure

When the lab is complete:

    terraform destroy

Review the proposed resources to be removed and confirm with:

    yes

This removes the AWS infrastructure managed by this Terraform configuration.

## Git

Terraform state, local variables, and the Terraform working directory are excluded using .gitignore.

The following files should not be committed:

    .terraform/
    terraform.tfstate
    terraform.tfstate.backup
    terraform.tfvars

The Terraform provider lock file is intentionally committed:

    .terraform.lock.hcl

## Project Structure

    terraform-lab-01/
    ├── .gitignore
    ├── .terraform.lock.hcl
    ├── main.tf
    ├── variables.tf
    ├── terraform.tfvars.example
    └── README.md

## Learning Objectives

This project demonstrates practical Terraform and AWS concepts including:

- Infrastructure as Code
- Terraform providers
- Terraform variables
- Terraform outputs
- Terraform data sources
- AWS networking
- VPC and subnet configuration
- Internet Gateway and routing
- Security Groups
- EC2 provisioning
- SSH access
- Terraform state management
- Terraform lifecycle behavior
- Cloud-init and user data
- Docker installation
- Git version control
