
terraform {
  required_version = "~> 0.13.0"
}

resource "aws_db_instance" "prod" {
  identifier              = "${var.PROJECT_NAME}-prod-rds"
  allocated_storage       = var.RDS_ALLOCATED_STORAGE
  storage_type            = "gp2"
  engine                  = var.RDS_ENGINE
  engine_version          = var.ENGINE_VERSION
  instance_class          = var.DB_INSTANCE_CLASS
  backup_retention_period = var.BACKUP_RETENTION_PERIOD
  publicly_accessible     = var.PUBLICLY_ACCESSIBLE
  username                = var.RDS_USERNAME
  password                = var.RDS_PASSWORD
  vpc_security_group_ids  = ["${aws_security_group.rds-prod.id}"]
  db_subnet_group_name    = aws_db_subnet_group.rds_subnet_group.name
  multi_az                = "true"
}

resource "aws_db_subnet_group" "rds_subnet_group" {
  name        = "${var.PROJECT_NAME}_aurora_db_subnet_group"
  description = "Allowed subnets for Aurora DB cluster instances"
  subnet_ids  = ["subnet-0576886ecb8794f13", "subnet-0a7dbe1b36d85594f"]
  tags = {
    "Name" = "${var.PROJECT_NAME}-rds-Subnet-Group"
  }
}

resource "aws_security_group" "rds-prod" {
  name   = "${var.PROJECT_NAME}-rds-production"
  vpc_id = "vpc-00a4d7bdae8259c6e"
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["${var.RDS_CIDR}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }


}
