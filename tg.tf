# Create a target group where traffic from the ALB is recieved

resource "aws_lb_target_group" "alb-target-group" {
  name     = "alb-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.webservice-vpc.id

  # when a new instance is created, it's going to check the new instance on port 80, to ensure that the application is running  
  health_check {
    path = "/root"
    port = 80
  }
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

