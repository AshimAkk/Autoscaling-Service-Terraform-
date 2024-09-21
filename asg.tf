
# Create Autoscaling group
# placing instances in private subnets



resource "aws_autoscaling_group" "asg" {
  name                 = "apache-asg"
  max_size             = 5
  min_size             = 2
  health_check_type    = "ELB"
  termination_policies = ["OldestInstance"]
  vpc_zone_identifier  = [aws_subnet.PrivateSubnet1.id, aws_subnet.PrivateSubnet2.id, aws_subnet.PrivateSubnet3.id]

  launch_template {
    id      = aws_launch_template.apache-lt.id
    version = "$Latest"
  }

  # new instances are attached to the target group when they are created
  target_group_arns = [aws_lb_target_group.alb-target-group.arn]
}