provider "aws" {
  region = var.region
}

module "vpc" {
  source     = "cloudposse/vpc/aws"
  version    = "0.18.1"
  cidr_block = "172.16.0.0/16"

  context = module.this.context
}

module "subnets" {
  source               = "cloudposse/dynamic-subnets/aws"
  version              = "0.33.0"
  availability_zones   = var.availability_zones
  vpc_id               = module.vpc.vpc_id
  igw_id               = module.vpc.igw_id
  cidr_block           = module.vpc.vpc_cidr_block
  nat_gateway_enabled  = true
  nat_instance_enabled = false

  context = module.this.context
}

module "elastic_beanstalk_application" {
  source      = "cloudposse/elastic-beanstalk-application/aws"
  version     = "0.8.0"
  description = "Test elastic_beanstalk_application"

  context = module.this.context
}

module "elastic_beanstalk_environment" {
  source                     = "../../"
  description                = var.description
  region                     = var.region
  availability_zone_selector = var.availability_zone_selector
  dns_zone_id                = var.dns_zone_id

  wait_for_ready_timeout             = var.wait_for_ready_timeout
  elastic_beanstalk_application_name = module.elastic_beanstalk_application.elastic_beanstalk_application_name
  environment_type                   = var.environment_type
  loadbalancer_type                  = var.loadbalancer_type
  elb_scheme                         = var.elb_scheme
  tier                               = var.tier
  version_label                      = var.version_label
  force_destroy                      = var.force_destroy

  instance_type    = var.instance_type
  root_volume_size = var.root_volume_size
  root_volume_type = var.root_volume_type

  autoscale_min             = var.autoscale_min
  autoscale_max             = var.autoscale_max
  autoscale_measure_name    = var.autoscale_measure_name
  autoscale_statistic       = var.autoscale_statistic
  autoscale_unit            = var.autoscale_unit
  autoscale_lower_bound     = var.autoscale_lower_bound
  autoscale_lower_increment = var.autoscale_lower_increment
  autoscale_upper_bound     = var.autoscale_upper_bound
  autoscale_upper_increment = var.autoscale_upper_increment

  vpc_id               = module.vpc.vpc_id
  loadbalancer_subnets = module.subnets.public_subnet_ids
  application_subnets  = module.subnets.private_subnet_ids
  security_group_rules = [
    {
      type                     = "egress"
      from_port                = 0
      to_port                  = 65535
      protocol                 = "-1"
      cidr_blocks              = ["0.0.0.0/0"]
      source_security_group_id = null
      description              = "Allow all outbound traffic"
    },
    {
      type                     = "ingress"
      from_port                = 0
      to_port                  = 65535
      protocol                 = "-1"
      cidr_blocks              = []
      source_security_group_id = module.vpc.vpc_default_security_group_id
      description              = "Allow all inbound traffic from trusted Security Groups"
    },
  ]

  rolling_update_enabled  = var.rolling_update_enabled
  rolling_update_type     = var.rolling_update_type
  updating_min_in_service = var.updating_min_in_service
  updating_max_batch      = var.updating_max_batch

  application_port = var.application_port

  # https://docs.aws.amazon.com/elasticbeanstalk/latest/platforms/platforms-supported.html
  # https://docs.aws.amazon.com/elasticbeanstalk/latest/platforms/platforms-supported.html#platforms-supported.docker
  solution_stack_name = var.solution_stack_name

  additional_settings = var.additional_settings
  env_vars            = var.env_vars

  extended_ec2_policy_document = data.aws_iam_policy_document.minimal_s3_permissions.json
  prefer_legacy_ssm_policy     = false
  prefer_legacy_service_policy = false
  scheduled_actions            = var.scheduled_actions
  context                      = module.this.context
  instance_role_name           = aws_iam_instance_profile.ec2.name
}

data "aws_iam_policy_document" "minimal_s3_permissions" {
  statement {
    sid = "AllowS3OperationsOnElasticBeanstalkBuckets"
    actions = [
      "s3:ListAllMyBuckets",
      "s3:GetBucketLocation"
    ]
    resources = ["*"]
  }
}


data "aws_iam_policy_document" "ec2" {
  statement {
    sid = ""

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    effect = "Allow"
  }
}

resource "aws_iam_role" "ec2" {
  name               = "${module.this.id}-eb-ec2"
  assume_role_policy = data.aws_iam_policy_document.ec2.json
  managed_policy_arns = [
    aws_iam_policy.minimal_s3_permissions.arn,
    "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier",
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
    "arn:aws:iam::aws:policy/AWSElasticBeanstalkMulticontainerDocker",
    "arn:aws:iam::aws:policy/service-role/AmazonSSMAutomationRole",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  ]
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_instance_profile" "ec2" {
  name = aws_iam_role.ec2.name
  role = aws_iam_role.ec2.name
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_policy" "minimal_s3_permissions" {
  name   = "${module.this.id}-eb-s3"
  policy = data.aws_iam_policy_document.ec2.json
}
