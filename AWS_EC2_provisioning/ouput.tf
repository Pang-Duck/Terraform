output "subnet_id" {
  description = "id of the subnet"
  value       = var.subnet_id != null ? var.subnet_id : aws_subnet.main[0].id
}

output "internet_gateway_id" {
  description = "id of the Internet Gateway"
  value       = var.internet_gateway_id != null ? var.internet_gateway_id : aws_internet_gateway.main[0].id
}

output "instance_ids" {
  description = "ids of created EC2 instances"
  value       = aws_instance.ec2_instance[*].id
}

output "public_ips" {
  description = "public IPs of created EC2 instances"
  value       = aws_instance.ec2_instance[*].public_ip
}

output "private_ips" {
  description = "private IPs of created EC2 instances"
  value       = aws_instance.ec2_instance[*].private_ip
}