terraform {
  required_version = "~> 0.12.0"
}

provider "aws" {
  region  = var.region
  profile = var.profile
}

resource "aws_instance" "t2-micro-inst" {
  ami                    = lookup(var.amis, var.region)
  instance_type          = "t2.micro"
  vpc_security_group_ids = ["${data.aws_security_group.allow-ssh.id}"]
  key_name               = aws_key_pair.key-pub.key_name
  user_data = <<EOF
    #!/bin/bash
    sudo su
    yum update -y
    yum -y install httpd.x86_64
    sudo systemctl enable httpd
    sudo systemctl start httpd
  EOF
  tags = {
    Name = "aws-certified-dev-machine-01"
  }
}

resource "aws_key_pair" "key-pub" {
  key_name   = "key-pub"
  public_key = file("../../.secret/key.pub")
}
