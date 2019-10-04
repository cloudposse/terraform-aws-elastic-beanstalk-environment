provider "aws" {
  region = var.region
}

module "elastic_beanstalk_application" {
  source      = "../../"
  namespace   = var.namespace
  stage       = var.stage
  name        = var.name
  description = var.description
  delimiter   = var.delimiter
  attributes  = var.attributes
  tags        = var.tags
}
