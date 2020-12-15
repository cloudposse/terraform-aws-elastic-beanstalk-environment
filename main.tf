module "label" {
  source      = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.17.0"
  namespace   = var.namespace
  environment = var.environment
  name        = var.name
  stage       = var.stage
  delimiter   = var.delimiter
  attributes  = var.attributes
  tags        = var.tags
}

#
# Service
#
data "aws_iam_policy_document" "service" {
  statement {
    actions = [
      "sts:AssumeRole"
    ]

    principals {
      type        = "Service"
      identifiers = ["elasticbeanstalk.amazonaws.com"]
    }

    effect = "Allow"
  }
}

resource "aws_iam_role" "service" {
  name               = "${module.label.id}-eb-service"
  assume_role_policy = data.aws_iam_policy_document.service.json
}

resource "aws_iam_role_policy_attachment" "enhanced_health" {
  count      = var.enhanced_reporting_enabled ? 1 : 0
  role       = aws_iam_role.service.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSElasticBeanstalkEnhancedHealth"
}

resource "aws_iam_role_policy_attachment" "service" {
  role       = aws_iam_role.service.name
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

resource "aws_iam_role_policy_attachment" "elastic_beanstalk_multi_container_docker" {
  role       = aws_iam_role.ec2.name
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkMulticontainerDocker"
}

resource "aws_iam_role" "ec2" {
  name               = "${module.label.id}-eb-ec2"
  assume_role_policy = data.aws_iam_policy_document.ec2.json
}

resource "aws_iam_role_policy" "default" {
  name   = "${module.label.id}-eb-default"
  role   = aws_iam_role.ec2.id
  policy = data.aws_iam_policy_document.extended.json
}

resource "aws_iam_role_policy_attachment" "web_tier" {
  role       = aws_iam_role.ec2.name
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier"
}

resource "aws_iam_role_policy_attachment" "worker_tier" {
  role       = aws_iam_role.ec2.name
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWorkerTier"
}

resource "aws_iam_role_policy_attachment" "ssm_ec2" {
  role       = aws_iam_role.ec2.name
  policy_arn = var.prefer_legacy_ssm_policy ? "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM" : "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_role_policy_attachment" "ssm_automation" {
  role       = aws_iam_role.ec2.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonSSMAutomationRole"

  lifecycle {
    create_before_destroy = true
  }
}

# http://docs.aws.amazon.com/elasticbeanstalk/latest/dg/create_deploy_docker.container.console.html
# http://docs.aws.amazon.com/AmazonECR/latest/userguide/ecr_managed_policies.html#AmazonEC2ContainerRegistryReadOnly
resource "aws_iam_role_policy_attachment" "ecr_readonly" {
  role       = aws_iam_role.ec2.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_ssm_activation" "ec2" {
  name               = module.label.id
  iam_role           = aws_iam_role.ec2.id
  registration_limit = var.autoscale_max
}

data "aws_iam_policy_document" "default" {
  statement {
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
      "s3:*"
    ]

    resources = [
      "arn:aws:s3:::*"
    ]

    effect = "Allow"
  }

  statement {
    sid = "AllowDeleteCloudwatchLogGroups"

    actions = [
      "logs:DeleteLogGroup"
    ]

    resources = [
      "arn:aws:logs:*:*:log-group:/aws/elasticbeanstalk*"
    ]

    effect = "Allow"
  }

  statement {
    sid = "AllowCloudformationOperationsOnElasticBeanstalkStacks"

    actions = [
      "cloudformation:*"
    ]

    resources = [
      "arn:aws:cloudformation:*:*:stack/awseb-*",
      "arn:aws:cloudformation:*:*:stack/eb-*"
    ]

    effect = "Allow"
  }
}

data "aws_iam_policy_document" "extended" {
  source_json   = data.aws_iam_policy_document.default.json
  override_json = var.extended_ec2_policy_document
}

resource "aws_iam_instance_profile" "ec2" {
  name = "${module.label.id}-eb-ec2"
  role = aws_iam_role.ec2.name
}

resource "aws_security_group" "default" {
  name        = module.label.id
  description = "Allow inbound traffic from provided Security Groups"

  vpc_id = var.vpc_id

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = -1
    security_groups = var.allowed_security_groups
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = module.label.tags
}

locals {
  // Remove `Name` tag from the map of tags because Elastic Beanstalk generates the `Name` tag automatically
  // and if it is provided, terraform tries to recreate the application on each `plan/apply`
  // `Namespace` should be removed as well since any string that contains `Name` forces recreation
  // https://github.com/terraform-providers/terraform-provider-aws/issues/3963
  tags = { for t in keys(module.label.tags) : t => module.label.tags[t] if t != "Name" && t != "Namespace" }

  classic_elb_settings = [
    {
      namespace = "aws:elb:loadbalancer"
      name      = "CrossZone"
      value     = var.loadbalancer_crosszone
    },
    {
      namespace = "aws:elb:loadbalancer"
      name      = "SecurityGroups"
      value     = join(",", sort(var.loadbalancer_security_groups))
    },
    {
      namespace = "aws:elb:loadbalancer"
      name      = "ManagedSecurityGroup"
      value     = var.loadbalancer_managed_security_group
    },

    {
      namespace = "aws:elb:listener"
      name      = "ListenerProtocol"
      value     = "HTTP"
    },
    {
      namespace = "aws:elb:listener"
      name      = "InstancePort"
      value     = var.application_port
    },
    {
      namespace = "aws:elb:listener"
      name      = "ListenerEnabled"
      value     = var.http_listener_enabled || var.loadbalancer_certificate_arn == "" ? "true" : "false"
    },
    {
      namespace = "aws:elb:listener:443"
      name      = "ListenerProtocol"
      value     = "HTTPS"
    },
    {
      namespace = "aws:elb:listener:443"
      name      = "InstancePort"
      value     = var.application_port
    },
    {
      namespace = "aws:elb:listener:443"
      name      = "SSLCertificateId"
      value     = var.loadbalancer_certificate_arn
    },
    {
      namespace = "aws:elb:listener:443"
      name      = "ListenerEnabled"
      value     = var.loadbalancer_certificate_arn == "" ? "false" : "true"
    },
    {
      namespace = "aws:elb:listener:${var.ssh_listener_port}"
      name      = "ListenerProtocol"
      value     = "TCP"
    },
    {
      namespace = "aws:elb:listener:${var.ssh_listener_port}"
      name      = "InstancePort"
      value     = "22"
    },
    {
      namespace = "aws:elb:listener:${var.ssh_listener_port}"
      name      = "ListenerEnabled"
      value     = var.ssh_listener_enabled
    },
    {
      namespace = "aws:elb:policies"
      name      = "ConnectionSettingIdleTimeout"
      value     = var.ssh_listener_enabled ? "3600" : "60"
    },
    {
      namespace = "aws:elb:policies"
      name      = "ConnectionDrainingEnabled"
      value     = "true"
    },
  ]
  alb_settings = [
    {
      namespace = "aws:elbv2:loadbalancer"
      name      = "AccessLogsS3Bucket"
      value     = join("", sort(aws_s3_bucket.elb_logs.*.id))
    },
    {
      namespace = "aws:elbv2:loadbalancer"
      name      = "AccessLogsS3Enabled"
      value     = "true"
    },
    {
      namespace = "aws:elbv2:loadbalancer"
      name      = "SecurityGroups"
      value     = join(",", sort(var.loadbalancer_security_groups))
    },
    {
      namespace = "aws:elbv2:loadbalancer"
      name      = "ManagedSecurityGroup"
      value     = var.loadbalancer_managed_security_group
    },
    {
      namespace = "aws:elbv2:listener:default"
      name      = "ListenerEnabled"
      value     = var.http_listener_enabled || var.loadbalancer_certificate_arn == "" ? "true" : "false"
    },
    {
      namespace = "aws:elbv2:listener:443"
      name      = "ListenerEnabled"
      value     = var.loadbalancer_certificate_arn == "" ? "false" : "true"
    },
    {
      namespace = "aws:elbv2:listener:443"
      name      = "Protocol"
      value     = "HTTPS"
    },
    {
      namespace = "aws:elbv2:listener:443"
      name      = "SSLCertificateArns"
      value     = var.loadbalancer_certificate_arn
    },
    {
      namespace = "aws:elbv2:listener:443"
      name      = "SSLPolicy"
      value     = var.loadbalancer_type == "application" ? var.loadbalancer_ssl_policy : ""
    }
  ]

  generic_elb_settings = [
    {
      namespace = "aws:ec2:vpc"
      name      = "ELBSubnets"
      value     = join(",", sort(var.loadbalancer_subnets))
    },

    {
      namespace = "aws:ec2:vpc"
      name      = "ELBScheme"
      value     = var.environment_type == "LoadBalanced" ? var.elb_scheme : ""
    },
    {
      namespace = "aws:elasticbeanstalk:environment"
      name      = "LoadBalancerType"
      value     = var.loadbalancer_type
    },

    ###===================== Application Load Balancer Health check settings =====================================================###
    # The Application Load Balancer health check does not take into account the Elastic Beanstalk health check path
    # http://docs.aws.amazon.com/elasticbeanstalk/latest/dg/environments-cfg-applicationloadbalancer.html
    # http://docs.aws.amazon.com/elasticbeanstalk/latest/dg/environments-cfg-applicationloadbalancer.html#alb-default-process.config
    {
      namespace = "aws:elasticbeanstalk:environment:process:default"
      name      = "HealthCheckPath"
      value     = var.healthcheck_url
    },
    {
      namespace = "aws:elasticbeanstalk:environment:process:default"
      name      = "Port"
      value     = var.application_port
    },
    {
      namespace = "aws:elasticbeanstalk:environment:process:default"
      name      = "Protocol"
      value     = "HTTP"
    }
  ]

  # If the tier is "WebServer" add the elb_settings, otherwise exclude them
  elb_settings_final = var.tier == "WebServer" ? var.loadbalancer_type == "application" ? concat(local.alb_settings, local.generic_elb_settings) : concat(local.classic_elb_settings, local.generic_elb_settings) : []
}

#
# Full list of options:
# http://docs.aws.amazon.com/elasticbeanstalk/latest/dg/command-options-general.html#command-options-general-elasticbeanstalkmanagedactionsplatformupdate
#
resource "aws_elastic_beanstalk_environment" "default" {
  name                   = module.label.id
  application            = var.elastic_beanstalk_application_name
  description            = var.description
  tier                   = var.tier
  solution_stack_name    = var.solution_stack_name
  wait_for_ready_timeout = var.wait_for_ready_timeout
  version_label          = var.version_label
  tags                   = local.tags

  dynamic "setting" {
    for_each = local.elb_settings_final
    content {
      namespace = setting.value["namespace"]
      name      = setting.value["name"]
      value     = setting.value["value"]
      resource  = ""
    }
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
    value     = var.vpc_id
    resource  = ""
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "AssociatePublicIpAddress"
    value     = var.associate_public_ip_address
    resource  = ""
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value     = join(",", sort(var.application_subnets))
    resource  = ""
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "SecurityGroups"
    value     = join(",", compact(sort(concat([aws_security_group.default.id], var.additional_security_groups))))
    resource  = ""
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.ec2.name
    resource  = ""
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name      = "Availability Zones"
    value     = var.availability_zone_selector
    resource  = ""
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "EnvironmentType"
    value     = var.environment_type
    resource  = ""
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "ServiceRole"
    value     = aws_iam_role.service.name
    resource  = ""
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "BASE_HOST"
    value     = var.name
    resource  = ""
  }

  setting {
    namespace = "aws:elasticbeanstalk:healthreporting:system"
    name      = "SystemType"
    value     = var.enhanced_reporting_enabled ? "enhanced" : "basic"
    resource  = ""
  }

  setting {
    namespace = "aws:elasticbeanstalk:managedactions"
    name      = "ManagedActionsEnabled"
    value     = var.managed_actions_enabled ? "true" : "false"
    resource  = ""
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MinSize"
    value     = var.autoscale_min
    resource  = ""
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MaxSize"
    value     = var.autoscale_max
    resource  = ""
  }

  setting {
    namespace = "aws:autoscaling:updatepolicy:rollingupdate"
    name      = "RollingUpdateEnabled"
    value     = var.rolling_update_enabled
    resource  = ""
  }

  setting {
    namespace = "aws:autoscaling:updatepolicy:rollingupdate"
    name      = "RollingUpdateType"
    value     = var.rolling_update_type
    resource  = ""
  }

  setting {
    namespace = "aws:autoscaling:updatepolicy:rollingupdate"
    name      = "MinInstancesInService"
    value     = var.updating_min_in_service
    resource  = ""
  }

  setting {
    namespace = "aws:elasticbeanstalk:command"
    name      = "DeploymentPolicy"
    value     = var.rolling_update_type == "Immutable" ? "Immutable" : "Rolling"
    resource  = ""
  }

  setting {
    namespace = "aws:autoscaling:updatepolicy:rollingupdate"
    name      = "MaxBatchSize"
    value     = var.updating_max_batch
    resource  = ""
  }

  setting {
    namespace = "aws:ec2:instances"
    name      = "InstanceTypes"
    value     = var.instance_type
    resource  = ""
  }

  setting {
    namespace = "aws:ec2:instances"
    name      = "EnableSpot"
    value     = var.enable_spot_instances ? "true" : "false"
    resource  = ""
  }

  setting {
    namespace = "aws:ec2:instances"
    name      = "SpotFleetOnDemandBase"
    value     = var.spot_fleet_on_demand_base
    resource  = ""
  }

  setting {
    namespace = "aws:ec2:instances"
    name      = "SpotFleetOnDemandAboveBasePercentage"
    value     = var.spot_fleet_on_demand_above_base_percentage == -1 ? (var.environment_type == "LoadBalanced" ? 70 : 0) : var.spot_fleet_on_demand_above_base_percentage
    resource  = ""
  }

  setting {
    namespace = "aws:ec2:instances"
    name      = "SpotMaxPrice"
    value     = var.spot_max_price == -1 ? "" : var.spot_max_price
    resource  = ""
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "EC2KeyName"
    value     = var.keypair
    resource  = ""
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "RootVolumeSize"
    value     = var.root_volume_size
    resource  = ""
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "RootVolumeType"
    value     = var.root_volume_type
    resource  = ""
  }

  dynamic "setting" {
    for_each = var.ami_id == null ? [] : [var.ami_id]
    content {
      namespace = "aws:autoscaling:launchconfiguration"
      name      = "ImageId"
      value     = setting.value
      resource  = ""
    }
  }

  setting {
    namespace = "aws:elasticbeanstalk:command"
    name      = "BatchSizeType"
    value     = var.deployment_batch_size_type
    resource  = ""
  }

  setting {
    namespace = "aws:elasticbeanstalk:command"
    name      = "BatchSize"
    value     = var.deployment_batch_size
    resource  = ""
  }

  setting {
    namespace = "aws:elasticbeanstalk:command"
    name      = "IgnoreHealthCheck"
    value     = var.deployment_ignore_health_check
    resource  = ""
  }

  setting {
    namespace = "aws:elasticbeanstalk:command"
    name      = "Timeout"
    value     = var.deployment_timeout
    resource  = ""
  }

  setting {
    namespace = "aws:elasticbeanstalk:managedactions"
    name      = "PreferredStartTime"
    value     = var.preferred_start_time
    resource  = ""
  }

  setting {
    namespace = "aws:elasticbeanstalk:managedactions:platformupdate"
    name      = "UpdateLevel"
    value     = var.update_level
    resource  = ""
  }

  setting {
    namespace = "aws:elasticbeanstalk:managedactions:platformupdate"
    name      = "InstanceRefreshEnabled"
    value     = var.instance_refresh_enabled
    resource  = ""
  }

  ###=========================== Autoscale trigger ========================== ###

  setting {
    namespace = "aws:autoscaling:trigger"
    name      = "MeasureName"
    value     = var.autoscale_measure_name
    resource  = ""
  }

  setting {
    namespace = "aws:autoscaling:trigger"
    name      = "Statistic"
    value     = var.autoscale_statistic
    resource  = ""
  }

  setting {
    namespace = "aws:autoscaling:trigger"
    name      = "Unit"
    value     = var.autoscale_unit
    resource  = ""
  }

  setting {
    namespace = "aws:autoscaling:trigger"
    name      = "LowerThreshold"
    value     = var.autoscale_lower_bound
    resource  = ""
  }

  setting {
    namespace = "aws:autoscaling:trigger"
    name      = "LowerBreachScaleIncrement"
    value     = var.autoscale_lower_increment
    resource  = ""
  }

  setting {
    namespace = "aws:autoscaling:trigger"
    name      = "UpperThreshold"
    value     = var.autoscale_upper_bound
    resource  = ""
  }

  setting {
    namespace = "aws:autoscaling:trigger"
    name      = "UpperBreachScaleIncrement"
    value     = var.autoscale_upper_increment
    resource  = ""
  }

  ###=========================== Logging ========================== ###

  setting {
    namespace = "aws:elasticbeanstalk:hostmanager"
    name      = "LogPublicationControl"
    value     = var.enable_log_publication_control ? "true" : "false"
    resource  = ""
  }

  setting {
    namespace = "aws:elasticbeanstalk:cloudwatch:logs"
    name      = "StreamLogs"
    value     = var.enable_stream_logs ? "true" : "false"
    resource  = ""
  }

  setting {
    namespace = "aws:elasticbeanstalk:cloudwatch:logs"
    name      = "DeleteOnTerminate"
    value     = var.logs_delete_on_terminate ? "true" : "false"
    resource  = ""
  }

  setting {
    namespace = "aws:elasticbeanstalk:cloudwatch:logs"
    name      = "RetentionInDays"
    value     = var.logs_retention_in_days
    resource  = ""
  }

  setting {
    namespace = "aws:elasticbeanstalk:cloudwatch:logs:health"
    name      = "HealthStreamingEnabled"
    value     = var.health_streaming_enabled ? "true" : "false"
    resource  = ""
  }

  setting {
    namespace = "aws:elasticbeanstalk:cloudwatch:logs:health"
    name      = "DeleteOnTerminate"
    value     = var.health_streaming_delete_on_terminate ? "true" : "false"
    resource  = ""
  }

  setting {
    namespace = "aws:elasticbeanstalk:cloudwatch:logs:health"
    name      = "RetentionInDays"
    value     = var.health_streaming_retention_in_days
    resource  = ""
  }

  // Add additional Elastic Beanstalk settings
  // For full list of options, see https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/command-options-general.html
  dynamic "setting" {
    for_each = var.additional_settings
    content {
      namespace = setting.value.namespace
      name      = setting.value.name
      value     = setting.value.value
      resource  = ""
    }
  }

  // dynamic needed as "spot max price" should only have a value if it is defined.
  dynamic "setting" {
    for_each = var.spot_max_price == -1 ? [] : [var.spot_max_price]
    content {
      namespace = "aws:ec2:instances"
      name      = "SpotMaxPrice"
      value     = var.spot_max_price
      resource  = ""
    }
  }

  // Add environment variables if provided
  dynamic "setting" {
    for_each = var.env_vars
    content {
      namespace = "aws:elasticbeanstalk:application:environment"
      name      = setting.key
      value     = setting.value
      resource  = ""
    }
  }
}

data "aws_elb_service_account" "main" {
  count = var.tier == "WebServer" && var.environment_type == "LoadBalanced" ? 1 : 0
}

data "aws_iam_policy_document" "elb_logs" {
  count = var.tier == "WebServer" && var.environment_type == "LoadBalanced" ? 1 : 0

  statement {
    sid = ""

    actions = [
      "s3:PutObject",
    ]

    resources = [
      "arn:aws:s3:::${module.label.id}-eb-loadbalancer-logs/*"
    ]

    principals {
      type        = "AWS"
      identifiers = [join("", data.aws_elb_service_account.main.*.arn)]
    }

    effect = "Allow"
  }
}

resource "aws_s3_bucket" "elb_logs" {
  count         = var.tier == "WebServer" && var.environment_type == "LoadBalanced" ? 1 : 0
  bucket        = "${module.label.id}-eb-loadbalancer-logs"
  acl           = "private"
  force_destroy = var.force_destroy
  policy        = join("", data.aws_iam_policy_document.elb_logs.*.json)
}

module "dns_hostname" {
  source  = "git::https://github.com/cloudposse/terraform-aws-route53-cluster-hostname.git?ref=tags/0.5.0"
  enabled = var.dns_zone_id != "" && var.tier == "WebServer" ? true : false
  name    = var.dns_subdomain != "" ? var.dns_subdomain : var.name
  zone_id = var.dns_zone_id
  records = [aws_elastic_beanstalk_environment.default.cname]
}
