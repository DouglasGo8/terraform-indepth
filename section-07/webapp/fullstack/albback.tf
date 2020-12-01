resource "aws_lb" "lb-back-end" {
  name               = "${var.PROJECT_NAME}-Back-End-ALB"
  internal           = true
  load_balancer_type = "application"
  # same sg alb to front and back servers
  security_groups = ["${aws_security_group.sg-appservers-alb.id}"]
  subnets         = ["${aws_subnet.private_subnet_2.id}", "${aws_subnet.private_subnet_1.id}"]
}

resource "aws_lb_listener" "lbl_appserver" {
  load_balancer_arn = aws_lb.lb-back-end.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    target_group_arn = aws_lb_target_group.ltg-back-end.arn
    type             = "forward"
  }
}

resource "aws_lb_target_group" "ltg-back-end" {
  name     = "Target-Group-for-backend"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
}

resource "aws_security_group" "sg-appservers-alb" {
  name        = "${var.PROJECT_NAME}-sg-appservers-ALB"
  description = "Created by Dougdb"
  vpc_id      = aws_vpc.main.id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
