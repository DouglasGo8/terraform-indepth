data "aws_security_group" "allow-ssh" {
  id = "sg-04fdddd03679588e8"
}

data "aws_ami" "amzn2" {
  most_recent = true

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"] # regex-expression
  }
  owners = ["amazon"]
}
