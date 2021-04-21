variable "region" {
  type        = string
  description = "AWS region"
}

variable "description" {
  type        = string
  default     = ""
  description = "Short description of the Environment"
}

variable "elastic_beanstalk_application_name" {
  type        = string
  description = "Elastic Beanstalk application name"
}

variable "environment_type" {
  type        = string
  default     = "LoadBalanced"
  description = "Environment type, e.g. 'LoadBalanced' or 'SingleInstance'.  If setting to 'SingleInstance', `rolling_update_type` must be set to 'Time', `updating_min_in_service` must be set to 0, and `loadbalancer_subnets` will be unused (it applies to the ELB, which does not exist in SingleInstance environments)"
}

variable "loadbalancer_type" {
  type        = string
  default     = "classic"
  description = "Load Balancer type, e.g. 'application' or 'classic'"
}

variable "loadbalancer_crosszone" {
  type        = bool
  default     = true
  description = "Configure the classic load balancer to route traffic evenly across all instances in all Availability Zones rather than only within each zone."
}

variable "loadbalancer_classic_connection_idle_timeout" {
  type        = number
  default     = 60
  description = "Classic load balancer only: Number of seconds that the load balancer waits for any data to be sent or received over the connection. If no data has been sent or received after this time period elapses, the load balancer closes the connection."
}

variable "dns_zone_id" {
  type        = string
  default     = ""
  description = "Route53 parent zone ID. The module will create sub-domain DNS record in the parent zone for the EB environment"
}

variable "dns_subdomain" {
  type        = string
  default     = ""
  description = "The subdomain to create on Route53 for the EB environment. For the subdomain to be created, the `dns_zone_id` variable must be set as well"
}

variable "allowed_security_groups" {
  type        = list(string)
  description = "List of security groups to add to the EC2 instances"
  default     = []
}

variable "additional_security_groups" {
  type        = list(string)
  description = "List of security groups to be allowed to connect to the EC2 instances"
  default     = []
}

variable "vpc_id" {
  type        = string
  description = "ID of the VPC in which to provision the AWS resources"
}

variable "loadbalancer_subnets" {
  type        = list(string)
  description = "List of subnets to place Elastic Load Balancer"
  default     = []
}

variable "application_subnets" {
  type        = list(string)
  description = "List of subnets to place EC2 instances"
}

variable "availability_zone_selector" {
  type        = string
  default     = "Any 2"
  description = "Availability Zone selector"
}

variable "instance_type" {
  type        = string
  default     = "t2.micro"
  description = "Instances type"
}

variable "enable_spot_instances" {
  type        = bool
  default     = false
  description = "Enable Spot Instance requests for your environment"
}

variable "spot_fleet_on_demand_base" {
  type        = number
  default     = 0
  description = "The minimum number of On-Demand Instances that your Auto Scaling group provisions before considering Spot Instances as your environment scales up. This option is relevant only when enable_spot_instances is true."
}

variable "spot_fleet_on_demand_above_base_percentage" {
  type        = number
  default     = -1
  description = "The percentage of On-Demand Instances as part of additional capacity that your Auto Scaling group provisions beyond the SpotOnDemandBase instances. This option is relevant only when enable_spot_instances is true."
}

variable "spot_max_price" {
  type        = number
  default     = -1
  description = "The maximum price per unit hour, in US$, that you're willing to pay for a Spot Instance. This option is relevant only when enable_spot_instances is true. Valid values are between 0.001 and 20.0"
}

variable "enhanced_reporting_enabled" {
  type        = bool
  default     = true
  description = "Whether to enable \"enhanced\" health reporting for this environment.  If false, \"basic\" reporting is used.  When you set this to false, you must also set `enable_managed_actions` to false"
}

variable "managed_actions_enabled" {
  type        = bool
  default     = true
  description = "Enable managed platform updates. When you set this to true, you must also specify a `PreferredStartTime` and `UpdateLevel`"
}

variable "autoscale_min" {
  type        = number
  default     = 2
  description = "Minumum instances to launch"
}

variable "autoscale_max" {
  type        = number
  default     = 3
  description = "Maximum instances to launch"
}

variable "solution_stack_name" {
  type        = string
  description = "Elastic Beanstalk stack, e.g. Docker, Go, Node, Java, IIS. For more info, see https://docs.aws.amazon.com/elasticbeanstalk/latest/platforms/platforms-supported.html"
}

variable "wait_for_ready_timeout" {
  type        = string
  default     = "20m"
  description = "The maximum duration to wait for the Elastic Beanstalk Environment to be in a ready state before timing out"
}

variable "associate_public_ip_address" {
  type        = bool
  default     = false
  description = "Whether to associate public IP addresses to the instances"
}

variable "tier" {
  type        = string
  default     = "WebServer"
  description = "Elastic Beanstalk Environment tier, 'WebServer' or 'Worker'"
}

variable "version_label" {
  type        = string
  default     = ""
  description = "Elastic Beanstalk Application version to deploy"
}

