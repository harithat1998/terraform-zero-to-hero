provider "aws" {
  region = "us-west-2"# Replace with your desired AWS region
}

resource "aws_vpc" "main" {
cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "main-vpc"
  }
}

resource "aws_subnet" "subnet_1" {
vpc_id = aws_vpc.main.id
cidr_block = "10.0.1.0/24"
availability_zone= "us-west-2a"# Modify as per the region
map_public_ip_on_launch = true
tags = {
    Name = "subnet-1"
}
}

resource "aws_subnet" "subnet_2" {
vpc_id = aws_vpc.main.id
cidr_block = "10.0.2.0/24"
  availability_zone= "us-west-2b"# Modify as per the region
  map_public_ip_on_launch = true
  tags = {
    Name = "subnet-2"
}
}

resource "aws_internet_gateway" "igw" {
vpc_id = aws_vpc.main.id
tags = {
    Name = "main-igw"
}
}

resource "aws_route_table" "rtable" {
vpc_id = aws_vpc.main.id
route {
   cidr_block = "0.0.0.0/0"
gateway_id = aws_internet_gateway.igw.id
  }

tags = {
    Name = "main-route-table"
  }
}

resource "aws_route_table_association" "subnet_1_association" {
subnet_id = aws_subnet.subnet_1.id
route_table_id = aws_route_table.rtable.id
}

resource "aws_route_table_association" "subnet_2_association" {
subnet_id = aws_subnet.subnet_2.id
route_table_id = aws_route_table.rtable.id
}
