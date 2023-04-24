data "aws_security_group" "allow-ssh-http" {
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


data "aws_subnet" "main-public-1" {
  id = "subnet-46a5711d"
}

data "aws_subnet" "main-public-2" {
  id = "subnet-5929e73f"
}

data "aws_subnet" "main-public-3" {
  id = "subnet-aa8e45e3"
}
