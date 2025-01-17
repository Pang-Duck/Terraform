variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-northeast-2"
}

variable "instance_count" {
  description = "Number of EC2 instances"
  type        = number
  default     = 1
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "ami_id" {
  description = "AMI ID for EC2 instance"
  type        = string
  default     = "ami-04c535bac3bf07b9a" #Amazonlinux2 x86_64 서울리전
}

variable "vpc_id" {
  description = "Existing VPC ID"
  type        = string
  default     = null
}

variable "vpc_cidr" {
  description = "CIDR block for vpc"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_id" {
  description = "Existing Subnet ID to use"
  type        = string
  default     = null
}

variable "subnet_cidr" {
  description = "CIDR block for subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "internet_gateway_id" {
  description = "Internet Gateway ID"
  type        = string
  default     = null
}

variable "route_table_id" {
  description = "Route Table ID"
  type        = string
  default     = null
}

variable "key_name" {
  description = "Key pair for ssh"
  type        = string
}

variable "environment" {
  description = "Environment tag"
  type        = string
  default     = "test"
}

variable "root_volume_size" {
  description = "Root volume size in GB"
  type        = number
  default     = 100
}

variable "root_volume_type" {
  description = "Root volume type"
  default     = "gp3"
}