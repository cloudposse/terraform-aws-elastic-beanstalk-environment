module "aws_security_group" {
  source  = "cloudposse/security-group/aws"
  version = "1.0.1"

  enabled = local.enabled && var.create_security_group

  security_group_name        = length(var.security_group_name) > 0 ? var.security_group_name : [module.this.id]
  security_group_description = var.security_group_description

  allow_all_egress = var.allow_all_egress

  rules = var.additional_security_group_rules

  vpc_id = var.vpc_id

  create_before_destroy         = var.security_group_create_before_destroy
  security_group_create_timeout = var.security_group_create_timeout
  security_group_delete_timeout = var.security_group_delete_timeout

  context = module.this.context
}
