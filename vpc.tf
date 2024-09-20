# Create a VPC

resource "aws_vpc" "webservice-vpc" {
  cidr_block = "192.168.0.0/16"
  tags = {
    Name = "My-VPC"
  }
}