variable "force_destroy" {
  type        = bool
  default     = false
  description = "Force destroy the S3 bucket for load balancer logs"
}

variable "rolling_update_enabled" {
  type        = bool
  default     = true
  description = "Whether to enable rolling update"
}

variable "rolling_update_type" {
  type        = string
  default     = "Health"
  description = "`Health` or `Immutable`. Set it to `Immutable` to apply the configuration change to a fresh group of instances"
}

variable "updating_min_in_service" {
  type        = number
  default     = 1
  description = "Minimum number of instances in service during update"
}

variable "updating_max_batch" {
  type        = number
  default     = 1
  description = "Maximum number of instances to update at once"
}

variable "health_streaming_enabled" {
  type        = bool
  default     = false
  description = "For environments with enhanced health reporting enabled, whether to create a group in CloudWatch Logs for environment health and archive Elastic Beanstalk environment health data. For information about enabling enhanced health, see aws:elasticbeanstalk:healthreporting:system."
}

variable "health_streaming_delete_on_terminate" {
  type        = bool
  default     = false
  description = "Whether to delete the log group when the environment is terminated. If false, the health data is kept RetentionInDays days."
}

variable "health_streaming_retention_in_days" {
  type        = number
  default     = 7
  description = "The number of days to keep the archived health data before it expires."
}

variable "healthcheck_url" {
  type        = string
  default     = "/healthcheck"
  description = "Application Health Check URL. Elastic Beanstalk will call this URL to check the health of the application running on EC2 instances"
}

variable "enable_log_publication_control" {
  type        = bool
  default     = false
  description = "Copy the log files for your application's Amazon EC2 instances to the Amazon S3 bucket associated with your application"
}

variable "enable_stream_logs" {
  type        = bool
  default     = false
  description = "Whether to create groups in CloudWatch Logs for proxy and deployment logs, and stream logs from each instance in your environment"
}

variable "logs_delete_on_terminate" {
  type        = bool
  default     = false
  description = "Whether to delete the log groups when the environment is terminated. If false, the logs are kept RetentionInDays days"
}

variable "logs_retention_in_days" {
  type        = number
  default     = 7
  description = "The number of days to keep log events before they expire."
}

variable "loadbalancer_certificate_arn" {
  type        = string
  default     = ""
  description = "Load Balancer SSL certificate ARN. The certificate must be present in AWS Certificate Manager"
}

variable "loadbalancer_ssl_policy" {
  type        = string
  default     = ""
  description = "Specify a security policy to apply to the listener. This option is only applicable to environments with an application load balancer"
}

variable "loadbalancer_security_groups" {
  type        = list(string)
  default     = []
  description = "Load balancer security groups"
}

variable "loadbalancer_managed_security_group" {
  type        = string
  default     = ""
  description = "Load balancer managed security group"
}

variable "http_listener_enabled" {
  type        = bool
  default     = true
  description = "Enable port 80 (http)"
}

variable "application_port" {
  type        = number
  default     = 80
  description = "Port application is listening on"
}

variable "preferred_start_time" {
  type        = string
  default     = "Sun:10:00"
  description = "Configure a maintenance window for managed actions in UTC"
}

variable "update_level" {
  type        = string
  default     = "minor"
  description = "The highest level of update to apply with managed platform updates"
}

variable "instance_refresh_enabled" {
  type        = bool
  default     = true
  description = "Enable weekly instance replacement."
}

variable "keypair" {
  type        = string
  description = "Name of SSH key that will be deployed on Elastic Beanstalk and DataPipeline instance. The key should be present in AWS"
  default     = ""
}

variable "root_volume_size" {
  type        = number
  default     = 8
  description = "The size of the EBS root volume"
}

variable "root_volume_type" {
  type        = string
  default     = "gp2"
  description = "The type of the EBS root volume"
}

variable "autoscale_measure_name" {
  type        = string
  default     = "CPUUtilization"
  description = "Metric used for your Auto Scaling trigger"
}

variable "autoscale_statistic" {
  type        = string
  default     = "Average"
  description = "Statistic the trigger should use, such as Average"
}

variable "autoscale_unit" {
  type        = string
  default     = "Percent"
  description = "Unit for the trigger measurement, such as Bytes"
}

variable "autoscale_lower_bound" {
  type        = number
  default     = 20
  description = "Minimum level of autoscale metric to remove an instance"
}

variable "autoscale_lower_increment" {
  type        = number
  default     = -1
  description = "How many Amazon EC2 instances to remove when performing a scaling activity."
}

variable "autoscale_upper_bound" {
  type        = number
  default     = 80
  description = "Maximum level of autoscale metric to add an instance"
}

variable "autoscale_upper_increment" {
  type        = number
  default     = 1
  description = "How many Amazon EC2 instances to add when performing a scaling activity"
}

variable "elb_scheme" {
  type        = string
  default     = "public"
  description = "Specify `internal` if you want to create an internal load balancer in your Amazon VPC so that your Elastic Beanstalk application cannot be accessed from outside your Amazon VPC"
}

