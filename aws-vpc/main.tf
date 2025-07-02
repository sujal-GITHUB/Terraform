terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

#VPC
resource "aws_vpc" "my-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "MyVPC"
    Environment = "Dev"
  }
}

#Private Subnet
resource "aws_subnet" "private-subnet" {
  cidr_block = "10.0.1.0/24"
  vpc_id = aws_vpc.my-vpc.id
  tags = {
    Name = "MyPrivateSubnet"
    Environment = "Dev"
  }
}

#Public Subnet
resource "aws_subnet" "public-subnet" {
  cidr_block = "10.0.2.0/24"
  vpc_id = aws_vpc.my-vpc.id
  tags = {
    Name = "MyPublicSubnet"
    Environment = "Dev"
  } 
}

#Internet Gateway
resource "aws_internet_gateway" "my-igw" {
  vpc_id = aws_vpc.my-vpc.id
  tags = {
    Name = "MyInternetGateway"
    Environment = "Dev"
  }
}

#Routing Table
resource "aws_route_table" "my-rt" {
    vpc_id = aws_vpc.my-vpc.id
    tags = {
        Name = "MyRouteTable"
        Environment = "Dev"
    }

    route{
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.my-igw.id
    }
}

#Route Table Association for Public Subnet
resource "aws_route_table_association" "public-subnet-association" {
  subnet_id = aws_subnet.public-subnet.id
  route_table_id = aws_route_table.my-rt.id
}