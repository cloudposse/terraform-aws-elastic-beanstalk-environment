output "host" {
  value = "${module.tld.hostname}"
  desription = "DNS hostname"
}

output "name" {
  value = "${aws_elastic_beanstalk_environment.default.name}"
  desription = "Name"
}

output "security_group_id" {
  value = "${aws_security_group.default.id}"
  desription = "Security group id"
}

output "elb_dns_name" {
  value = "${aws_elastic_beanstalk_environment.default.cname}"
  desription = "ELB technical host"
}

output "elb_zone_id" {
  value = "${var.alb_zone_id[data.aws_region.default.name]}"
  desription = "ELB zone id"
}

output "ec2_instance_profile_role_name" {
  value = "${aws_iam_role.ec2.name}"
  desription = "Instance IAM role name"
}
