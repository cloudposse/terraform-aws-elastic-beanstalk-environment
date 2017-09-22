variable "namespace" {
  default = "global"
}

variable "stage" {
  default = "default"
}

variable "name" {
  default = "app"
}

variable "healthcheck_url" {
  default = "/healthcheck"
}

variable "loadbalancer_type" {
  default = "classic"
}

variable "loadbalancer_certificate_arn" {
  default = ""
}

variable "http_listen_always" {
  default = false
}


variable "zone_id" {
  default = ""
}

variable "config_source" {
  default = ""
}

variable "security_groups" {
  type = "list"
}

variable "app" {}

variable "vpc_id" {}

variable "public_subnets" {
  type = "list"
}

variable "private_subnets" {
  type = "list"
}

variable "keypair" {}

variable "updating_min_in_service" {
  default = "1"
}

variable "updating_max_batch" {
  default = "1"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "autoscale_lower_bound" {
  default = "20"
}

variable "autoscale_upper_bound" {
  default = "80"
}

variable "autoscale_min" {
  default = "2"
}

variable "autoscale_max" {
  default = "3"
}

variable "solution_stack_name" {
  default = ""
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
}

variable "delimiter" {
  type    = "string"
  default = "-"
}

variable "attributes" {
  type    = "list"
  default = []
}

variable "tags" {
  type    = "map"
  default = {}
}

variable "env_default_key" {
  default = "DEFAULT_ENV_%d"
}

variable "env_default_value" {
  default = "UNSET"
}

variable "env_vars" {
  default = {}
  type    = "map"
}
