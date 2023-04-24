terraform {
  required_version = "~> 0.12.0"
}

provider "aws" {
  region  = var.region
  profile = var.profile
}

resource "aws_iam_role" "s3_role" {
  name               = "s3_role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
  tags = {
    tag-key = "s3-role"
  }
}

resource "aws_iam_instance_profile" "s3_instance_profile" {
  name = "s3_instance_profile"
  role = aws_iam_role.s3_role.name
}

// Can contain multiple policies
resource "aws_iam_role_policy" "s3_iam_role_policy" {
  name   = "s3_iam_role_policy"
  role   = aws_iam_role.s3_role.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:GetObject",
        "s3:ListObject"
      ],
      "Effect": "Allow",
      "Resource": "*"
      "Sid": "StmtMySid1"
    },
    {
      "Sid": "StmtMySid2",
      "Effect": "Allow",
      "Action": [
        "sts:DecodeAuthorizationMessage",
        "ec2:RunInstances"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_instance" "t2-micro-inst" {
  ami                    = lookup(var.amis, var.region)
  instance_type          = "t2.micro"
  vpc_security_group_ids = ["${data.aws_security_group.allow-ssh.id}"]
  key_name               = aws_key_pair.key-pub.key_name
  iam_instance_profile   = aws_iam_instance_profile.s3_instance_profile.name
  tags = {
    Name = "aws-cert-dev-machine-01"
  }
}

resource "aws_key_pair" "key-pub" {
  key_name   = "key-pub"
  public_key = file("../../.secret/key.pub")
}
