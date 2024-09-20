# Create a VPC

resource "aws_vpc" "webservice-vpc" {
  cidr_block = "192.168.0.0/16"
  tags = {
    Name = "My-VPC"
  }
}


# Create Public Subnet 1
resource "aws_subnet" "PublicSubnet1" {
  vpc_id            = aws_vpc.webservice-vpc.id
  cidr_block        = "192.168.0.0/24"
  availability_zone = "ap-southeast-2a"
  tags = {
    Name = "PublicSubnet1"
  }
}


# Create Public Subnet 2
resource "aws_subnet" "PublicSubnet2" {
  vpc_id            = aws_vpc.webservice-vpc.id
  cidr_block        = "192.168.1.0/24"
  availability_zone = "ap-southeast-2b"
  tags = {
    Name = "PublicSubnet2"
  }
}


# Create Public Subnet 3
resource "aws_subnet" "PublicSubnet3" {
  vpc_id            = aws_vpc.webservice-vpc.id
  cidr_block        = "192.168.2.0/24"
  availability_zone = "ap-southeast-2c"
  tags = {
    Name = "PublicSubnet3"
  }
}



# Create an Internet Gateway
resource "aws_internet_gateway" "internet-gw" {
  vpc_id = aws_vpc.webservice-vpc.id
  tags = {
    Name = "my-internet-gateway"
  }
}