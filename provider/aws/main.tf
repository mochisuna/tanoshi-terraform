module "acm" {
  source           = "../../modules/aws/acm"
  main_domain_name = "${var.main_domain_name}"
}

module "vpc" {
  source           = "../../modules/aws/vpc"
  region           = "${var.region}"
  vpc              = "${var.vpc}"
  vpc_cider_blocks = "${var.vpc_cider_blocks}"
}

module "bastion" {
  source   = "../../modules/aws/compute/bastion"
  vpc      = "${module.vpc.outputs}"
  bastion  = "${var.bastion}"
  key_pair = "${module.key_pair.outputs}"
}

module "key_pair" {
  source   = "../../modules/aws/compute/key_pair"
  key_pair = "${var.key_pair}"
}

module "iam" {
  source = "../../modules/aws/iam"
}

module "app" {
  source = "../../modules/aws/compute/app"
  vpc    = "${module.vpc.outputs}"

  app     = "${var.app}"
  app_alb = "${var.app_alb}"

  iam = "${module.iam.outputs}"

  acm      = "${module.acm.outputs}"
  key_pair = "${module.key_pair.outputs}"
}

module "rds" {
  source = "../../modules/aws/backend/rds"
  vpc    = "${module.vpc.outputs}"
  rds    = "${var.rds}"
  iam    = "${module.iam.outputs}"
}

module "route53" {
  source  = "../../modules/aws/route53"
  vpc     = "${module.vpc.outputs}"
  rds     = "${module.rds.outputs}"
  route53 = "${var.route53}"
}

module "elasticache" {
  source      = "../../modules/aws/backend/elasticache"
  region      = "${var.region}"
  elasticache = "${var.elasticache}"
}

module "static_page" {
  source           = "../../modules/aws/static_page"
  acm              = "${module.acm.outputs}"
  static_page      = "${var.static_page}"
  main_domain_name = "${var.main_domain_name}"
  app              = "${module.app.outputs}"
}
