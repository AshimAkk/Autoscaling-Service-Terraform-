# Create security group for Application Load Balancer to recieve data over port 80 (HTTP)

resource "aws_security_group" "application-lb-sg" {

  description = "Allow HTTP traffic over port 80 on the ALB sgalb.sg"
  name        = "alb-sg"
  vpc_id      = aws_vpc.webservice-vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # 0 = all traffic outbound 
  # protocol -1 allows all traffic both UDP and TCP
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }


  tags = {
    Name = "application-lb--sg"
  }
}