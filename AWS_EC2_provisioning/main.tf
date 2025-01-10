// main.tf

#terraform {
#  required_providers {
#    aws = {
#      source  = "hashicorp/aws"
#      version = "~> 3.0"
#    }
#  }
#}

provider "aws" {
  region     = "ap-northeast-2"
  access_key = ""
  secret_key = ""
}


# VPC 설정
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "main-vpc"
  }
}

# 퍼블릭 서브넷 설정
resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-northeast-2a"

  tags = {
    Name = "public-subnet"
  }
}

# 인터넷 게이트웨이
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main-igw"
  }
}

# 라우팅 테이블
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "public-rt"
  }
}

# 서브넷과 라우팅 테이블 연결
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# 보안 그룹
resource "aws_security_group" "web_server" {
  name        = "web-server-sg"
  description = "Security group for web server"
  vpc_id      = aws_vpc.main.id

  # SSH 접속 허용
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP 접속 허용
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # 모든 아웃바운드 트래픽 허용
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "web-server-sg"
  }
}


# EC2 인스턴스
resource "aws_instance" "web_server" {
  ami           = "ami-0c9c942bd7bf113a2" # Amazon Linux 2 AMI ID (서울 리전)
  instance_type = "t2.micro"

  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.web_server.id]
  associate_public_ip_address = true

  root_block_device {
    volume_size = 8
    volume_type = "gp2"
  }


  tags = {
    Name        = "web-server"
    Environment = "production"
  }
}

# 출력 설정
output "public_ip" {
  value = aws_instance.web_server.public_ip
}

output "public_dns" {
  value = aws_instance.web_server.public_dns
}