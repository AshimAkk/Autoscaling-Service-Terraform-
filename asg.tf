
# Create Autoscaling group
# placing instances in private subnets



resource "aws_autoscaling_group" "asg" {
  name                 = "apache-asg"
  max_size             = 3
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

# Create autoscaling policies (scale out)
# Cooldown insures that the instance is fully configured before attempting to launch any new instances or make adjustmests to the current configuration 

resource "aws_autoscaling_policy" "autoscaling-policy-up" {
  name                   = "autoscaling-policy-up"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.asg.name


}

# Create Scale up alarm 
# dimension tag assigns this policy to the Autoscaling group


resource "aws_cloudwatch_metric_alarm" "cpu-scale-out-alarm" {
  alarm_name          = "cpu-scale-out-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilisation"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 60
  alarm_description   = "This metric monitors ec2 cpu utilisation and is trigger when utilisation hits 60% or higher "

  dimensions = {
    AutoscalingGroupName = aws_autoscaling_group.asg.name
  }

  alarm_actions = [aws_autoscaling_policy.autoscaling-policy-up.arn]
}

# Create autoscaling policies (scale in)
# -1 removes 1 instance 
resource "aws_autoscaling_policy" "autoscaling-policy-down" {
  name                   = "autoscaling-policy-down"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.asg.name

}


resource "aws_cloudwatch_metric_alarm" "cpu-scale-in-alarm" {
  alarm_name          = "cpu-scale-in-alarm"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilisation"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 10
  alarm_description   = "This metric monitors ec2 cpu utilisation and is trigger when utilisation hits 10% or higher "

  dimensions = {
    AutoscalingGroupName = aws_autoscaling_group.asg.name
  }

  alarm_actions = [aws_autoscaling_policy.autoscaling-policy-down.arn]
}