provider "aws" {
  region = "ap-south-1"
}   

resource "aws_instance" "demo-server" {
    ami = "ami-0c44f651ab5e9285f"
    instance_type = "t3.micro"
    key_name = "Demo3"
    vpc_security_group_ids = [aws_security_group.demo_sg1.id]
    subnet_id = aws_subnet.demo-public-subnet-1.id
    for_each = toset(["Jenkins-Master", "Build-slave", "ansible"])
    tags = {
        Name = "${each.key}"
    }
}

resource "aws_security_group" "demo_sg1" {
    name = "demo-sg1"
    description = "Security group to allow SSH access"
    vpc_id = aws_vpc.demo-vpc.id

    ingress {
        description = "Allow SSH"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"] 

    }  

     ingress {
        description = "Allow HTTP"
        from_port   = 8080
        to_port     = 8080
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

resource "aws_vpc" "demo-vpc" {
    cidr_block = "10.0.0.0/16"
    tags = {
      Name = "demo-vpc"
    }
}

resource "aws_subnet" "demo-public-subnet-1" {
    vpc_id            = "aws_vpc.demo-vpc.id"
    cidr_block        = "10.0.1.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = "ap-south-1a"
    tags = {
        Name = "demo-public-subnet-1"
    }
}
resource "aws_subnet" "demo-public-subnet-2" {
    vpc_id            = "aws_vpc.demo-vpc.id"
    cidr_block        = "10.0.2.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = "ap-south-1b"
    tags = {
        Name = "demo-public-subnet-2"
    }
}

resource "aws_internet_gateway" "demo-igw" {
    vpc_id = aws_vpc.demo-vpc.id
    tags = {
        Name = "demo-igw"
    }
}

resource "aws_route_table" "demo-public-rt" {
    vpc_id = aws_vpc.demo-vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.demo-igw.id
    }
    tags = {
        Name = "demo-public-rt"
    }
}

resource "aws_route_table_association" "demo-rta-public-1" {
    subnet_id      = aws_subnet.demo-public-subnet-1.id
    route_table_id = aws_route_table.demo-public-rt.id
}

resource "aws_route_table_association" "demo-rta-public-2" {
    subnet_id      = aws_subnet.demo-public-subnet-2.id
    route_table_id = aws_route_table.demo-public-rt.id
}