# Define composite variables for resources
module "label" {
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.2.1"
  namespace  = "${var.namespace}"
  name       = "${var.name}"
  stage      = "${var.stage}"
  delimiter  = "${var.delimiter}"
  attributes = "${var.attributes}"
  tags       = "${var.tags}"
}

data "aws_region" "default" {
  current = true
}

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

resource "aws_ssm_activation" "ec2" {
  name               = "${module.label.id}"
  iam_role           = "${aws_iam_role.ec2.id}"
  registration_limit = "${var.autoscale_max}"
}

#

# Other stuff

#

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
      "s3:CopyObject",
      "s3:GetObject",
      "s3:GetObjectAcl",
      "s3:GetObjectMetadata",
      "s3:ListBucket",
      "s3:listBuckets",
      "s3:ListObjects",
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
  name = "${module.label.id}"
  role = "${aws_iam_role.ec2.name}"
}

resource "aws_security_group" "default" {
  name        = "${module.label.id}"
  description = "Allow all inbound traffic"

  vpc_id = "${var.vpc_id}"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

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

  tags {
    Name      = "${module.label.id}"
    Namespace = "${var.namespace}"
    Stage     = "${var.stage}"
  }
}

# This pattern of generating ENV vars will be changed in the future once Terraform implements iterrators: https://github.com/hashicorp/terraform/issues/7034
resource "null_resource" "env_vars" {
  # Max number of supported ENV variables
  count = 50

  triggers {
    key = "${count.index < length(var.env_vars) ?
                        element(concat(keys(var.env_vars),list("")), count.index) :
                        format(var.env_default_key, count.index+1)
               }"

    value = "${count.index < length(var.env_vars) ?
                        lookup(var.env_vars, element(concat(keys(var.env_vars),list("")), count.index), var.env_default_value) :
                        var.env_default_value
                 }"
  }
}

#

# Full list of options:

# http://docs.aws.amazon.com/elasticbeanstalk/latest/dg/command-options-general.html#command-options-general-elasticbeanstalkmanagedactionsplatformupdate

#

