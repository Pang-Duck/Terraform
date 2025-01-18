#######################################################
aws_region           = "ap-northeast-2"
access_key           = ""
secret_key           = ""

#######################################################

instance_count       = 1
instance_type        = "t2.micro"
ami_id               = "ami-04c535bac3bf07b9a"
key_name             = "pky"
environment          = "test"
root_volume_size     = 100
availability_zone    = "a"
root_volume_type     = "gp3"
vpc_id               = null
vpc_cidr             = "10.0.0.0/16"
subnet_id            = null
subnet_cidr          = "10.0.1.0/24"
internet_gateway_id  = null
route_table_id       = null