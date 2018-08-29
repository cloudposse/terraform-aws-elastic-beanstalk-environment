provider "aws" {
  region = "us-east-1"
}

variable "max_availability_zones" {
  default = "2"
}

variable "zone_id" {
  type        = "string"
  description = "Route53 Zone ID"
}

data "aws_availability_zones" "available" {}

module "vpc" {
  source     = "git::https://github.com/cloudposse/terraform-aws-vpc.git?ref=master"
  namespace  = "eg"
  stage      = "dev"
  name       = "test"
  cidr_block = "10.0.0.0/16"
}

module "subnets" {
  source              = "git::https://github.com/cloudposse/terraform-aws-dynamic-subnets.git?ref=master"
  availability_zones  = ["${slice(data.aws_availability_zones.available.names, 0, var.max_availability_zones)}"]
  namespace           = "eg"
  stage               = "dev"
  name                = "test"
  region              = "us-east-1"
  vpc_id              = "${module.vpc.vpc_id}"
  igw_id              = "${module.vpc.igw_id}"
  cidr_block          = "${module.vpc.vpc_cidr_block}"
  nat_gateway_enabled = "true"
}

module "elastic_beanstalk_application" {
  source      = "git::https://github.com/cloudposse/terraform-aws-elastic-beanstalk-application.git?ref=master"
  namespace   = "eg"
  stage       = "dev"
  name        = "test"
  description = "Test elastic_beanstalk_application"
}

module "elastic_beanstalk_environment" {
  source    = "git::https://github.com/cloudposse/terraform-aws-elastic-beanstalk-environment.git?ref=master"
  namespace = "eg"
  stage     = "dev"
  name      = "test"
  zone_id   = "${var.zone_id}"
  app       = "${module.elastic_beanstalk_application.app_name}"

  instance_type           = "t2.small"
  autoscale_min           = 1
  autoscale_max           = 2
  updating_min_in_service = 0
  updating_max_batch      = 1

  loadbalancer_type   = "application"
  vpc_id              = "${module.vpc.vpc_id}"
  public_subnets      = "${module.subnets.public_subnet_ids}"
  private_subnets     = "${module.subnets.private_subnet_ids}"
  security_groups     = ["${module.vpc.vpc_default_security_group_id}"]
  solution_stack_name = "64bit Amazon Linux 2018.03 v2.12.2 running Docker 18.03.1-ce"
  keypair             = ""

  env_vars = "${
      map(
        "ENV1", "Test1",
        "ENV2", "Test2",
        "ENV3", "Test3"
      )
    }"
}
