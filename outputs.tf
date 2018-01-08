output "host" {
  value       = "${module.tld.hostname}"
  description = "DNS hostname"
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
