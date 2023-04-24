terraform {
  required_version = "~> 0.12.0"
}

provider "aws" {
  region  = var.region
  profile = var.profile
}

resource "aws_instance" "t2-nano-mult-inst" {
  count                  = var.instance_count
  ami                    = lookup(var.amis, var.region)
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

resource "aws_elb" "my-elb" {
  count              = var.instance_count
  name               = "elb-multi-instances"
  availability_zones = var.zones
  security_groups    = ["${data.aws_security_group.allow-ssh.id}"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 20
    target              = "HTTP:80/"
    interval            = 60
  }

  instances                   = aws_instance.t2-nano-mult-inst.*.id
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = {
    Name = "MyELBEC2Multi"
  }

}

resource "aws_key_pair" "key-pub" {
  key_name   = "key-pub"
  public_key = file("../../.secret/key.pub")
}
