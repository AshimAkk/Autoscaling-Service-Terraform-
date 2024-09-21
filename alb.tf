# Create security group for Application Load Balancer to recieve data over port 80 (HTTP)

resource "aws_security_group" "application-lb-sg" {

  description = "Allow HTTP traffic over port 80 on the ALB"
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
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }


  tags = {
    Name = "application-lb-sg"
  }
}



# Create a target group where traffic from the ALB is recieved

resource "aws_lb_target_group" "alb-target-group" {
  name     = "alb-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.webservice-vpc.id

  # when a new instance is created, it's going to check the new instance on port 80, to ensure that the application is running  
  health_check {
    path = "/"
    port = 80
  }
}


# Create Application Load Balancer
# ALB created in subnet (PublicSubnet1,PublicSubnet2,publicsubnet3)

resource "aws_lb" "application-load-balancer" {
  load_balancer_type = "application"
  name               = "my-alb"
  security_groups    = [aws_security_group.application-lb-sg.id]
  subnets            = [aws_subnet.PublicSubnet1.id, aws_subnet.PublicSubnet2.id, aws_subnet.PublicSubnet3.id]
}

# Create a Listener, directs traffic that comes in from the ALB alb-tg target group


resource "aws_lb_listener" "my-alb-listener" {
  load_balancer_arn = aws_lb.application-load-balancer.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.alb-target-group.arn
    type             = "forward"
  }
}
