resource "aws_db_subnet_group" "rds_subnet" {
  name        = "${lookup(var.rds, "${terraform.env}.name", var.rds["default.name"])}-subnet"
  description = "${lookup(var.rds, "${terraform.env}.name", var.rds["default.name"])} subnet group"

  subnet_ids = [
    "${lookup(var.vpc, "private_subnet_a_id")}",
    "${lookup(var.vpc, "private_subnet_b_id")}",
    "${lookup(var.vpc, "private_subnet_c_id")}",
  ]
}

resource "aws_db_parameter_group" "db_parameter_group" {
  name   = "${lookup(var.rds, "${terraform.env}.name", var.rds["default.name"])}-parameter-group"
  family = "${lookup(var.rds, "family")}"

  description = "${lookup(var.rds, "${terraform.env}.name", var.rds["default.name"])} parameter group"

  parameter {
    name  = "long_query_time"
    value = "2"
  }

  parameter {
    name  = "log_output"
    value = "FILE"
  }

  parameter {
    name  = "slow_query_log"
    value = "1"
  }
}

resource "aws_rds_cluster_parameter_group" "database_cluster_parameter_group" {
  name        = "${lookup(var.rds, "${terraform.env}.name", var.rds["default.name"])}-cluster-parameter-group"
  family      = "${lookup(var.rds, "family")}"
  description = "${lookup(var.rds, "${terraform.env}.name", var.rds["default.name"])} cluster parameter group"

  parameter {
    name  = "character_set_client"
    value = "${lookup(var.rds, "character_set")}"
  }

  parameter {
    name  = "character_set_connection"
    value = "${lookup(var.rds, "character_set")}"
  }

  parameter {
    name  = "character_set_database"
    value = "${lookup(var.rds, "character_set")}"
  }

  parameter {
    name  = "character_set_filesystem"
    value = "${lookup(var.rds, "character_set")}"
  }

  parameter {
    name  = "character_set_results"
    value = "${lookup(var.rds, "character_set")}"
  }

  parameter {
    name  = "character_set_server"
    value = "${lookup(var.rds, "character_set")}"
  }

  parameter {
    name  = "collation_connection"
    value = "${lookup(var.rds, "character_set")}_bin"
  }

  parameter {
    name  = "collation_server"
    value = "${lookup(var.rds, "character_set")}_bin"
  }

  parameter {
    name         = "character-set-client-handshake"
    value        = "1"
    apply_method = "${lookup(var.rds, "apply_method")}"
  }

  parameter {
    name  = "time_zone"
    value = "${lookup(var.rds, "time_zone")}"
  }
}

resource "aws_security_group" "rds_access" {
  name        = "${lookup(var.rds, "${terraform.env}.name", var.rds["default.name"])}-access"
  description = "security group of ${lookup(var.rds, "${terraform.env}.name", var.rds["default.name"])}"
  vpc_id      = "${lookup(var.vpc, "id")}"

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = ["${lookup(var.vpc, "default_sg_id")}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "${lookup(var.rds, "${terraform.env}.name", var.rds["default.name"])} security group"
    Env  = "${terraform.env}"
  }
}

resource "aws_rds_cluster" "rds_cluster" {
  cluster_identifier              = "${lookup(var.rds, "${terraform.env}.name", var.rds["default.name"])}-cluster"
  engine                          = "${lookup(var.rds, "engine")}"
  engine_version                  = "${lookup(var.rds, "engine_version")}"
  master_username                 = "${lookup(var.rds, "${terraform.env}.master_username", var.rds["default.master_username"])}"
  master_password                 = "${lookup(var.rds, "${terraform.env}.master_password", var.rds["default.master_password"])}"
  backup_retention_period         = 5
  preferred_backup_window         = "19:30-20:00"
  preferred_maintenance_window    = "wed:03:15-wed:03:45"
  port                            = 3306
  db_subnet_group_name            = "${aws_db_subnet_group.rds_subnet.name}"
  storage_encrypted               = false
  db_cluster_parameter_group_name = "${aws_rds_cluster_parameter_group.database_cluster_parameter_group.name}"
  skip_final_snapshot             = true

  vpc_security_group_ids = [
    "${lookup(var.vpc, "default_sg_id")}",
    "${aws_security_group.rds_access.id}",
  ]

  lifecycle {
    ignore_changes = ["master_password"]
  }
}

resource "aws_rds_cluster_instance" "rds_cluster_instance" {
  count                   = "${lookup(var.rds, "${terraform.env}.instance_count", var.rds["default.instance_count"])}"
  engine                  = "${lookup(var.rds, "engine")}"
  engine_version          = "${lookup(var.rds, "engine_version")}"
  identifier              = "${terraform.workspace}-${lookup(var.rds, "${terraform.env}.name", var.rds["default.name"])}-${count.index}"
  cluster_identifier      = "${aws_rds_cluster.rds_cluster.id}"
  instance_class          = "${lookup(var.rds, "${terraform.env}.instance_class", var.rds["default.instance_class"])}"
  db_subnet_group_name    = "${aws_db_subnet_group.rds_subnet.name}"
  db_parameter_group_name = "${aws_db_parameter_group.db_parameter_group.name}"
  monitoring_role_arn     = "${lookup(var.iam, "monitoring_rds_role_arn")}"
  monitoring_interval     = 60

  tags {
    Name = "${lookup(var.rds, "${terraform.env}.name", var.rds["default.name"])} rds cluster instance"
    Env  = "${terraform.env}"
  }
}
