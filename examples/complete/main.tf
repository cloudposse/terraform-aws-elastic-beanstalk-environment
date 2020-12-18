provider "aws" {
  region = var.region
}

module "elastic_beanstalk_application" {
  source      = "../../"
  description = var.description

  context = module.this.context
}
