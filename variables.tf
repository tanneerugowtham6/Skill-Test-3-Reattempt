variable "aws_region" {
    description = "AWS Region to be used to deploy resources"
    default = "us-east-1"
}

variable "security_group_name" {
    description = "Name of the security group for the Nginx server"
    default = "nginx_sg"
}

variable "instance_type" {
    description = "EC2 instance type"
    default = "t3.micro"
}

variable "pub_ip_assoc" {
    description = "Whether to associate a public IP address with the EC2 instance"
    default = false
}