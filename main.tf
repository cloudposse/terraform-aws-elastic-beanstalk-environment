# Define composite variables for resources
module "label" {
  source     = "git::https://github.com/cloudposse/terraform-terraform-label.git?ref=tags/0.1.6"
  namespace  = "${var.namespace}"
  name       = "${var.name}"
  stage      = "${var.stage}"
  delimiter  = "${var.delimiter}"
  attributes = "${var.attributes}"
  tags       = "${var.tags}"
}

data "aws_region" "default" {}

#
# Service
#
data "aws_iam_policy_document" "service" {
  statement {
    sid = ""

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["elasticbeanstalk.amazonaws.com"]
    }

    effect = "Allow"
  }
}

resource "aws_iam_role" "service" {
  name               = "${module.label.id}-service"
  assume_role_policy = "${data.aws_iam_policy_document.service.json}"
}

resource "aws_iam_role_policy_attachment" "enhanced-health" {
  count      = "${var.enhanced_reporting_enabled ? 1 : 0}"
  role       = "${aws_iam_role.service.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSElasticBeanstalkEnhancedHealth"
}

resource "aws_iam_role_policy_attachment" "service" {
  role       = "${aws_iam_role.service.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSElasticBeanstalkService"
}

#
# EC2
#
data "aws_iam_policy_document" "ec2" {
  statement {
    sid = ""

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    effect = "Allow"
  }

  statement {
    sid = ""

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["ssm.amazonaws.com"]
    }

    effect = "Allow"
  }
}

resource "aws_iam_role" "ec2" {
  name               = "${module.label.id}-ec2"
  assume_role_policy = "${data.aws_iam_policy_document.ec2.json}"
}

resource "aws_iam_role_policy" "default" {
  name   = "${module.label.id}-default"
  role   = "${aws_iam_role.ec2.id}"
  policy = "${data.aws_iam_policy_document.default.json}"
}

resource "aws_iam_role_policy_attachment" "web-tier" {
  role       = "${aws_iam_role.ec2.name}"
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier"
}

resource "aws_iam_role_policy_attachment" "worker-tier" {
  role       = "${aws_iam_role.ec2.name}"
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWorkerTier"
}

