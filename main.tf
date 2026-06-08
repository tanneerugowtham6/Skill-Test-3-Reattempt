data "aws_ami" "ubuntu_20_04" {
    most_recent = true
    owners = ["099720109477"] # Canonical
    
    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
    }
    
    filter {
        name   = "state"
        values = ["available"]
    }
}

data "aws_vpc" "default" {
    default = true
}

data "aws_subnets" "default" {
    filter {
        name   = "vpc-id"
        values = [data.aws_vpc.default.id]
    }
}

resource "aws_security_group" "nginx_sg" {
    name        = var.security_group_name
    description = "Security group for Nginx server"

    ingress {
        description = "Allow HTTP traffic"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "Allow SSH traffic"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        description = "Allow all outbound traffic"
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_instance" "nginx_server" {
    ami           = data.aws_ami.ubuntu_20_04.id
    instance_type = var.instance_type
    subnet_id     = data.aws_subnets.default.ids[0]
    vpc_security_group_ids = [aws_security_group.nginx_sg.id]
    associate_public_ip_address = var.pub_ip_assoc

    user_data = templatefile("${path.module}/user_data.sh", {})
}