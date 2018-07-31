output "app_name" {
  value       = "${aws_elastic_beanstalk_application.default.name}"
  description = "Application name"
}
