module "vpc" {
  source = "./modules/vpc"
  region = "${var.region}"
}

module "ec2" {
  source        = "./modules/ec2"
  key_pair_name = "tf-sample"
  sg_name       = "tf-sample-sg"
  vpc           = "${module.vpc.outputs}"
}

module "alb" {
  source                    = "./modules/alb"
  vpc_id                    = "${lookup(module.vpc.outputs, "id")}"
  default_security_group_id = "${lookup(module.vpc.outputs, "default_sg_id")}"

  subnets = [
    "${lookup(module.vpc.outputs, "public_subnet_a_id")}",
    "${lookup(module.vpc.outputs, "public_subnet_c_id")}",
  ]
}
