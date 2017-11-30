variable "namespace" {
  default = "global"
  description = "Namespace"
}

variable "stage" {
  default = "default"
  description = "Staging"
}

variable "delimiter" {
  type    = "string"
  default = "-"
  description = "Delimeter for naming"
}

variable "attributes" {
  type    = "list"
  default = []
  description = "Attributes for naming"
}

variable "name" {
  default = "app"
  description = "Name"
}

variable "healthcheck_url" {
  default = "/healthcheck"
  description = "Healthcheck url"
}

variable "notification_protocol" {
  default = "email"
  description = "Notification protocol"
}

variable "notification_endpoint" {
  default = ""
  description = "Notification endpoint"
}

variable "notification_topic_arn" {
  default = ""
  description = "Notification arn topic"
}

variable "notification_topic_name" {
  default = ""
  description = "Notification topic name"
}

variable "loadbalancer_type" {
  default = "classic"
  description = "Loadbalancer type"
}

variable "loadbalancer_certificate_arn" {
  default = ""
  description = "Loadbalancer https certificate arn"
}

variable "http_listener_enabled" {
  default = "false"
  description = "Enable port 80 (http)"
}

variable "ssh_listener_enabled" {
  default = "false"
  description = "Enable ssh port"
}

variable "ssh_listener_port" {
  default = "22"
  description = "SSH port"
}

variable "zone_id" {
  default = ""
  description = "DNS zone id"
}

variable "config_source" {
  default = ""
  description = "S3 source for config"
}

variable "security_groups" {
  type = "list"
  description = "Security groups"
}

variable "app" {
  description = "Application name"
}

variable "vpc_id" {
  description = "VPC id"
}

variable "public_subnets" {
  type = "list"
  description = "Public subnets for lb"
}

variable "private_subnets" {
  type = "list"
  description = "Private subnets for instances"
}

variable "keypair" {
  description = "SSH keypair name for instances"
}

variable "updating_min_in_service" {
  default = "1"
  description = "Minimum count of instances up during update"
}

variable "updating_max_batch" {
  default = "1"
  description = "Maximum count of instances up during update"
}

variable "instance_type" {
  default = "t2.micro"
  description = "Instances type"
}

variable "autoscale_lower_bound" {
  default = "20"
  description = "Minimum level of autoscale metric to add instance"
}

variable "autoscale_upper_bound" {
  default = "80"
  description = "Maximum level of autoscale metric to remove instance"
}

variable "autoscale_min" {
  default = "2"
  description = "Minumum instances in charge"
}

variable "autoscale_max" {
  default = "3"
  description = "Maximum instances in charge"
}

variable "solution_stack_name" {
  default = ""
  description = "Solution stack name"
}

# From: http://docs.aws.amazon.com/general/latest/gr/rande.html#elasticbeanstalk_region
# Via: https://github.com/hashicorp/terraform/issues/7071
variable "alb_zone_id" {
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
  }
  description = "ALB zone id"
}

variable "tags" {
  type    = "map"
  default = {}
  description = "Tags"
}

variable "env_default_key" {
  default = "DEFAULT_ENV_%d"
  description = "Empty environment variable name"
}

variable "env_default_value" {
  default = "UNSET"
  description = "Empty environment variable value"
}

variable "env_vars" {
  default = {}
  type    = "map"
  description = "Environment variables"
}
