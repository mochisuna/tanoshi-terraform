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
