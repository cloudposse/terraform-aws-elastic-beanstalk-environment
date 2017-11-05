-include $(shell curl -sSL -o .build-harness "https://git.io/build-harness"; echo .build-harness)

NAME ?= terraform-aws-elastic-beanstalk-environment
DESCRIPTION ?= Terraform module to provision AWS Elastic Beanstalk environment