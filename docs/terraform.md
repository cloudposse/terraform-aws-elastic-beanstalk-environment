
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| alb_zone_id | ALB zone id | string | `<map>` | no |
| app | EBS application name | string | - | yes |
| associate_public_ip_address | Specifies whether to launch instances in your VPC with public IP addresses. | string | `false` | no |
| attributes | Additional attributes (e.g. `1`) | list | `<list>` | no |
| autoscale_lower_bound | Minimum level of autoscale metric to add instance | string | `20` | no |
| autoscale_max | Maximum instances in charge | string | `3` | no |
| autoscale_min | Minumum instances in charge | string | `2` | no |
| autoscale_upper_bound | Maximum level of autoscale metric to remove instance | string | `80` | no |
| availability_zones | Choose the number of AZs for your instances | string | `Any 2` | no |
| config_document | A JSON document describing the environment and instance metrics to publish to CloudWatch. | string | `{ "CloudWatchMetrics": {}, "Version": 1}` | no |
| config_source | S3 source for config | string | `` | no |
| delimiter | Delimiter to be used between `name`, `namespace`, `stage`, etc. | string | `-` | no |
| enable_managed_actions | Enable managed platform updates.<br><br>When you set this to true, you must also specify a PreferredStartTime and UpdateLevel. | string | `true` | no |
| env_default_key | Default ENV variable key for Elastic Beanstalk `aws:elasticbeanstalk:application:environment` setting | string | `DEFAULT_ENV_%d` | no |
| env_default_value | Default ENV variable value for Elastic Beanstalk `aws:elasticbeanstalk:application:environment` setting | string | `UNSET` | no |
| env_vars | Map of custom ENV variables to be provided to the Jenkins application running on Elastic Beanstalk, e.g. `env_vars = { JENKINS_USER = 'admin' JENKINS_PASS = 'xxxxxx' }` | map | `<map>` | no |
| health_streaming_delete_on_terminate | Whether to delete the log group when the environment is terminated. If false, the health data is kept RetentionInDays days. | string | `false` | no |
| health_streaming_enabled | For environments with enhanced health reporting enabled, whether to create a group in CloudWatch Logs for environment health and archive Elastic Beanstalk environment health data. For information about enabling enhanced health, see aws:elasticbeanstalk:healthreporting:system. | string | `false` | no |
| health_streaming_retention_in_days | The number of days to keep the archived health data before it expires. | string | `7` | no |
| healthcheck_url | Application Health Check URL. Elastic Beanstalk will call this URL to check the health of the application running on EC2 instances | string | `/healthcheck` | no |
| http_listener_enabled | Enable port 80 (http) | string | `false` | no |
| instance_refresh_enabled | Enable weekly instance replacement. | string | `true` | no |
| instance_type | Instances type | string | `t2.micro` | no |
| keypair | Name of SSH key that will be deployed on Elastic Beanstalk and DataPipeline instance. The key should be present in AWS | string | - | yes |
| loadbalancer_certificate_arn | Load Balancer SSL certificate ARN. The certificate must be present in AWS Certificate Manager | string | `` | no |
| loadbalancer_managed_security_group | Load balancer managed security group | string | `` | no |
| loadbalancer_security_groups | Load balancer security groups | list | `<list>` | no |
| loadbalancer_type | Load Balancer type, e.g. 'application' or 'classic' | string | `classic` | no |
| name | Solution name, e.g. 'app' or 'jenkins' | string | `app` | no |
| namespace | Namespace, which could be your organization name, e.g. 'eg' or 'cp' | string | - | yes |
| notification_endpoint | Notification endpoint | string | `` | no |
| notification_protocol | Notification protocol | string | `email` | no |
| notification_topic_arn | Notification topic arn | string | `` | no |
| notification_topic_name | Notification topic name | string | `` | no |
| preferred_start_time | Configure a maintenance window for managed actions in UTC | string | `Sun:10:00` | no |
| private_subnets | List of private subnets to place EC2 instances | list | - | yes |
| public_subnets | List of public subnets to place Elastic Load Balancer | list | - | yes |
| rolling_update_type | Set it to Immutable to apply the configuration change to a fresh group of instances | string | `Health` | no |
| root_volume_size | The size of the EBS root volume | string | `8` | no |
| root_volume_type | The type of the EBS root volume | string | `gp2` | no |
| security_groups | List of security groups to be allowed to connect to the EC2 instances | list | - | yes |
| solution_stack_name | Elastic Beanstalk stack, e.g. Docker, Go, Node, Java, IIS. [Read more](http://docs.aws.amazon.com/elasticbeanstalk/latest/dg/concepts.platforms.html) | string | `` | no |
| ssh_listener_enabled | Enable ssh port | string | `false` | no |
| ssh_listener_port | SSH port | string | `22` | no |
| ssh_source_restriction | Used to lock down SSH access to the EC2 instances. | string | `0.0.0.0/0` | no |
| stage | Stage, e.g. 'prod', 'staging', 'dev', or 'test' | string | - | yes |
| tags | Additional tags (e.g. `map('BusinessUnit`,`XYZ`) | map | `<map>` | no |
| tier | Elastic Beanstalk Environment tier, e.g. ('WebServer', 'Worker') | string | `WebServer` | no |
| update_level | The highest level of update to apply with managed platform updates | string | `minor` | no |
| updating_max_batch | Maximum count of instances up during update | string | `1` | no |
| updating_min_in_service | Minimum count of instances up during update | string | `1` | no |
| version_label | Elastic Beanstalk Application version to deploy | string | `` | no |
| vpc_id | ID of the VPC in which to provision the AWS resources | string | - | yes |
| wait_for_ready_timeout |  | string | `20m` | no |
| zone_id | Route53 parent zone ID. The module will create sub-domain DNS records in the parent zone for the EB environment | string | `` | no |

## Outputs

| Name | Description |
|------|-------------|
| ec2_instance_profile_role_name | Instance IAM role name |
| elb_dns_name | ELB technical host |
| elb_zone_id | ELB zone id |
| host | DNS hostname |
| name | Name |
| security_group_id | Security group id |

