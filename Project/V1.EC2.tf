provider "aws" {
  region = "ap-south-1"
}   

resource "aws_instance" "demo-sg" {
    ami = "ami-0c44f651ab5e9285f"
    instance_type = "t3.micro"
    key_name = "Demo1"
    security_groups = ["SSH-Access"]
}

resource "aws_security_group" "SSH-Access" {
    name = "ssh-access"
    description = "Security group to allow SSH access"

    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"] 

    }  
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = [ "0.0.0.0/0" ]
    }

    tags = {
        Name = "ssh-port"
    }
}