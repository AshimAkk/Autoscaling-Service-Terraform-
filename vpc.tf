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



# Create Public Route Table
# "0.0.0.0/0" is for all routes
resource "aws_route_table" "public-Routetable" {
  vpc_id = aws_vpc.webservice-vpc.id

  route {
    gateway_id = aws_internet_gateway.internet-gw.id
    cidr_block = "0.0.0.0/0"
  }
  tags = {
    Name = "public-routetable"
  }
}


# Create Route table Association with PublicSubnet1 

resource "aws_route_table_association" "PublicSubnet1-route-association" {
  subnet_id      = aws_subnet.PublicSubnet1.id
  route_table_id = aws_route_table.public-Routetable.id
}


# Create Route table Association with PublicSubnet2 

resource "aws_route_table_association" "PublicSubnet2-route-association" {
  subnet_id      = aws_subnet.PublicSubnet2.id
  route_table_id = aws_route_table.public-Routetable.id
}

# Create Route table Association with PublicSubnet3

resource "aws_route_table_association" "PublicSubnet3-route-association" {
  subnet_id      = aws_subnet.PublicSubnet3.id
  route_table_id = aws_route_table.public-Routetable.id

}




# Create PrivateSubnet1

resource "aws_subnet" "PrivateSubnet1" {
  vpc_id            = aws_vpc.webservice-vpc.id
  cidr_block        = "192.168.3.0/24"
  availability_zone = "ap-southeast-2a"

  tags = {
    Name = "PrivateSubnet1"
  }
}

# Create PrivateSubnet2

resource "aws_subnet" "PrivateSubnet2" {
  vpc_id            = aws_vpc.webservice-vpc.id
  cidr_block        = "192.168.4.0/24"
  availability_zone = "ap-southeast-2b"

  tags = {
    Name = "PrivateSubnet2"
  }
}

# Create PrivateSubnet3

resource "aws_subnet" "PrivateSubnet3" {
  vpc_id            = aws_vpc.webservice-vpc.id
  cidr_block        = "192.168.5.0/24"
  availability_zone = "ap-southeast-2c"

  tags = {
    Name = "PrivateSubnet3"
  }
}



# create Elastic IP 
resource "aws_eip" "nat" {
  domain = "vpc"

  depends_on = [ aws_internet_gateway.internet-gw]
  
}

resource "aws_nat_gateway" "nat-main" {
  allocation_id = aws_eip.nat.id
  subnet_id = aws_subnet.PrivateSubnet1.id


  tags = {
    Name = "Nat gateway" 
  }
  
  depends_on = [ aws_internet_gateway.internet-gw ]
}
# private config

# Create private Route Table
# "0.0.0.0/0" is for all routes
resource "aws_route_table" "private-Routetable" {
  vpc_id = aws_vpc.webservice-vpc.id

  route {
    # gateway_id = aws_internet_gateway.internet-gw.id
    nat_gateway_id = aws_nat_gateway.nat-main.id
    cidr_block = "0.0.0.0/0"
  }
  tags = {
    Name = "private-routetable"
  }
}


# Create Route table Association with PrivateSubnet1 

resource "aws_route_table_association" "PrivateSubnet1-route-association" {
  subnet_id      = aws_subnet.PrivateSubnet1.id
  route_table_id = aws_route_table.private-Routetable.id
}


# Create Route table Association with PrivateSubnet2

resource "aws_route_table_association" "PrivateSubnet2-route-association" {
  subnet_id      = aws_subnet.PrivateSubnet2.id
  route_table_id = aws_route_table.private-Routetable.id
}

# Create Route table Association with PrivateSubnet3

resource "aws_route_table_association" "PrivateSubnet3-route-association" {
  subnet_id      = aws_subnet.PrivateSubnet3.id
  route_table_id = aws_route_table.private-Routetable.id
}