resource "aws_elastic_beanstalk_environment" "default" {
  name        = "${module.label.id}"
  application = "${var.app}"

  tier                = "WebServer"
  solution_stack_name = "${var.solution_stack_name}"

  tags {
    Name      = "${module.label.id}"
    Namespace = "${var.namespace}"
    Stage     = "${var.stage}"
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
    value     = "${var.vpc_id}"
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "AssociatePublicIpAddress"
    value     = "false"
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
    value     = "Health"
  }

  setting {
    namespace = "aws:autoscaling:updatepolicy:rollingupdate"
    name      = "MinInstancesInService"
    value     = "${var.updating_min_in_service}"
  }

  setting {
    namespace = "aws:autoscaling:updatepolicy:rollingupdate"
    name      = "MaxBatchSize"
    value     = "${var.updating_max_batch}"
  }

  ###=========================== Autoscale trigger ========================== ###

  setting {
    namespace = "aws:autoscaling:trigger"
    name      = "MeasureName"
    value     = "CPUUtilization"
  }
  setting {
    namespace = "aws:autoscaling:trigger"
    name      = "Statistic"
    value     = "Average"
  }
  setting {
    namespace = "aws:autoscaling:trigger"
    name      = "Unit"
    value     = "Percent"
  }
  setting {
    namespace = "aws:autoscaling:trigger"
    name      = "LowerThreshold"
    value     = "${var.autoscale_lower_bound}"
  }
  setting {
    namespace = "aws:autoscaling:trigger"
    name      = "UpperThreshold"
    value     = "${var.autoscale_upper_bound}"
  }

  ###=========================== Autoscale trigger ========================== ###

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "SecurityGroups"
    value     = "${aws_security_group.default.id}"
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
    namespace = "aws:autoscaling:asg"
    name      = "Availability Zones"
    value     = "Any 2"
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
    namespace = "aws:elb:listener"
    name      = "ListenerProtocol"
    value     = "HTTP"
  }
  setting {
    namespace = "aws:elb:listener"
    name      = "InstancePort"
    value     = "80"
  }
  setting {
    namespace = "aws:elb:listener"
    name      = "ListenerEnabled"
    value     = "${var.http_listener_enabled || var.loadbalancer_certificate_arn == "" ? "true" : "false"}"
  }
  setting {
    namespace = "aws:elb:listener:443"
    name      = "ListenerProtocol"
    value     = "HTTPS"
  }
  setting {
    namespace = "aws:elb:listener:443"
    name      = "InstancePort"
    value     = "80"
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
    namespace = "aws:elbv2:listener:default"
    name      = "ListenerEnabled"
    value     = "${var.http_listener_enabled || var.loadbalancer_certificate_arn == "" ? "true" : "false"}"
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
    namespace = "aws:elasticbeanstalk:application"
    name      = "Application Healthcheck URL"
    value     = "HTTP:80${var.healthcheck_url}"
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
    value     = "enhanced"
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
    namespace = "aws:elasticbeanstalk:command"
    name      = "DeploymentPolicy"
    value     = "Rolling"
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
    value     = "true"
  }
  setting {
    namespace = "aws:elasticbeanstalk:managedactions"
    name      = "PreferredStartTime"
    value     = "Sun:10:00"
  }
  setting {
    namespace = "aws:elasticbeanstalk:managedactions:platformupdate"
    name      = "UpdateLevel"
    value     = "minor"
  }
  setting {
    namespace = "aws:elasticbeanstalk:managedactions:platformupdate"
    name      = "InstanceRefreshEnabled"
    value     = "true"
  }
  ###===================== Application ENV vars ======================###
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "${null_resource.env_vars.0.triggers.key}"
    value     = "${null_resource.env_vars.0.triggers.value}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "${null_resource.env_vars.1.triggers.key}"
    value     = "${null_resource.env_vars.1.triggers.value}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "${null_resource.env_vars.2.triggers.key}"
    value     = "${null_resource.env_vars.2.triggers.value}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "${null_resource.env_vars.3.triggers.key}"
    value     = "${null_resource.env_vars.3.triggers.value}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "${null_resource.env_vars.4.triggers.key}"
    value     = "${null_resource.env_vars.4.triggers.value}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "${null_resource.env_vars.5.triggers.key}"
    value     = "${null_resource.env_vars.5.triggers.value}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "${null_resource.env_vars.6.triggers.key}"
    value     = "${null_resource.env_vars.6.triggers.value}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "${null_resource.env_vars.7.triggers.key}"
    value     = "${null_resource.env_vars.7.triggers.value}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "${null_resource.env_vars.8.triggers.key}"
    value     = "${null_resource.env_vars.8.triggers.value}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "${null_resource.env_vars.9.triggers.key}"
    value     = "${null_resource.env_vars.9.triggers.value}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "${null_resource.env_vars.10.triggers.key}"
    value     = "${null_resource.env_vars.10.triggers.value}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "${null_resource.env_vars.11.triggers.key}"
    value     = "${null_resource.env_vars.11.triggers.value}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "${null_resource.env_vars.12.triggers.key}"
    value     = "${null_resource.env_vars.12.triggers.value}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "${null_resource.env_vars.13.triggers.key}"
    value     = "${null_resource.env_vars.13.triggers.value}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "${null_resource.env_vars.14.triggers.key}"
    value     = "${null_resource.env_vars.14.triggers.value}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "${null_resource.env_vars.15.triggers.key}"
    value     = "${null_resource.env_vars.15.triggers.value}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "${null_resource.env_vars.16.triggers.key}"
    value     = "${null_resource.env_vars.16.triggers.value}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "${null_resource.env_vars.17.triggers.key}"
    value     = "${null_resource.env_vars.17.triggers.value}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "${null_resource.env_vars.18.triggers.key}"
    value     = "${null_resource.env_vars.18.triggers.value}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "${null_resource.env_vars.19.triggers.key}"
    value     = "${null_resource.env_vars.19.triggers.value}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "${null_resource.env_vars.20.triggers.key}"
    value     = "${null_resource.env_vars.20.triggers.value}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "${null_resource.env_vars.21.triggers.key}"
    value     = "${null_resource.env_vars.21.triggers.value}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "${null_resource.env_vars.22.triggers.key}"
    value     = "${null_resource.env_vars.22.triggers.value}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "${null_resource.env_vars.23.triggers.key}"
    value     = "${null_resource.env_vars.23.triggers.value}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "${null_resource.env_vars.24.triggers.key}"
    value     = "${null_resource.env_vars.24.triggers.value}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "${null_resource.env_vars.25.triggers.key}"
    value     = "${null_resource.env_vars.25.triggers.value}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "${null_resource.env_vars.26.triggers.key}"
    value     = "${null_resource.env_vars.26.triggers.value}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "${null_resource.env_vars.27.triggers.key}"
    value     = "${null_resource.env_vars.27.triggers.value}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "${null_resource.env_vars.28.triggers.key}"
    value     = "${null_resource.env_vars.28.triggers.value}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "${null_resource.env_vars.29.triggers.key}"
    value     = "${null_resource.env_vars.29.triggers.value}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "${null_resource.env_vars.30.triggers.key}"
    value     = "${null_resource.env_vars.30.triggers.value}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "${null_resource.env_vars.31.triggers.key}"
    value     = "${null_resource.env_vars.31.triggers.value}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "${null_resource.env_vars.32.triggers.key}"
    value     = "${null_resource.env_vars.32.triggers.value}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "${null_resource.env_vars.33.triggers.key}"
    value     = "${null_resource.env_vars.33.triggers.value}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "${null_resource.env_vars.34.triggers.key}"
    value     = "${null_resource.env_vars.34.triggers.value}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "${null_resource.env_vars.35.triggers.key}"
    value     = "${null_resource.env_vars.35.triggers.value}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "${null_resource.env_vars.36.triggers.key}"
    value     = "${null_resource.env_vars.36.triggers.value}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "${null_resource.env_vars.37.triggers.key}"
    value     = "${null_resource.env_vars.37.triggers.value}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "${null_resource.env_vars.38.triggers.key}"
    value     = "${null_resource.env_vars.38.triggers.value}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "${null_resource.env_vars.39.triggers.key}"
    value     = "${null_resource.env_vars.39.triggers.value}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "${null_resource.env_vars.40.triggers.key}"
    value     = "${null_resource.env_vars.40.triggers.value}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "${null_resource.env_vars.41.triggers.key}"
    value     = "${null_resource.env_vars.41.triggers.value}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "${null_resource.env_vars.42.triggers.key}"
    value     = "${null_resource.env_vars.42.triggers.value}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "${null_resource.env_vars.43.triggers.key}"
    value     = "${null_resource.env_vars.43.triggers.value}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "${null_resource.env_vars.44.triggers.key}"
    value     = "${null_resource.env_vars.44.triggers.value}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "${null_resource.env_vars.45.triggers.key}"
    value     = "${null_resource.env_vars.45.triggers.value}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "${null_resource.env_vars.46.triggers.key}"
    value     = "${null_resource.env_vars.46.triggers.value}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "${null_resource.env_vars.47.triggers.key}"
    value     = "${null_resource.env_vars.47.triggers.value}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "${null_resource.env_vars.48.triggers.key}"
    value     = "${null_resource.env_vars.48.triggers.value}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "${null_resource.env_vars.49.triggers.key}"
    value     = "${null_resource.env_vars.49.triggers.value}"
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
  bucket = "${module.label.id}-logs"
  acl    = "private"

  policy = "${data.aws_iam_policy_document.elb_logs.json}"
}

module "tld" {
  source    = "git::https://github.com/cloudposse/terraform-aws-route53-cluster-hostname.git?ref=tags/0.1.1"
  namespace = "${var.namespace}"
  name      = "${var.name}"
  stage     = "${var.stage}"
  zone_id   = "${var.zone_id}"
  records   = ["${aws_elastic_beanstalk_environment.default.cname}"]
}
