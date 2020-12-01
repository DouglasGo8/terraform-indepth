# Terraform indepth (2020) - Real world Job Cases

---

## Links

* (Git) [https://github.com/cloudopsacademy/Terraformcourse]

### VPC Module

* 2 Public Subnets for Web and App servers and 2 Private Subnets for database servers (RDS)
* NAT Gateway for private instances to access Internet
* Public instances access internet by Internet Gateway
* Elastic IP attached in NAT Gateway
* VPC Components
  * aws_vpc_main
  * aws_eip.nat_eip
  * aws_internet_gateway.igw
  * aws_nat_gateway.ngw
  * aws_route_table.private
  * aws_route_table.public
  * aws_route_table_association.to_private_subnet_1
  * aws_route_table_association.to_private_subnet_2
  * aws_route_table_association.to_public_subnet_1
  * aws_route_table_association.to_public_subnet_1