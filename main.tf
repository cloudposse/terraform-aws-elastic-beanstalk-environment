module "label" {
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.15.0"
  namespace  = var.namespace
  name       = var.name
  stage      = var.stage
  delimiter  = var.delimiter
  attributes = var.attributes
  tags       = var.tags
}

locals {
  // Remove `Name` tag from the map of tags because Elastic Beanstalk generates the `Name` tag automatically
  // and if it is provided, terraform tries to recreate the application on each `plan/apply`
  // `Namespace` should be removed as well since any string that contains `Name` forces recreation
  // https://github.com/terraform-providers/terraform-provider-aws/issues/3963
  tags = { for t in keys(module.label.tags) : t => module.label.tags[t] if t != "Name" && t != "Namespace" }
}

resource "aws_elastic_beanstalk_application" "default" {
  name        = module.label.id
  description = var.description
  tags        = local.tags

  dynamic "appversion_lifecycle" {
    for_each = var.appversion_lifecycle_service_role_arn != "" ? ["true"] : []
    content {
      service_role          = var.appversion_lifecycle_service_role_arn
      max_count             = var.appversion_lifecycle_max_count
      delete_source_from_s3 = var.appversion_lifecycle_delete_source_from_s3
    }
  }
}
