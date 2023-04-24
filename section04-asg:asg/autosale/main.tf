
terraform {
  required_version = "~> 0.12.0"
}

variable zones {}
variable vpc_id {}
variable region {}
variable subnets {}
variable profile {}
variable instance_type {}

provider "aws" {
  region  = var.region
  profile = var.profile
}

# Newest Launch Template AWS
resource "aws_launch_template" "MyFirstTemplate" {
  name_prefix                          = "MyFirstTemplate"
  image_id                             = data.aws_ami.amzn2.id
  instance_type                        = var.instance_type
  key_name                             = aws_key_pair.key-pub.key_name
  vpc_security_group_ids               = ["${data.aws_security_group.allow-ssh-http.id}"]
  instance_initiated_shutdown_behavior = "terminate"
  user_data                            = filebase64("../apache/httpd.sh")
}

resource "aws_autoscaling_group" "MyFirstASG" {
  name                      = "MyFirstASG"
  min_size                  = 2
  max_size                  = 5
  desired_capacity          = 3
  force_delete              = true
  vpc_zone_identifier       = ["${data.aws_subnet.main-public-1.id}", "${data.aws_subnet.main-public-2.id}", "${data.aws_subnet.main-public-3.id}"]
  target_group_arns         = ["${aws_lb_target_group.MyTargetGroupASG.arn}"]
  health_check_type         = "ELB"
  health_check_grace_period = 300
  launch_template {
    id      = aws_launch_template.MyFirstTemplate.id
    version = "$Latest"
  }
  tag {
    key                 = "Name"
    value               = "EC2 Instance"
    propagate_at_launch = true
  }
}

# TargetTrackingScaling
/*resource "aws_autoscaling_policy" "MyFirstASGTTrackingSPolices" {
  name                      = "MyFirstASGTTrackingSPolices"
  autoscaling_group_name    = aws_autoscaling_group.MyFirstASG.name
  adjustment_type           = "ExactCapacity"
  policy_type               = "TargetTrackingScaling"
  estimated_instance_warmup = 30 // instances need
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 40.0
  }
}*/

# Step Scaling
/*resource "aws_autoscaling_policy" "MyFirstASGStepSPolices" {
  name                      = "MyFirstASGStepSPolices"
  autoscaling_group_name    = aws_autoscaling_group.MyFirstASG.name
  adjustment_type           = "ExactCapacity"
  policy_type               = "StepScaling"
  estimated_instance_warmup = 30 // instances need
  step_adjustment {
    scaling_adjustment          = 1
    metric_interval_lower_bound = 2.0
    metric_interval_upper_bound = 3.0
  }
}*/

# SimpleScaling
resource "aws_autoscaling_policy" "MyFirstASGSimpleSPolices" {
  name                   = "MyFirstASGSimpleSPolices"
  autoscaling_group_name = aws_autoscaling_group.MyFirstASG.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = 42
  cooldown               = 300
  policy_type            = "SimpleScaling"
}

resource "aws_cloudwatch_metric_alarm" "MyFirstCloudWatchMetricAlarmASG" {
  alarm_name          = "MyFirstCloudWatchMetricAlarmASG"
  alarm_description   = "CPU Metric over Cloudwatch"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 30
  dimensions = {
    "AutoScalinggroupName" = "${aws_autoscaling_group.MyFirstASG.name}"
  }

  actions_enabled = true
  alarm_actions   = ["${aws_autoscaling_policy.MyFirstASGSimpleSPolices.arn}"]
}

resource "aws_lb" "MyFirsLBASG" {
  name               = "MyFirsLBASG"
  internal           = false # internet-facing
  ip_address_type    = "ipv4"
  load_balancer_type = "application"
  subnets            = var.subnets
  security_groups    = ["${data.aws_security_group.allow-ssh-http.id}"]
  tags = {
    Name = "MyAwsALB"
  }
}

resource "aws_lb_listener" "MyLBListenerASG" {
  load_balancer_arn = aws_lb.MyFirsLBASG.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.MyTargetGroupASG.arn
  }
}

resource "aws_lb_target_group" "MyTargetGroupASG" {
  name        = "my-target-group"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = var.vpc_id

  health_check {
    interval            = 10
    path                = "/"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }
}

resource "aws_key_pair" "key-pub" {
  key_name   = "key-pub"
  public_key = file("../../.secret/key.pub")
}
