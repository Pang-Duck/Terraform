# VPC 데이터 소스
data "aws_vpc" "selected" {
  count = var.vpc_id != null ? 1 : 0
  id    = var.vpc_id
}

# 새 VPC 리소스
resource "aws_vpc" "main" {
  count                = var.vpc_id == null ? 1 : 0
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "ec2-vpc"
    Environment = var.environment
  }
}

# 서브넷 데이터 소스
data "aws_subnet" "selected" {
  count = var.subnet_id != null ? 1 : 0
  id    = var.subnet_id
}

# 새 서브넷 리소스
resource "aws_subnet" "main" {
  count             = var.subnet_id == null ? 1 : 0
  vpc_id            = var.vpc_id != null ? var.vpc_id : aws_vpc.main[0].id
  cidr_block        = var.subnet_cidr
  availability_zone = "${var.aws_region}a"

  map_public_ip_on_launch = true

  tags = {
    Name        = "ec2-subnet"
    Environment = var.environment
  }
}

# 인터넷 게이트웨이 데이터 소스
data "aws_internet_gateway" "selected" {
  count               = var.internet_gateway_id != null ? 1 : 0
  internet_gateway_id = var.internet_gateway_id
}

# 새 인터넷 게이트웨이 리소스
resource "aws_internet_gateway" "main" {
  count  = var.internet_gateway_id == null ? 1 : 0
  vpc_id = var.vpc_id != null ? var.vpc_id : aws_vpc.main[0].id

  tags = {
    Name        = "ec2-igw"
    Environment = var.environment
  }
}

# 라우트 테이블 데이터 소스
data "aws_route_table" "selected" {
  count          = var.route_table_id != null ? 1 : 0
  route_table_id = var.route_table_id
}

# 새 라우트 테이블 리소스
resource "aws_route_table" "main" {
  count  = var.route_table_id == null ? 1 : 0
  vpc_id = var.vpc_id != null ? var.vpc_id : aws_vpc.main[0].id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.internet_gateway_id != null ? var.internet_gateway_id : aws_internet_gateway.main[0].id
  }

  tags = {
    Name        = "ec2-route-table"
    Environment = var.environment
  }
}

# 라우트 테이블 연결
resource "aws_route_table_association" "main" {
  count          = var.route_table_id == null ? 1 : 0
  subnet_id      = var.subnet_id != null ? var.subnet_id : aws_subnet.main[0].id
  route_table_id = var.route_table_id != null ? var.route_table_id : aws_route_table.main[0].id
}

resource "aws_security_group" "ec2_sg" {
  name_prefix = "ec2-sg-"
  vpc_id      = var.vpc_id != null ? var.vpc_id : aws_vpc.main[0].id
  
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all inbound traffic"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    Name        = "ec2-security-group"
    Environment = var.environment
  }

  lifecycle {
    create_before_destroy = true
  }
}
