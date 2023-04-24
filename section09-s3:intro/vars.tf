

variable "profile" { default = "default" }

variable "region" {
  default = "sa-east-1"
}

variable "instance_count" {
  default = "3"
}

variable "instance_type" {
  default = "t2.nano"
}

variable "vpc_id" {
  default = "vpc-54f2af33"
}


variable "subnets" {
  default     = ["subnet-46a5711d", "subnet-5929e73f", "subnet-aa8e45e3"]
  type        = list
  description = "Available Subnets"
}