resource "aws_iam_role_policy_attachment" "ssm-ec2" {
  role       = "${aws_iam_role.ec2.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_role_policy_attachment" "ssm-automation" {
  role       = "${aws_iam_role.ec2.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonSSMAutomationRole"

  lifecycle {
    create_before_destroy = true
  }
}

# http://docs.aws.amazon.com/elasticbeanstalk/latest/dg/create_deploy_docker.container.console.html
# http://docs.aws.amazon.com/AmazonECR/latest/userguide/ecr_managed_policies.html#AmazonEC2ContainerRegistryReadOnly
resource "aws_iam_role_policy_attachment" "ecr-readonly" {
  role       = "${aws_iam_role.ec2.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_ssm_activation" "ec2" {
  name               = "${module.label.id}"
  iam_role           = "${aws_iam_role.ec2.id}"
  registration_limit = "${var.autoscale_max}"
}

data "aws_iam_policy_document" "default" {
  statement {
    sid = ""

    actions = [
      "elasticloadbalancing:DescribeInstanceHealth",
      "elasticloadbalancing:DescribeLoadBalancers",
      "elasticloadbalancing:DescribeTargetHealth",
      "ec2:DescribeInstances",
      "ec2:DescribeInstanceStatus",
      "ec2:GetConsoleOutput",
      "ec2:AssociateAddress",
      "ec2:DescribeAddresses",
      "ec2:DescribeSecurityGroups",
      "sqs:GetQueueAttributes",
      "sqs:GetQueueUrl",
      "autoscaling:DescribeAutoScalingGroups",
      "autoscaling:DescribeAutoScalingInstances",
      "autoscaling:DescribeScalingActivities",
      "autoscaling:DescribeNotificationConfigurations",
    ]

    resources = ["*"]

    effect = "Allow"
  }

  statement {
    sid = "AllowOperations"

    actions = [
      "autoscaling:AttachInstances",
      "autoscaling:CreateAutoScalingGroup",
      "autoscaling:CreateLaunchConfiguration",
      "autoscaling:DeleteLaunchConfiguration",
      "autoscaling:DeleteAutoScalingGroup",
      "autoscaling:DeleteScheduledAction",
      "autoscaling:DescribeAccountLimits",
      "autoscaling:DescribeAutoScalingGroups",
      "autoscaling:DescribeAutoScalingInstances",
      "autoscaling:DescribeLaunchConfigurations",
      "autoscaling:DescribeLoadBalancers",
      "autoscaling:DescribeNotificationConfigurations",
      "autoscaling:DescribeScalingActivities",
      "autoscaling:DescribeScheduledActions",
      "autoscaling:DetachInstances",
      "autoscaling:PutScheduledUpdateGroupAction",
      "autoscaling:ResumeProcesses",
      "autoscaling:SetDesiredCapacity",
      "autoscaling:SuspendProcesses",
      "autoscaling:TerminateInstanceInAutoScalingGroup",
      "autoscaling:UpdateAutoScalingGroup",
      "cloudwatch:PutMetricAlarm",
      "ec2:AssociateAddress",
      "ec2:AllocateAddress",
      "ec2:AuthorizeSecurityGroupEgress",
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:CreateSecurityGroup",
      "ec2:DeleteSecurityGroup",
      "ec2:DescribeAccountAttributes",
      "ec2:DescribeAddresses",
      "ec2:DescribeImages",
      "ec2:DescribeInstances",
      "ec2:DescribeKeyPairs",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeSnapshots",
      "ec2:DescribeSubnets",
      "ec2:DescribeVpcs",
      "ec2:DisassociateAddress",
      "ec2:ReleaseAddress",
      "ec2:RevokeSecurityGroupEgress",
      "ec2:RevokeSecurityGroupIngress",
      "ec2:TerminateInstances",
      "ecs:CreateCluster",
      "ecs:DeleteCluster",
      "ecs:DescribeClusters",
      "ecs:RegisterTaskDefinition",
      "elasticbeanstalk:*",
      "elasticloadbalancing:ApplySecurityGroupsToLoadBalancer",
      "elasticloadbalancing:ConfigureHealthCheck",
      "elasticloadbalancing:CreateLoadBalancer",
      "elasticloadbalancing:DeleteLoadBalancer",
      "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
      "elasticloadbalancing:DescribeInstanceHealth",
      "elasticloadbalancing:DescribeLoadBalancers",
      "elasticloadbalancing:DescribeTargetHealth",
      "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
      "elasticloadbalancing:DescribeTargetGroups",
      "elasticloadbalancing:RegisterTargets",
      "elasticloadbalancing:DeregisterTargets",
      "iam:ListRoles",
      "iam:PassRole",
      "logs:CreateLogGroup",
      "logs:PutRetentionPolicy",
      "rds:DescribeDBEngineVersions",
      "rds:DescribeDBInstances",
      "rds:DescribeOrderableDBInstanceOptions",
      "s3:GetObject",
      "s3:GetObjectAcl",
      "s3:ListBucket",
      "sns:CreateTopic",
      "sns:GetTopicAttributes",
      "sns:ListSubscriptionsByTopic",
      "sns:Subscribe",
      "sqs:GetQueueAttributes",
      "sqs:GetQueueUrl",
      "codebuild:CreateProject",
      "codebuild:DeleteProject",
      "codebuild:BatchGetBuilds",
      "codebuild:StartBuild",
    ]

    resources = ["*"]

    effect = "Allow"
  }

  statement {
    sid = "AllowS3OperationsOnElasticBeanstalkBuckets"

    actions = [
      "s3:*",
    ]

    resources = [
      "arn:aws:s3:::*",
    ]

    effect = "Allow"
  }

  statement {
    sid = "AllowDeleteCloudwatchLogGroups"

    actions = [
      "logs:DeleteLogGroup",
    ]

    resources = [
      "arn:aws:logs:*:*:log-group:/aws/elasticbeanstalk*",
    ]

    effect = "Allow"
  }

  statement {
    sid = "AllowCloudformationOperationsOnElasticBeanstalkStacks"

    actions = [
      "cloudformation:*",
    ]

    resources = [
      "arn:aws:cloudformation:*:*:stack/awseb-*",
      "arn:aws:cloudformation:*:*:stack/eb-*",
    ]

    effect = "Allow"
  }
}

resource "aws_iam_instance_profile" "ec2" {
  name = "${module.label.id}-ec2"
  role = "${aws_iam_role.ec2.name}"
}

resource "aws_security_group" "default" {
  name        = "${module.label.id}"
  description = "Allow inbound traffic from provided Security Groups"

  vpc_id = "${var.vpc_id}"

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = -1
    security_groups = ["${var.security_groups}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = "${module.label.tags}"
}

#
# Full list of options:
# http://docs.aws.amazon.com/elasticbeanstalk/latest/dg/command-options-general.html#command-options-general-elasticbeanstalkmanagedactionsplatformupdate
#
resource "aws_elastic_beanstalk_environment" "default" {
  name        = "${module.label.id}"
  application = "${var.app}"
  description = "${var.description}"

  tier                = "${var.tier}"
  solution_stack_name = "${var.solution_stack_name}"

  wait_for_ready_timeout = "${var.wait_for_ready_timeout}"

  version_label = "${var.version_label}"

  tags = "${module.label.tags}"

  # because of https://github.com/terraform-providers/terraform-provider-aws/issues/3963
  lifecycle {
    ignore_changes = ["tags"]
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
    value     = "${var.vpc_id}"
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "AssociatePublicIpAddress"
    value     = "${var.associate_public_ip_address}"
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value     = "${join(",", var.private_subnets)}"
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "ELBSubnets"
    value     = "${join(",", var.public_subnets)}"
  }

  setting {
    namespace = "aws:autoscaling:updatepolicy:rollingupdate"
    name      = "RollingUpdateEnabled"
    value     = "true"
  }

  setting {
    namespace = "aws:autoscaling:updatepolicy:rollingupdate"
    name      = "RollingUpdateType"
    value     = "${var.rolling_update_type}"
  }

  setting {
    namespace = "aws:autoscaling:updatepolicy:rollingupdate"
    name      = "MinInstancesInService"
    value     = "${var.updating_min_in_service}"
  }

  setting {
    namespace = "aws:elasticbeanstalk:command"
    name      = "DeploymentPolicy"
    value     = "${var.rolling_update_type == "Immutable" ? "Immutable" : "Rolling"}"
  }

  setting {
    namespace = "aws:autoscaling:updatepolicy:rollingupdate"
    name      = "MaxBatchSize"
    value     = "${var.updating_max_batch}"
  }

  ###=========================== Logging ========================== ###

  setting {
    namespace = "aws:elasticbeanstalk:hostmanager"
    name      = "LogPublicationControl"
    value     = "${var.enable_log_publication_control ? "true" : "false"}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:cloudwatch:logs"
    name      = "StreamLogs"
    value     = "${var.enable_stream_logs ? "true" : "false"}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:cloudwatch:logs"
    name      = "DeleteOnTerminate"
    value     = "${var.logs_delete_on_terminate ? "true" : "false"}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:cloudwatch:logs"
    name      = "RetentionInDays"
    value     = "${var.logs_retention_in_days}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:cloudwatch:logs:health"
    name      = "HealthStreamingEnabled"
    value     = "${var.health_streaming_enabled ? "true" : "false"}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:cloudwatch:logs:health"
    name      = "DeleteOnTerminate"
    value     = "${var.health_streaming_delete_on_terminate ? "true" : "false"}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:cloudwatch:logs:health"
    name      = "RetentionInDays"
    value     = "${var.health_streaming_retention_in_days}"
  }

  ###=========================== Autoscale trigger ========================== ###

  setting {
    namespace = "aws:autoscaling:trigger"
    name      = "MeasureName"
    value     = "${var.autoscale_measure_name}"
  }
  setting {
    namespace = "aws:autoscaling:trigger"
    name      = "Statistic"
    value     = "${var.autoscale_statistic}"
  }
  setting {
    namespace = "aws:autoscaling:trigger"
    name      = "Unit"
    value     = "${var.autoscale_unit}"
  }
  setting {
    namespace = "aws:autoscaling:trigger"
    name      = "LowerThreshold"
    value     = "${var.autoscale_lower_bound}"
  }
  setting {
    namespace = "aws:autoscaling:trigger"
    name      = "LowerBreachScaleIncrement"
    value     = "${var.autoscale_lower_increment}"
  }
  setting {
    namespace = "aws:autoscaling:trigger"
    name      = "UpperThreshold"
    value     = "${var.autoscale_upper_bound}"
  }
  setting {
    namespace = "aws:autoscaling:trigger"
    name      = "UpperBreachScaleIncrement"
    value     = "${var.autoscale_upper_increment}"
  }

  ###=========================== Autoscale trigger ========================== ###

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "SecurityGroups"
    value     = "${aws_security_group.default.id}"
  }
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "SSHSourceRestriction"
    value     = "tcp,22,22,${var.ssh_source_restriction}"
  }
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "InstanceType"
    value     = "${var.instance_type}"
  }
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = "${aws_iam_instance_profile.ec2.name}"
  }
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "EC2KeyName"
    value     = "${var.keypair}"
  }
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "RootVolumeSize"
    value     = "${var.root_volume_size}"
  }
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "RootVolumeType"
    value     = "${var.root_volume_type}"
  }
  setting {
    namespace = "aws:autoscaling:asg"
    name      = "Availability Zones"
    value     = "${var.availability_zones}"
  }
  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MinSize"
    value     = "${var.autoscale_min}"
  }
  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MaxSize"
    value     = "${var.autoscale_max}"
  }
  setting {
    namespace = "aws:elb:loadbalancer"
    name      = "CrossZone"
    value     = "true"
  }
  setting {
    namespace = "aws:elb:loadbalancer"
    name      = "SecurityGroups"
    value     = "${join(",", var.loadbalancer_security_groups)}"
  }
  setting {
    namespace = "aws:elb:loadbalancer"
    name      = "ManagedSecurityGroup"
    value     = "${var.loadbalancer_managed_security_group}"
  }
  setting {
    namespace = "aws:ec2:vpc"
    name      = "ELBScheme"
    value     = "${var.environment_type == "LoadBalanced" ? var.elb_scheme : ""}"
  }
  setting {
    namespace = "aws:elb:listener"
    name      = "ListenerProtocol"
    value     = "HTTP"
  }
  setting {
    namespace = "aws:elb:listener"
    name      = "InstancePort"
    value     = "${var.application_port}"
  }
  setting {
    namespace = "aws:elb:listener"
    name      = "ListenerEnabled"
    value     = "${var.http_listener_enabled  == "true" || var.loadbalancer_certificate_arn == "" ? "true" : "false"}"
  }
  setting {
    namespace = "aws:elb:listener:443"
    name      = "ListenerProtocol"
    value     = "HTTPS"
  }
  setting {
    namespace = "aws:elb:listener:443"
    name      = "InstancePort"
    value     = "${var.application_port}"
  }
  setting {
    namespace = "aws:elb:listener:443"
    name      = "SSLCertificateId"
    value     = "${var.loadbalancer_certificate_arn}"
  }
  setting {
    namespace = "aws:elb:listener:443"
    name      = "ListenerEnabled"
    value     = "${var.loadbalancer_certificate_arn == "" ? "false" : "true"}"
  }
  setting {
    namespace = "aws:elb:listener:${var.ssh_listener_port}"
    name      = "ListenerProtocol"
    value     = "TCP"
  }
  setting {
    namespace = "aws:elb:listener:${var.ssh_listener_port}"
    name      = "InstancePort"
    value     = "22"
  }
  setting {
    namespace = "aws:elb:listener:${var.ssh_listener_port}"
    name      = "ListenerEnabled"
    value     = "${var.ssh_listener_enabled}"
  }
  setting {
    namespace = "aws:elb:policies"
    name      = "ConnectionSettingIdleTimeout"
    value     = "${var.ssh_listener_enabled == "true" ? "3600" : "60"}"
  }
  setting {
    namespace = "aws:elb:policies"
    name      = "ConnectionDrainingEnabled"
    value     = "true"
  }
  setting {
    namespace = "aws:elbv2:loadbalancer"
    name      = "AccessLogsS3Bucket"
    value     = "${aws_s3_bucket.elb_logs.id}"
  }
  setting {
    namespace = "aws:elbv2:loadbalancer"
    name      = "AccessLogsS3Enabled"
    value     = "true"
  }
  setting {
    namespace = "aws:elbv2:loadbalancer"
    name      = "SecurityGroups"
    value     = "${join(",", var.loadbalancer_security_groups)}"
  }
  setting {
    namespace = "aws:elbv2:loadbalancer"
    name      = "ManagedSecurityGroup"
    value     = "${var.loadbalancer_managed_security_group}"
  }
  setting {
    namespace = "aws:elbv2:listener:default"
    name      = "ListenerEnabled"
    value     = "${var.http_listener_enabled == "true" || var.loadbalancer_certificate_arn == "" ? "true" : "false"}"
  }
  setting {
    namespace = "aws:elbv2:listener:443"
    name      = "ListenerEnabled"
    value     = "${var.loadbalancer_certificate_arn == "" ? "false" : "true"}"
  }
  setting {
    namespace = "aws:elbv2:listener:443"
    name      = "Protocol"
    value     = "HTTPS"
  }
  setting {
    namespace = "aws:elbv2:listener:443"
    name      = "SSLCertificateArns"
    value     = "${var.loadbalancer_certificate_arn}"
  }
  setting {
    namespace = "aws:elbv2:listener:443"
    name      = "SSLPolicy"
    value     = "${var.loadbalancer_type == "application" ? var.loadbalancer_ssl_policy : ""}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:healthreporting:system"
    name      = "ConfigDocument"
    value     = "${var.config_document}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application"
    name      = "Application Healthcheck URL"
    value     = "HTTP:${var.application_port}${var.healthcheck_url}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "EnvironmentType"
    value     = "${var.environment_type}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "LoadBalancerType"
    value     = "${var.loadbalancer_type}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "ServiceRole"
    value     = "${aws_iam_role.service.name}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:healthreporting:system"
    name      = "SystemType"
    value     = "${var.enhanced_reporting_enabled ? "enhanced" : "basic"}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:command"
    name      = "BatchSizeType"
    value     = "Fixed"
  }
  setting {
    namespace = "aws:elasticbeanstalk:command"
    name      = "BatchSize"
    value     = "1"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "BASE_HOST"
    value     = "${var.name}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "CONFIG_SOURCE"
    value     = "${var.config_source}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:managedactions"
    name      = "ManagedActionsEnabled"
    value     = "${var.enable_managed_actions ? "true" : "false"}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:managedactions"
    name      = "PreferredStartTime"
    value     = "${var.preferred_start_time}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:managedactions:platformupdate"
    name      = "UpdateLevel"
    value     = "${var.update_level}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:managedactions:platformupdate"
    name      = "InstanceRefreshEnabled"
    value     = "${var.instance_refresh_enabled}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:container:nodejs"
    name      = "NodeVersion"
    value     = "${var.nodejs_version}"
  }
  ###===================== Application ENV vars ======================###
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "${element(concat(keys(var.env_vars), list(format(var.env_default_key, 0))), 0)}"
    value     = "${lookup(var.env_vars, element(concat(keys(var.env_vars), list(format(var.env_default_key, 0))), 0), var.env_default_value)}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "${element(concat(keys(var.env_vars), list(format(var.env_default_key, 1))), 1)}"
    value     = "${lookup(var.env_vars, element(concat(keys(var.env_vars), list(format(var.env_default_key, 1))), 1), var.env_default_value)}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "${element(concat(keys(var.env_vars), list(format(var.env_default_key, 2))), 2)}"
    value     = "${lookup(var.env_vars, element(concat(keys(var.env_vars), list(format(var.env_default_key, 2))), 2), var.env_default_value)}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "${element(concat(keys(var.env_vars), list(format(var.env_default_key, 3))), 3)}"
    value     = "${lookup(var.env_vars, element(concat(keys(var.env_vars), list(format(var.env_default_key, 3))), 3), var.env_default_value)}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "${element(concat(keys(var.env_vars), list(format(var.env_default_key, 4))), 4)}"
    value     = "${lookup(var.env_vars, element(concat(keys(var.env_vars), list(format(var.env_default_key, 4))), 4), var.env_default_value)}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "${element(concat(keys(var.env_vars), list(format(var.env_default_key, 5))), 5)}"
    value     = "${lookup(var.env_vars, element(concat(keys(var.env_vars), list(format(var.env_default_key, 5))), 5), var.env_default_value)}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "${element(concat(keys(var.env_vars), list(format(var.env_default_key, 6))), 6)}"
    value     = "${lookup(var.env_vars, element(concat(keys(var.env_vars), list(format(var.env_default_key, 6))), 6), var.env_default_value)}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "${element(concat(keys(var.env_vars), list(format(var.env_default_key, 7))), 7)}"
    value     = "${lookup(var.env_vars, element(concat(keys(var.env_vars), list(format(var.env_default_key, 7))), 7), var.env_default_value)}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "${element(concat(keys(var.env_vars), list(format(var.env_default_key, 8))), 8)}"
    value     = "${lookup(var.env_vars, element(concat(keys(var.env_vars), list(format(var.env_default_key, 8))), 8), var.env_default_value)}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "${element(concat(keys(var.env_vars), list(format(var.env_default_key, 9))), 9)}"
    value     = "${lookup(var.env_vars, element(concat(keys(var.env_vars), list(format(var.env_default_key, 9))), 9), var.env_default_value)}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "${element(concat(keys(var.env_vars), list(format(var.env_default_key, 10))), 10)}"
    value     = "${lookup(var.env_vars, element(concat(keys(var.env_vars), list(format(var.env_default_key, 10))), 10), var.env_default_value)}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "${element(concat(keys(var.env_vars), list(format(var.env_default_key, 11))), 11)}"
    value     = "${lookup(var.env_vars, element(concat(keys(var.env_vars), list(format(var.env_default_key, 11))), 11), var.env_default_value)}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "${element(concat(keys(var.env_vars), list(format(var.env_default_key, 12))), 12)}"
    value     = "${lookup(var.env_vars, element(concat(keys(var.env_vars), list(format(var.env_default_key, 12))), 12), var.env_default_value)}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "${element(concat(keys(var.env_vars), list(format(var.env_default_key, 13))), 13)}"
    value     = "${lookup(var.env_vars, element(concat(keys(var.env_vars), list(format(var.env_default_key, 13))), 13), var.env_default_value)}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "${element(concat(keys(var.env_vars), list(format(var.env_default_key, 14))), 14)}"
    value     = "${lookup(var.env_vars, element(concat(keys(var.env_vars), list(format(var.env_default_key, 14))), 14), var.env_default_value)}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "${element(concat(keys(var.env_vars), list(format(var.env_default_key, 15))), 15)}"
    value     = "${lookup(var.env_vars, element(concat(keys(var.env_vars), list(format(var.env_default_key, 15))), 15), var.env_default_value)}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "${element(concat(keys(var.env_vars), list(format(var.env_default_key, 16))), 16)}"
    value     = "${lookup(var.env_vars, element(concat(keys(var.env_vars), list(format(var.env_default_key, 16))), 16), var.env_default_value)}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "${element(concat(keys(var.env_vars), list(format(var.env_default_key, 17))), 17)}"
    value     = "${lookup(var.env_vars, element(concat(keys(var.env_vars), list(format(var.env_default_key, 17))), 17), var.env_default_value)}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "${element(concat(keys(var.env_vars), list(format(var.env_default_key, 18))), 18)}"
    value     = "${lookup(var.env_vars, element(concat(keys(var.env_vars), list(format(var.env_default_key, 18))), 18), var.env_default_value)}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "${element(concat(keys(var.env_vars), list(format(var.env_default_key, 19))), 19)}"
    value     = "${lookup(var.env_vars, element(concat(keys(var.env_vars), list(format(var.env_default_key, 19))), 19), var.env_default_value)}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "${element(concat(keys(var.env_vars), list(format(var.env_default_key, 20))), 20)}"
    value     = "${lookup(var.env_vars, element(concat(keys(var.env_vars), list(format(var.env_default_key, 20))), 20), var.env_default_value)}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "${element(concat(keys(var.env_vars), list(format(var.env_default_key, 21))), 21)}"
    value     = "${lookup(var.env_vars, element(concat(keys(var.env_vars), list(format(var.env_default_key, 21))), 21), var.env_default_value)}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "${element(concat(keys(var.env_vars), list(format(var.env_default_key, 22))), 22)}"
    value     = "${lookup(var.env_vars, element(concat(keys(var.env_vars), list(format(var.env_default_key, 22))), 22), var.env_default_value)}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "${element(concat(keys(var.env_vars), list(format(var.env_default_key, 23))), 23)}"
    value     = "${lookup(var.env_vars, element(concat(keys(var.env_vars), list(format(var.env_default_key, 23))), 23), var.env_default_value)}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "${element(concat(keys(var.env_vars), list(format(var.env_default_key, 24))), 24)}"
    value     = "${lookup(var.env_vars, element(concat(keys(var.env_vars), list(format(var.env_default_key, 24))), 24), var.env_default_value)}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "${element(concat(keys(var.env_vars), list(format(var.env_default_key, 25))), 25)}"
    value     = "${lookup(var.env_vars, element(concat(keys(var.env_vars), list(format(var.env_default_key, 25))), 25), var.env_default_value)}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "${element(concat(keys(var.env_vars), list(format(var.env_default_key, 26))), 26)}"
    value     = "${lookup(var.env_vars, element(concat(keys(var.env_vars), list(format(var.env_default_key, 26))), 26), var.env_default_value)}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "${element(concat(keys(var.env_vars), list(format(var.env_default_key, 27))), 27)}"
    value     = "${lookup(var.env_vars, element(concat(keys(var.env_vars), list(format(var.env_default_key, 27))), 27), var.env_default_value)}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "${element(concat(keys(var.env_vars), list(format(var.env_default_key, 28))), 28)}"
    value     = "${lookup(var.env_vars, element(concat(keys(var.env_vars), list(format(var.env_default_key, 28))), 28), var.env_default_value)}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "${element(concat(keys(var.env_vars), list(format(var.env_default_key, 29))), 29)}"
    value     = "${lookup(var.env_vars, element(concat(keys(var.env_vars), list(format(var.env_default_key, 29))), 29), var.env_default_value)}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "${element(concat(keys(var.env_vars), list(format(var.env_default_key, 30))), 30)}"
    value     = "${lookup(var.env_vars, element(concat(keys(var.env_vars), list(format(var.env_default_key, 30))), 30), var.env_default_value)}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "${element(concat(keys(var.env_vars), list(format(var.env_default_key, 31))), 31)}"
    value     = "${lookup(var.env_vars, element(concat(keys(var.env_vars), list(format(var.env_default_key, 31))), 31), var.env_default_value)}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "${element(concat(keys(var.env_vars), list(format(var.env_default_key, 32))), 32)}"
    value     = "${lookup(var.env_vars, element(concat(keys(var.env_vars), list(format(var.env_default_key, 32))), 32), var.env_default_value)}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "${element(concat(keys(var.env_vars), list(format(var.env_default_key, 33))), 33)}"
    value     = "${lookup(var.env_vars, element(concat(keys(var.env_vars), list(format(var.env_default_key, 33))), 33), var.env_default_value)}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "${element(concat(keys(var.env_vars), list(format(var.env_default_key, 34))), 34)}"
    value     = "${lookup(var.env_vars, element(concat(keys(var.env_vars), list(format(var.env_default_key, 34))), 34), var.env_default_value)}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "${element(concat(keys(var.env_vars), list(format(var.env_default_key, 35))), 35)}"
    value     = "${lookup(var.env_vars, element(concat(keys(var.env_vars), list(format(var.env_default_key, 35))), 35), var.env_default_value)}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "${element(concat(keys(var.env_vars), list(format(var.env_default_key, 36))), 36)}"
    value     = "${lookup(var.env_vars, element(concat(keys(var.env_vars), list(format(var.env_default_key, 36))), 36), var.env_default_value)}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "${element(concat(keys(var.env_vars), list(format(var.env_default_key, 37))), 37)}"
    value     = "${lookup(var.env_vars, element(concat(keys(var.env_vars), list(format(var.env_default_key, 37))), 37), var.env_default_value)}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "${element(concat(keys(var.env_vars), list(format(var.env_default_key, 38))), 38)}"
    value     = "${lookup(var.env_vars, element(concat(keys(var.env_vars), list(format(var.env_default_key, 38))), 38), var.env_default_value)}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "${element(concat(keys(var.env_vars), list(format(var.env_default_key, 39))), 39)}"
    value     = "${lookup(var.env_vars, element(concat(keys(var.env_vars), list(format(var.env_default_key, 39))), 39), var.env_default_value)}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "${element(concat(keys(var.env_vars), list(format(var.env_default_key, 40))), 40)}"
    value     = "${lookup(var.env_vars, element(concat(keys(var.env_vars), list(format(var.env_default_key, 40))), 40), var.env_default_value)}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "${element(concat(keys(var.env_vars), list(format(var.env_default_key, 41))), 41)}"
    value     = "${lookup(var.env_vars, element(concat(keys(var.env_vars), list(format(var.env_default_key, 41))), 41), var.env_default_value)}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "${element(concat(keys(var.env_vars), list(format(var.env_default_key, 42))), 42)}"
    value     = "${lookup(var.env_vars, element(concat(keys(var.env_vars), list(format(var.env_default_key, 42))), 42), var.env_default_value)}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "${element(concat(keys(var.env_vars), list(format(var.env_default_key, 43))), 43)}"
    value     = "${lookup(var.env_vars, element(concat(keys(var.env_vars), list(format(var.env_default_key, 43))), 43), var.env_default_value)}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "${element(concat(keys(var.env_vars), list(format(var.env_default_key, 44))), 44)}"
    value     = "${lookup(var.env_vars, element(concat(keys(var.env_vars), list(format(var.env_default_key, 44))), 44), var.env_default_value)}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "${element(concat(keys(var.env_vars), list(format(var.env_default_key, 45))), 45)}"
    value     = "${lookup(var.env_vars, element(concat(keys(var.env_vars), list(format(var.env_default_key, 45))), 45), var.env_default_value)}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "${element(concat(keys(var.env_vars), list(format(var.env_default_key, 46))), 46)}"
    value     = "${lookup(var.env_vars, element(concat(keys(var.env_vars), list(format(var.env_default_key, 46))), 46), var.env_default_value)}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "${element(concat(keys(var.env_vars), list(format(var.env_default_key, 47))), 47)}"
    value     = "${lookup(var.env_vars, element(concat(keys(var.env_vars), list(format(var.env_default_key, 47))), 47), var.env_default_value)}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "${element(concat(keys(var.env_vars), list(format(var.env_default_key, 48))), 48)}"
    value     = "${lookup(var.env_vars, element(concat(keys(var.env_vars), list(format(var.env_default_key, 48))), 48), var.env_default_value)}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "${element(concat(keys(var.env_vars), list(format(var.env_default_key, 49))), 49)}"
    value     = "${lookup(var.env_vars, element(concat(keys(var.env_vars), list(format(var.env_default_key, 49))), 49), var.env_default_value)}"
  }
  ###===================== Application Load Balancer Health check settings =====================================================###
  # The Application Load Balancer health check does not take into account the Elastic Beanstalk health check path
  # http://docs.aws.amazon.com/elasticbeanstalk/latest/dg/environments-cfg-applicationloadbalancer.html
  # http://docs.aws.amazon.com/elasticbeanstalk/latest/dg/environments-cfg-applicationloadbalancer.html#alb-default-process.config
  setting {
    namespace = "aws:elasticbeanstalk:environment:process:default"
    name      = "HealthCheckPath"
    value     = "${var.healthcheck_url}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:environment:process:default"
    name      = "Port"
    value     = "${var.application_port}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:environment:process:default"
    name      = "Protocol"
    value     = "HTTP"
  }

  ###===================== Notification =====================================================###

  setting {
    namespace = "aws:elasticbeanstalk:sns:topics"
    name      = "Notification Endpoint"
    value     = "${var.notification_endpoint}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:sns:topics"
    name      = "Notification Protocol"
    value     = "${var.notification_protocol}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:sns:topics"
    name      = "Notification Topic ARN"
    value     = "${var.notification_topic_arn}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:sns:topics"
    name      = "Notification Topic Name"
    value     = "${var.notification_topic_name}"
  }
  depends_on = ["aws_security_group.default"]
}

data "aws_elb_service_account" "main" {}

data "aws_iam_policy_document" "elb_logs" {
  statement {
    sid = ""

    actions = [
      "s3:PutObject",
    ]

    resources = [
      "arn:aws:s3:::${module.label.id}-logs/*",
    ]

    principals {
      type        = "AWS"
      identifiers = ["${data.aws_elb_service_account.main.arn}"]
    }

    effect = "Allow"
  }
}

resource "aws_s3_bucket" "elb_logs" {
  bucket        = "${module.label.id}-logs"
  acl           = "private"
  force_destroy = "${var.force_destroy}"
  policy        = "${data.aws_iam_policy_document.elb_logs.json}"
}

module "tld" {
  source    = "git::https://github.com/cloudposse/terraform-aws-route53-cluster-hostname.git?ref=tags/0.2.5"
  namespace = "${var.namespace}"
  name      = "${var.name}"
  stage     = "${var.stage}"
  zone_id   = "${var.zone_id}"
  records   = ["${aws_elastic_beanstalk_environment.default.cname}"]
  enabled   = "${length(var.zone_id) > 0 ? "true" : "false"}"
}
