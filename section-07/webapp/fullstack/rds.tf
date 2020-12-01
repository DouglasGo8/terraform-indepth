resource "aws_db_instance" "rds_prod" {
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
  vpc_security_group_ids  = ["${aws_security_group.sg-rds-prod.id}"]
  db_subnet_group_name    = aws_db_subnet_group.rds-subnet-group.name
}

resource "aws_db_subnet_group" "rds-subnet-group" {
  name        = "${var.PROJECT_NAME}_aurora_db_subnet_group"
  description = "Allowed subnets for Aurora DB cluster instances"
  subnet_ids = [
    "${aws_subnet.private_subnet_1.id}",
    "${aws_subnet.private_subnet_2.id}",
  ]

  tags = {
    Name      = "${var.PROJECT_NAME}-rds-Subnet-Group"
    ManagedBy = "Dougbdb"
  }

}

resource "aws_security_group" "sg-rds-prod" {
  name        = "${var.PROJECT_NAME}-rds-production"
  description = "Created by Dougdb"
  vpc_id      = aws_vpc.main.id
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["${var.RDS_CIDR}"]

  }

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = ["${aws_security_group.sg-appservers.id}"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.PROJECT_NAME}-rds-production"
  }
}
