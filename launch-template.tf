# EC2 security group 

resource "aws_security_group" "ec2-sg" {
  name        = "ec2-sg"
  description = "ec2-sg"
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
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ec2 security group"
  }

}


# stores all the EC2 configurations we desire 
# referencing bash script to install apache 
# 'tag specification' attach tags to newly created resources 
#

resource "aws_launch_template" "apache-lt" {
  name                   = "apache-lt"
  description            = "my apache launch template"
  image_id               = var.ami
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.ec2-sg.id]
  user_data              = filebase64("scripts/install_apache.sh")

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "apache-server"
    }
  }
}
