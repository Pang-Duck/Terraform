// ec2 resource
resource "aws_instance" "ec2_instance" {
  count         = var.instance_count
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id != null ? var.subnet_id : aws_subnet.main[0].id
  key_name      = var.key_name

  root_block_device {
  volume_size = var.root_volume_size
  volume_type = var.root_volume_type
  }

  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  tags = {
    Name        = "node-${count.index + 1}"
    Environment = var.environment
  }
}

