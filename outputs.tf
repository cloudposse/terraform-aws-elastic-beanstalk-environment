output "host" {
  value = "${module.tld.hostname}"
}

output "name" {
  value = "${aws_elastic_beanstalk_environment.default.name}"
}

output "security_group_id" {
  value = "${aws_security_group.default.id}"
}

output "elb_dns_name" {
  value = "${aws_elastic_beanstalk_environment.default.cname}"
}

output "elb_zone_id" {
  value = "${var.alb_zone_id[data.aws_region.default.name]}"
}

output "ec2_instance_profile_role_name" {
  value = "${aws_iam_role.ec2.name}"
}