variable "ssh_source_restriction" {
  type        = string
  default     = "0.0.0.0/0"
  description = "Used to lock down SSH access to the EC2 instances"
}

variable "ssh_listener_enabled" {
  type        = bool
  default     = false
  description = "Enable SSH port"
}

variable "ssh_listener_port" {
  type        = number
  default     = 22
  description = "SSH port"
}

variable "additional_settings" {
  type = list(object({
    namespace = string
    name      = string
    value     = string
  }))

  default     = []
  description = "Additional Elastic Beanstalk setttings. For full list of options, see https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/command-options-general.html"
}

variable "env_vars" {
  type        = map(string)
  default     = {}
  description = "Map of custom ENV variables to be provided to the application running on Elastic Beanstalk, e.g. env_vars = { DB_USER = 'admin' DB_PASS = 'xxxxxx' }"
}

# From: http://docs.aws.amazon.com/general/latest/gr/rande.html#elasticbeanstalk_region
# Via: https://github.com/hashicorp/terraform/issues/7071
variable "alb_zone_id" {
  type = map(string)

  default = {
    ap-northeast-1 = "Z1R25G3KIG2GBW"
    ap-northeast-2 = "Z3JE5OI70TWKCP"
    ap-south-1     = "Z18NTBI3Y7N9TZ"
    ap-southeast-1 = "Z16FZ9L249IFLT"
    ap-southeast-2 = "Z2PCDNR3VC2G1N"
    ca-central-1   = "ZJFCZL7SSZB5I"
    eu-central-1   = "Z1FRNW7UH4DEZJ"
    eu-west-1      = "Z2NYPWQ7DFZAZH"
    eu-west-2      = "Z1GKAAAUGATPF1"
    sa-east-1      = "Z10X7K2B4QSOFV"
    us-east-1      = "Z117KPS5GTRQ2G"
    us-east-2      = "Z14LCN19Q5QHIC"
    us-west-1      = "Z1LQECGX5PH1X"
    us-west-2      = "Z38NKT9BP95V3O"
    eu-west-3      = "Z3Q77PNBQS71R4"
    af-south-1     = "Z1EI3BVKMKK4AM"
    ap-east-1      = "ZPWYUBWRU171A"
    eu-central-1   = "Z1FRNW7UH4DEZJ"
    eu-south-1     = "Z10VDYYOA2JFKM"
    eu-north-1     = "Z23GO28BZ5AETM"
    me-south-1     = "Z2BBTEKR2I36N2"
    sa-east-1      = "Z10X7K2B4QSOFV"
    us-gov-west-1  = "Z31GFT0UA1I2HV"
    us-gov-east-1  = "Z2NIFVYYW2VKV1"
  }

  description = "ALB zone id"
}

variable "ami_id" {
  type        = string
  default     = null
  description = "The id of the AMI to associate with the Amazon EC2 instances"
}

variable "deployment_batch_size_type" {
  type        = string
  default     = "Fixed"
  description = "The type of number that is specified in deployment_batch_size_type"
}

variable "deployment_batch_size" {
  type        = number
  default     = 1
  description = "Percentage or fixed number of Amazon EC2 instances in the Auto Scaling group on which to simultaneously perform deployments. Valid values vary per deployment_batch_size_type setting"
}

variable "deployment_ignore_health_check" {
  type        = bool
  default     = false
  description = "Do not cancel a deployment due to failed health checks"
}

variable "deployment_timeout" {
  type        = number
  default     = 600
  description = "Number of seconds to wait for an instance to complete executing commands"
}

variable "extended_ec2_policy_document" {
  type        = string
  default     = "{}"
  description = "Extensions or overrides for the IAM role assigned to EC2 instances"
}

variable "prefer_legacy_ssm_policy" {
  type        = bool
  default     = true
  description = "Whether to use AmazonEC2RoleforSSM (will soon be deprecated) or AmazonSSMManagedInstanceCore policy"
}

variable "prefer_legacy_service_policy" {
  type        = bool
  default     = true
  description = "Whether to use AWSElasticBeanstalkService (deprecated) or AWSElasticBeanstalkManagedUpdatesCustomerRolePolicy policy"
}

variable "s3_bucket_access_log_bucket_name" {
  type        = string
  default     = ""
  description = "Name of the S3 bucket where s3 access log will be sent to"
}

variable "s3_bucket_versioning_enabled" {
  type        = bool
  default     = true
  description = "When set to 'true' the s3 origin bucket will have versioning enabled"
}

variable "s3_bucket_encryption_enabled" {
  type        = bool
  default     = true
  description = "When set to 'true' the resource will have aes256 encryption enabled by default"
}

variable "scheduled_actions" {
  type = list(object({
    name            = string
    minsize         = string
    maxsize         = string
    desiredcapacity = string
    starttime       = string
    endtime         = string
    recurrence      = string
    suspend         = bool
  }))
  default     = []
  description = "Define a list of scheduled actions"
}
