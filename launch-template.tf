# Apache server security group 

resource "aws_security_group" "ec2" {
  name        = "apache-ec2-sg"
  description = "apache-ec2-sg"
  vpc_id      = aws_vpc.webservice-vpc.id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.application-lb-sg.id]
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
    Name = "ec2 security group"
  }

}