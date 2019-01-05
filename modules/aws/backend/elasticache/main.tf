resource "aws_elasticache_replication_group" "redis" {
  replication_group_id          = "${lookup(var.elasticache, "${terraform.env}.replication_group_id", var.elasticache["default.replication_group_id"])}"
  replication_group_description = "redis replication of ${lookup(var.elasticache, "${terraform.env}.replication_group_id", var.elasticache["default.replication_group_id"])}"
  node_type                     = "${lookup(var.elasticache, "${terraform.env}.node_type", var.elasticache["default.node_type"])}"
  number_cache_clusters         = 3
  port                          = 6379
  parameter_group_name          = "${lookup(var.elasticache, "${terraform.env}.parameter_group_name", var.elasticache["default.parameter_group_name"])}"

  availability_zones = [
    "${var.region}a",
    "${var.region}b",
    "${var.region}c",
  ]

  automatic_failover_enabled = true
}
