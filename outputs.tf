output "host" {
  value       = "${module.tld.hostname}"
  description = "DNS hostname"
}

output "id" {
  description = "ID of the Elastic Beanstalk environment."
  value       = "${aws_elastic_beanstalk_environment.default.id}"
}

output "name" {
  value       = "${aws_elastic_beanstalk_environment.default.name}"
  description = "Name"
}

output "security_group_id" {
  value       = "${aws_security_group.default.id}"
  description = "Security group id"
}

output "elb_dns_name" {
  value       = "${aws_elastic_beanstalk_environment.default.cname}"
  description = "ELB technical host"
}

output "elb_zone_id" {
  value       = "${var.alb_zone_id[data.aws_region.default.name]}"
  description = "ELB zone id"
}

output "ec2_instance_profile_role_name" {
  value       = "${aws_iam_role.ec2.name}"
  description = "Instance IAM role name"
}

output "tier" {
  description = "The environment tier specified."
  value       = "${aws_elastic_beanstalk_environment.default.tier}"
}

output "application" {
  description = "The Elastic Beanstalk Application specified for this environment."
  value       = "${aws_elastic_beanstalk_environment.default.application}"
}

output "setting" {
  description = "Settings specifically set for this environment."
  value       = "${aws_elastic_beanstalk_environment.default.setting}"
}

output "all_settings" {
  description = "List of all option settings configured in the environment. These are a combination of default settings and their overrides from setting in the configuration."
  value       = "${aws_elastic_beanstalk_environment.default.all_settings}"
}

output "cname" {
  description = "Fully qualified DNS name for the environment."
  value       = "${aws_elastic_beanstalk_environment.default.cname}"
}

output "autoscaling_groups" {
  description = "The autoscaling groups used by this environment."
  value       = "${aws_elastic_beanstalk_environment.default.autoscaling_groups}"
}

output "instances" {
  description = "Instances used by this environment."
  value       = "${aws_elastic_beanstalk_environment.default.instances}"
}

output "launch_configurations" {
  description = "Launch configurations in use by this environment."
  value       = "${aws_elastic_beanstalk_environment.default.launch_configurations}"
}

output "load_balancers" {
  description = "Elastic Load Balancers in use by this environment."
  value       = "${aws_elastic_beanstalk_environment.default.load_balancers}"
}

output "queues" {
  description = "SQS queues in use by this environment."
  value       = "${aws_elastic_beanstalk_environment.default.queues}"
}

output "triggers" {
  description = "Autoscaling triggers in use by this environment."
  value       = "${aws_elastic_beanstalk_environment.default.triggers}"
}

output "elb_load_balancers" {
  description = "Elastic Load Balancers in use by this environment."
  value       = "${aws_elastic_beanstalk_environment.default.load_balancers}"
}
