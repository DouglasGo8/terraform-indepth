terraform {
  required_version = "~> 0.12.0"
}

provider "aws" {
  region  = var.region
  profile = var.profile
}

resource "aws_instance" "t2-nano-mult-inst" {
  count                  = var.instance_count
  ami                    = data.aws_ami.amzn2.id
  instance_type          = var.instance_type
  vpc_security_group_ids = ["${data.aws_security_group.allow-ssh.id}"]
  key_name               = aws_key_pair.key-pub.key_name
  user_data              = <<EOF
    #!/bin/bash
    sudo su
    yum update -y
    yum -y install httpd.x86_64
    echo "Hello World from $(hostname -f)" > /var/www/html/index.html
    sudo systemctl enable httpd
    sudo systemctl start httpd
  EOF
  tags = {
    Name = "aws-certified-dev-inst-${count.index + 1}"
  }
}

resource "aws_lb" "my-alb" {
  name               = "my-aws-alb"
  internal           = false # internet-facing
  ip_address_type    = "ipv4"
  load_balancer_type = "application"
  subnets            = var.subnets
  security_groups    = ["${data.aws_security_group.allow-ssh.id}"]
  tags = {
    Name = "MyAwsALB"
  }
}

resource "aws_lb_listener" "my-lb-listener" {
  load_balancer_arn = aws_lb.my-alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.my-target-group.arn
  }
}

resource "aws_lb_target_group" "my-target-group" {
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

resource "aws_lb_target_group_attachment" "my-alb-target-group-multi-inst" {
  count            = var.instance_count
  target_group_arn = aws_lb_target_group.my-target-group.arn
  target_id        = aws_instance.t2-nano-mult-inst[count.index].id
  port             = 80
}

/*resource "aws_lb_target_group_attachment" "my-alb-target-group-multi-inst-attach2" {
  target_group_arn = aws_lb_target_group.my-target-group.arn
  target_id        = aws_instance.t2-nano-mult-inst[1].id
  port             = 80
}
resource "aws_lb_target_group_attachment" "my-alb-target-group-multi-inst-attach3" {
  target_group_arn = aws_lb_target_group.my-target-group.arn
  target_id        = aws_instance.t2-nano-mult-inst[2].id
  port             = 80
}
*/

resource "aws_key_pair" "key-pub" {
  key_name   = "key-pub"
  public_key = file("../../.secret/key.pub")
}
