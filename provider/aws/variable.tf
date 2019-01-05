variable "region" {
  default = "us-east-1"
}

variable vpc {
  type = "map"

  default = {
    name = "tano-tf"
  }
}

variable "vpc_cider_blocks" {
  type = "map"

  default = {
    default.cidr             = "10.0.0.0/16"
    default.public_subnet_a  = "10.0.0.0/22"
    default.public_subnet_b  = "10.0.4.0/22"
    default.public_subnet_c  = "10.0.8.0/22"
    default.private_subnet_a = "10.0.12.0/22"
    default.private_subnet_b = "10.0.16.0/22"
    default.private_subnet_c = "10.0.20.0/22"

    stg.cidr             = "10.1.0.0/16"
    stg.public_subnet_a  = "10.1.0.0/22"
    stg.public_subnet_b  = "10.1.4.0/22"
    stg.public_subnet_c  = "10.1.8.0/22"
    stg.private_subnet_a = "10.1.12.0/22"
    stg.private_subnet_b = "10.1.16.0/22"
    stg.private_subnet_c = "10.1.20.0/22"

    dev.cidr             = "10.2.0.0/16"
    dev.public_subnet_a  = "10.2.0.0/22"
    dev.public_subnet_b  = "10.2.4.0/22"
    dev.public_subnet_c  = "10.2.8.0/22"
    dev.private_subnet_a = "10.2.12.0/22"
    dev.private_subnet_b = "10.2.16.0/22"
    dev.private_subnet_c = "10.2.20.0/22"
  }
}

variable "bastion" {
  type = "map"

  default = {
    sg_name       = "bastion-sg"
    instance_type = "t2.micro"
    ami           = "ami-14c5486b"
    volume_type   = "gp2"
    volume_size   = "30"
  }
}

variable "key_pair" {
  type = "map"

  default = {
    default.key_pair_name = "aws-ssh-key"
    stg.key_pair_name     = "stg-aws-ssh-key"
    dev.key_pair_name     = "dev-aws-ssh-key"
  }
}

variable "app" {
  type = "map"

  default = {
    default.name          = "app"
    default.instance_type = "t2.micro"
    default.ami           = "ami-14c5486b"
    default.volume_type   = "gp2"
    default.volume_size   = "30"

    stg.name          = "stg-app"
    stg.instance_type = "t2.micro"
    stg.ami           = "ami-14c5486b"
    stg.volume_type   = "gp2"
    stg.volume_size   = "30"

    dev.name          = "dev-app"
    dev.instance_type = "t2.micro"
    dev.ami           = "ami-14c5486b"
    dev.volume_type   = "gp2"
    dev.volume_size   = "30"
  }
}

variable "app_alb" {
  type = "map"

  default = {
    health_check_path = "/healthcheck"
    ssl_policy        = "ELBSecurityPolicy-2016-08"
  }
}

variable "rds" {
  type = "map"

  default = {
    default.name            = "app-db"
    default.master_username = "root"
    default.master_password = "pass1234"
    default.instance_count  = 1
    default.instance_class  = "db.t2.small"

    stg.name            = "stg-app-db"
    stg.master_username = "root"
    stg.master_password = "pass1234"
    stg.instance_count  = 2
    stg.instance_class  = "db.t2.small"

    dev.name            = "dev-app-db"
    dev.master_username = "root"
    dev.master_password = "pass1234"
    dev.instance_count  = 1
    dev.instance_class  = "db.t2.small"

    family         = "aurora-mysql5.7"
    engine         = "aurora-mysql"
    engine_version = "5.7.12"
    character_set  = "utf8mb4"
    apply_method   = "pending-reboot"
    time_zone      = "Asia/Tokyo"
  }
}

variable "route53" {
  type = "map"

  default = {
    default.rds_local_domain_name        = "tanoshi-tf"
    default.rds_local_master_domain_name = "tanoshi-tf-db-master"
    default.rds_local_slave_domain_name  = "tanoshi-tf-db-slave"

    stg.rds_local_domain_name        = "stg-tanoshi-tf"
    stg.rds_local_master_domain_name = "stg-tanoshi-tf-db-master"
    stg.rds_local_slave_domain_name  = "stg-tanoshi-tf-db-slave"

    dev.rds_local_domain_name        = "dev-tanoshi-tf"
    dev.rds_local_master_domain_name = "dev-tanoshi-tf-db-master"
    dev.rds_local_slave_domain_name  = "dev-tanoshi-tf-db-slave"
  }
}

variable "main_domain_name" {
  type = "string"

  default = ""
}

variable "elasticache" {
  type = "map"

  default = {
    default.replication_group_id = "replication-group"
    default.node_type            = "cache.m1.small"
    default.parameter_group_name = "default.redis5.0"

    stg.replication_group_id = "replication-group"
    stg.node_type            = "cache.m1.small"
    stg.parameter_group_name = "default.redis5.0"

    dev.replication_group_id = "replication-group"
    dev.node_type            = "cache.m1.small"
    dev.parameter_group_name = "default.redis5.0"
  }
}
