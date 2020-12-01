# front end app
resource "aws_autoscaling_group" "webserver" {
  name                      = "app_web"
  min_size                  = 3
  max_size                  = 7
  force_delete              = true
  desired_capacity          = 3
  health_check_type         = "EC2"
  health_check_grace_period = 30
  launch_configuration      = aws_launch_configuration.app-launch-webserver.name
  vpc_zone_identifier       = ["${aws_subnet.public_subnet_1.id}", "${aws_subnet.public_subnet_2.id}"]
  target_group_arns         = ["${aws_lb_target_group.ltg-front-end.arn}"]
}

# back end app
resource "aws_autoscaling_group" "appserver" {
  name                      = "app_back"
  min_size                  = 3
  max_size                  = 9
  force_delete              = true
  desired_capacity          = 3
  health_check_type         = "EC2"
  health_check_grace_period = 30
  launch_configuration      = aws_launch_configuration.app-launch-appserver.name
  vpc_zone_identifier       = ["${aws_subnet.private_subnet_1.id}", "${aws_subnet.private_subnet_2.id}"]
  target_group_arns         = ["${aws_lb_target_group.ltg-back-end.arn}"]
}

# launch configuraion for front end web server
resource "aws_launch_configuration" "app-launch-webserver" {
  name            = "webserver-asg-lc"
  image_id        = data.aws_ami.ubuntu.id
  instance_type   = var.WEB_SERVER_INSTANCE_TYPE
  user_data       = file(var.USER_DATA_FOR_WEBSERVER)
  security_groups = ["${aws_security_group.sg-webservers.id}"]
  key_name        = aws_key_pair.key-pub.key_name
  root_block_device {
    volume_type = "gp2"
    volume_size = "30"
  }
}

# launch configuration for back end server
resource "aws_launch_configuration" "app-launch-appserver" {
  name            = "appserver-asg-lc"
  image_id        = data.aws_ami.ubuntu.id
  instance_type   = var.APP_SERVER_INSTANCE_TYPE
  user_data       = file(var.USER_DATA_FOR_APPSERVER)
  security_groups = ["${aws_security_group.sg-appservers.id}"]
  key_name        = aws_key_pair.key-pub.key_name
  root_block_device {
    volume_type = "gp2"
    volume_size = "30"
  }
}

resource "aws_security_group" "sg-webservers" {
  name        = "${var.PROJECT_NAME}-ec2-sg-webservers"
  description = "Created by Dougdb"
  vpc_id      = aws_vpc.main.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.SSH_CIDR_WEB_SERVER}"]

  }
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

  tags = {
    Name = "${var.PROJECT_NAME}-ec2-webservers"
  }
}

resource "aws_security_group" "sg-appservers" {
  name        = "${var.PROJECT_NAME}-ec2-appservers"
  description = "Created by Dougdb"
  vpc_id      = aws_vpc.main.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.SSH_CIDR_APP_SERVER}"]
  }
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
  tags = {
    Name = "${var.PROJECT_NAME}-ec2-appservers"
  }
}

resource "aws_key_pair" "key-pub" {
  key_name   = "key-pub"
  public_key = file("../../../.secret/key.pub")
}
