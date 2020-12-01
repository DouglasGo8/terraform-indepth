output "aws_ami" {
  value = "${data.aws_ami.ubuntu.id}"
}

output "aws_lb_back_end_endpoint" {
  value = "${aws_lb.lb-back-end.dns_name}"
}
