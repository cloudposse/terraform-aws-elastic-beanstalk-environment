variable "region" {
  type = string
}

variable "namespace" {
  type = string
}

variable "name" {
  type = string
}

variable "stage" {
  type = string
}

variable "max_availability_zones" {
  default = "2"
}

variable "zone_id" {
  type        = string
  description = "Route53 Zone ID"
}
