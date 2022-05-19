provider "aws" {
    region = "us-west-1"   
    access_key = "xxIARLEA2aDAOIKBxxxx"        
    secret_key =  "xxxxxxxvzeX4kEqB6hNGMXBVB8IKqTsH7+xxxx"     
}
#1. Create vpc    创建vpc
resource "aws_vpc" "prod-vpc" {
  cidr_block       = "10.0.0.0/16"   
  instance_tenancy = "default"

  tags = {
    Name = "prod"
  }
}

resource "aws_internet_gateway" "gw" {
    vpc_id = aws_vpc.prod-vpc.id      
}
resource "aws_route_table" "prod-route-table" {
  vpc_id = aws_vpc.prod-vpc.id     

  route {
    cidr_block = "0.0.0.0/0"  
    gateway_id = aws_internet_gateway.gw.id     
  }

  route {
    ipv6_cidr_block        = "::/0"
    gateway_id = aws_internet_gateway.gw.id        
  }

  tags = {
    Name = "Prod"
  }
}
resource "aws_subnet" "subnet-2" {   
    vpc_id = aws_vpc.prod-vpc.id   
    cidr_block = "10.0.1.0/24"     
    availability_zone = "us-west-1b"       
    tags = {         
        Name = "prod-subnet"
    }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.subnet-2.id
  route_table_id = aws_route_table.prod-route-table.id
}
resource "aws_security_group" "allow_web" {
  name        = "allow_web"
  description = "Allow web inbound traffic"
  vpc_id      = aws_vpc.prod-vpc.id         


  ingress {
    description = "HTTPS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_web"
  }
}

resource "aws_network_interface" "web-server-nic" {
  subnet_id       = aws_subnet.subnet-2.id
  private_ips     = ["10.0.1.50"]
  security_groups = [aws_security_group.allow_web.id]

}
resource "aws_eip" "one" {
  vpc      = true
  network_interface     = aws_network_interface.web-server-nic.id      
  depends_on       =    [aws_internet_gateway.gw]
}
# 9.Create Ubuntu server and install/enable apache2
resource "aws_instance" "web-server-instance" {
    ami = "ami-0528712befcd5d885"  
    instance_type = "t2.micro"        
    availability_zone = "us-west-1b"   
    key_name = "ec2"  

    network_interface {
        device_index = 0
        network_interface_id = aws_network_interface.web-server-nic.id
    }
    user_data = <<-EOF
                   #!/bin/bash
                   sudo apt update -y
                   EOF
    tags  =  {
        Name = "web-server"
    }
}
output "server_private_ip" {      
  value       = aws_instance.web-server-instance.private_ip
}
output "server_id" {        d
  value       = aws_instance.web-server-instance.id
}
output "server_public_ip" {
  value       = aws_eip.one.public_ip
  description = "This is web-server's public ip"
}

