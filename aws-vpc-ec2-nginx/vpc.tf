resource "aws_vpc" "project_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "ProjectVPC"
    Environment = "Dev"
  } 
}

#Private Subnet
resource "aws_subnet" "private_subnet" {
    cidr_block = "10.0.1.0/24"
    vpc_id = aws_vpc.project_vpc.id

    tags = {
        Name = "PrivateSubnet"
        Environment = "Dev"
    }
}

#Public Subnet
resource "aws_subnet" "public_subnet" {
  cidr_block = "10.0.2.0/24"
  vpc_id = aws_vpc.project_vpc.id
  map_public_ip_on_launch = true

  tags = {
    Name = "PublicSubnet"
    Environment = "Dev"
  }
}

#Internet Gateway
resource "aws_internet_gateway" "project_igw" {
    vpc_id = aws_vpc.project_vpc.id

    tags = {
        Name = "ProjectInternetGateway"
        Environment = "Dev"
    }
}

#Routing Table
resource "aws_route_table" "public_route_table" {
    vpc_id = aws_vpc.project_vpc.id

    tags = {
        Name = "PublicRouteTable"
        Environment = "Dev"
    }

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.project_igw.id
    }
}
resource "aws_route_table_association" "public-subnet-association" {
  subnet_id = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}