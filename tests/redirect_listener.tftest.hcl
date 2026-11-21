mock_provider "aws" {
  mock_data "aws_iam_policy_document" {
    defaults = { json = "{\"Version\":\"2012-10-17\",\"Statement\":[]}" }
  }
  mock_data "aws_partition" {
    defaults = { partition = "aws", dns_suffix = "amazonaws.com" }
  }
  mock_resource "aws_iam_role" {
    defaults = { arn = "arn:aws:iam::111111111111:role/test" }
  }
  mock_resource "aws_iam_instance_profile" {
    defaults = { arn = "arn:aws:iam::111111111111:instance-profile/test" }
  }
  mock_resource "aws_security_group" {
    defaults = { arn = "arn:aws:ec2:us-east-2:111111111111:security-group/sg-12345678", id = "sg-12345678" }
  }
  mock_resource "aws_elastic_beanstalk_environment" {
    defaults = { load_balancers = ["arn:aws:elasticloadbalancing:us-east-2:111111111111:loadbalancer/app/awseb-test/abc"] }
  }
  override_data {
    target = data.aws_lb_listener.http[0]
    values = { arn = "arn:aws:elasticloadbalancing:us-east-2:111111111111:listener/app/awseb-test/abc/def" }
  }
}
mock_provider "random" {}

variables {
  enabled                             = true
  namespace                           = "eg"
  name                                = "test"
  region                              = "us-east-2"
  elastic_beanstalk_application_name  = "app"
  vpc_id                              = "vpc-12345678"
  application_subnets                 = ["subnet-12345678"]
  solution_stack_name                 = "64bit Amazon Linux 2023 v4.3.0 running Docker"
  loadbalancer_redirect_http_to_https = true
  loadbalancer_type                   = "application"
  env_vars                            = { FOO = "1" }
}

run "create" {
  command = apply
}

run "update_env_var_keeps_listener_known" {
  command = plan
  variables {
    env_vars = { FOO = "2" }
  }
  assert {
    condition     = aws_lb_listener_rule.redirect_http_to_https[0].listener_arn == "arn:aws:elasticloadbalancing:us-east-2:111111111111:listener/app/awseb-test/abc/def"
    error_message = "listener_arn must stay known at plan time so the redirect rule is not replaced"
  }
}

run "disabled_plans_cleanly" {
  command = plan
  variables {
    enabled = false
  }
}
