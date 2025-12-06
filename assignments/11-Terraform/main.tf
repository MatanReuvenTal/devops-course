terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider to work with LocalStack
provider "aws" {
  region                      = "us-east-1"
  access_key                  = "test"
  secret_key                  = "test"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  # Redirect requests to LocalStack container
  endpoints {
    ec2 = "http://localhost:4566"
    iam = "http://localhost:4566"
    s3  = "http://localhost:4566"
  }
}

# ---------------------------------------------------------
# Data Source: Dynamically find an Ubuntu AMI
# in the LocalStack environment.
# ---------------------------------------------------------
data "aws_ami" "ubuntu" {
  most_recent = true
  # Include "amazon" and "self" to search both upstream and local images
  owners      = ["amazon", "self", "099720109477"]

  filter {
    name   = "name"
    # Broad search pattern to find any available Ubuntu image
    values = ["*ubuntu*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

# ---------------------------------------------------------
# Task 2: Create Security Group
# ---------------------------------------------------------
resource "aws_security_group" "web_sg" {
  name        = "web-server-sg"
  description = "Allow HTTP and SSH traffic"

  # Allow SSH traffic (Port 22)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow HTTP traffic (Port 80)
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow traffic on port 8000 (Required for WordPress)
  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ---------------------------------------------------------
# Task 1 + CHALLENGE: EC2 Instance with Auto-Installation
# ---------------------------------------------------------
resource "aws_instance" "web_server" {
  # Use the AMI ID returned by the data source
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"

  # Attach the security group created above
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  tags = {
    Name = "DevOps-Assignment-Server"
  }

  # -------------------------------------------------------
  # User Data Script:
  # 1. Installs Docker & Docker Compose
  # 2. Creates the docker-compose.yml file
  # 3. Deploys the WordPress stack
  # -------------------------------------------------------
  user_data = <<-EOF
    #!/bin/bash

    # 1. Update package list and install Docker
    sudo apt-get update -y
    sudo apt-get install -y docker.io docker-compose

    # 2. Start and enable Docker service
    sudo systemctl start docker
    sudo systemctl enable docker

    # 3. Create project directory
    mkdir -p /home/ubuntu/wordpress
    cd /home/ubuntu/wordpress

    # 4. Generate docker-compose.yml file (content from assignment)
    cat <<EOT > docker-compose.yml
    version: '3.3'
    services:
      db:
        image: mysql:5.7
        volumes:
          - db_data:/var/lib/mysql
        restart: always
        environment:
          MYSQL_ROOT_PASSWORD: somewordpress
          MYSQL_DATABASE: wordpress
          MYSQL_USER: wordpress
          MYSQL_PASSWORD: wordpress
      wordpress:
        depends_on:
          - db
        image: wordpress:latest
        ports:
          - "8000:80"
        restart: always
        environment:
          WORDPRESS_DB_HOST: db:3306
          WORDPRESS_DB_USER: wordpress
          WORDPRESS_DB_PASSWORD: wordpress
          WORDPRESS_DB_NAME: wordpress
        volumes:
          - db_data:{}
    volumes:
      db_data:
    EOT

    # 5. Run the application
    sudo docker-compose up -d
  EOF
}