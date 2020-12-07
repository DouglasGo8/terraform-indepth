
resource "aws_lb" "lb-front-end" {
  name               = "${var.PROJECT_NAME}-Front-End-ALB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${aws_security_group.sg-webservers-alb.id}"]
}

resource "aws_lb_listener" "lbl_webserver" {
  load_balancer_arn = aws_lb.lb-front-end.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    target_group_arn = aws_lb_target_group.ltg-front-end.arn
    type             = "forward"
  }
}

resource "aws_lb_target_group" "ltg-front-end" {
  name     = "Target-Group-fo-frontend"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
}

resource "aws_security_group" "sg-webservers-alb" {
  name        = "${var.PROJECT_NAME}-sg-webservers-ALB"
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
