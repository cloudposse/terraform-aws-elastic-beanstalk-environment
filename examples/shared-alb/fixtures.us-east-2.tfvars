region = "us-east-2"

availability_zones = ["us-east-2a", "us-east-2b"]

namespace = "eg"

stage = "test"

name = "eb-env-shared-alb"

description = "Test elastic-beanstalk-environment"

tier = "WebServer"

environment_type = "LoadBalanced"

loadbalancer_type = "application"

loadbalancer_is_shared = true

availability_zone_selector = "Any 2"

instance_type = "t3.micro"

autoscale_min = 1

autoscale_max = 2

wait_for_ready_timeout = "20m"

force_destroy = true

rolling_update_enabled = true

rolling_update_type = "Health"

updating_min_in_service = 0

updating_max_batch = 1

root_volume_size = 8

root_volume_type = "gp2"

autoscale_measure_name = "CPUUtilization"

autoscale_statistic = "Average"

autoscale_unit = "Percent"

autoscale_lower_bound = 20

autoscale_lower_increment = -1

autoscale_upper_bound = 80

autoscale_upper_increment = 1

// https://docs.aws.amazon.com/elasticbeanstalk/latest/platforms/platforms-supported.html
// https://docs.aws.amazon.com/elasticbeanstalk/latest/platforms/platforms-supported.html#platforms-supported.docker
solution_stack_name = "64bit Amazon Linux 2023 v4.0.1 running Python 3.11"

version_label = ""

dns_zone_id = ""

// https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/command-options-general.html
additional_settings = [
  {
    namespace = "aws:elasticbeanstalk:managedactions"
    name      = "ManagedActionsEnabled"
    value     = "false"
  }
]

env_vars = {
  "DB_HOST"         = "xxxxxxxxxxxxxx"
  "DB_USERNAME"     = "yyyyyyyyyyyyy"
  "DB_PASSWORD"     = "zzzzzzzzzzzzzzzzzzz"
  "ANOTHER_ENV_VAR" = "123456789"
}

// https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/environments-cfg-autoscaling-scheduledactions.html
scheduled_actions = [
  {
    name            = "Refreshinstances"
    minsize         = "1"
    maxsize         = "2"
    desiredcapacity = "2"
    starttime       = "2015-05-14T07:00:00Z"
    endtime         = "2025-01-12T07:00:00Z"
    recurrence      = "*/20 * * * *"
    suspend         = false
  }
]
