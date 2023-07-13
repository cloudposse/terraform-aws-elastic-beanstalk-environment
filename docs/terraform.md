<!-- markdownlint-disable -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.5.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.0 |
| <a name="provider_random"></a> [random](#provider\_random) | >= 3.5.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_aws_security_group"></a> [aws\_security\_group](#module\_aws\_security\_group) | cloudposse/security-group/aws | 1.0.1 |
| <a name="module_dns_hostname"></a> [dns\_hostname](#module\_dns\_hostname) | cloudposse/route53-cluster-hostname/aws | 0.12.2 |
| <a name="module_elb_logs"></a> [elb\_logs](#module\_elb\_logs) | cloudposse/lb-s3-bucket/aws | 0.19.0 |
| <a name="module_this"></a> [this](#module\_this) | cloudposse/label/null | 0.25.0 |

## Resources

| Name | Type |
|------|------|
| [aws_elastic_beanstalk_environment.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elastic_beanstalk_environment) | resource |
| [aws_iam_instance_profile.ec2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_role.ec2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.service](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.ecr_readonly](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.elastic_beanstalk_multi_container_docker](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.enhanced_health](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.service](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.ssm_automation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.ssm_ec2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.web_tier](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.worker_tier](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_lb_listener_rule.redirect_http_to_https](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener_rule) | resource |
| [aws_ssm_activation.ec2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_activation) | resource |
| [random_string.elb_logs_suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [aws_iam_policy_document.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.ec2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.extended](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.service](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_lb_listener.http](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/lb_listener) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_security_group_rules"></a> [additional\_security\_group\_rules](#input\_additional\_security\_group\_rules) | A list of Security Group rule objects to add to the created security group, in addition to the ones<br>this module normally creates. (To suppress the module's rules, set `create_security_group` to false<br>and supply your own security group via `associated_security_group_ids`.)<br>The keys and values of the objects are fully compatible with the `aws_security_group_rule` resource, except<br>for `security_group_id` which will be ignored, and the optional "key" which, if provided, must be unique and known at "plan" time.<br>To get more info see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule . | `list(any)` | `[]` | no |
| <a name="input_additional_settings"></a> [additional\_settings](#input\_additional\_settings) | Additional Elastic Beanstalk setttings. For full list of options, see https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/command-options-general.html | <pre>list(object({<br>    namespace = string<br>    name      = string<br>    value     = string<br>  }))</pre> | `[]` | no |
| <a name="input_additional_tag_map"></a> [additional\_tag\_map](#input\_additional\_tag\_map) | Additional key-value pairs to add to each map in `tags_as_list_of_maps`. Not added to `tags` or `id`.<br>This is for some rare cases where resources want additional configuration of tags<br>and therefore take a list of maps with tag key, value, and additional configuration. | `map(string)` | `{}` | no |
| <a name="input_alb_zone_id"></a> [alb\_zone\_id](#input\_alb\_zone\_id) | ALB zone id | `map(string)` | <pre>{<br>  "af-south-1": "Z1EI3BVKMKK4AM",<br>  "ap-east-1": "ZPWYUBWRU171A",<br>  "ap-northeast-1": "Z1R25G3KIG2GBW",<br>  "ap-northeast-2": "Z3JE5OI70TWKCP",<br>  "ap-south-1": "Z18NTBI3Y7N9TZ",<br>  "ap-southeast-1": "Z16FZ9L249IFLT",<br>  "ap-southeast-2": "Z2PCDNR3VC2G1N",<br>  "ca-central-1": "ZJFCZL7SSZB5I",<br>  "eu-central-1": "Z1FRNW7UH4DEZJ",<br>  "eu-north-1": "Z23GO28BZ5AETM",<br>  "eu-south-1": "Z10VDYYOA2JFKM",<br>  "eu-west-1": "Z2NYPWQ7DFZAZH",<br>  "eu-west-2": "Z1GKAAAUGATPF1",<br>  "eu-west-3": "Z3Q77PNBQS71R4",<br>  "me-south-1": "Z2BBTEKR2I36N2",<br>  "sa-east-1": "Z10X7K2B4QSOFV",<br>  "us-east-1": "Z117KPS5GTRQ2G",<br>  "us-east-2": "Z14LCN19Q5QHIC",<br>  "us-gov-east-1": "Z2NIFVYYW2VKV1",<br>  "us-gov-west-1": "Z31GFT0UA1I2HV",<br>  "us-west-1": "Z1LQECGX5PH1X",<br>  "us-west-2": "Z38NKT9BP95V3O"<br>}</pre> | no |
| <a name="input_allow_all_egress"></a> [allow\_all\_egress](#input\_allow\_all\_egress) | If `true`, the created security group will allow egress on all ports and protocols to all IP addresses.<br>If this is false and no egress rules are otherwise specified, then no egress will be allowed. | `bool` | `true` | no |
| <a name="input_ami_id"></a> [ami\_id](#input\_ami\_id) | The id of the AMI to associate with the Amazon EC2 instances | `string` | `null` | no |
| <a name="input_application_port"></a> [application\_port](#input\_application\_port) | Port application is listening on | `number` | `80` | no |
| <a name="input_application_subnets"></a> [application\_subnets](#input\_application\_subnets) | List of subnets to place EC2 instances | `list(string)` | n/a | yes |
| <a name="input_associate_public_ip_address"></a> [associate\_public\_ip\_address](#input\_associate\_public\_ip\_address) | Whether to associate public IP addresses to the instances | `bool` | `false` | no |
| <a name="input_associated_security_group_ids"></a> [associated\_security\_group\_ids](#input\_associated\_security\_group\_ids) | A list of IDs of Security Groups to associate the created resource with, in addition to the created security group.<br>These security groups will not be modified and, if `create_security_group` is `false`, must have rules providing the desired access. | `list(string)` | `[]` | no |
| <a name="input_attributes"></a> [attributes](#input\_attributes) | ID element. Additional attributes (e.g. `workers` or `cluster`) to add to `id`,<br>in the order they appear in the list. New attributes are appended to the<br>end of the list. The elements of the list are joined by the `delimiter`<br>and treated as a single ID element. | `list(string)` | `[]` | no |
| <a name="input_autoscale_lower_bound"></a> [autoscale\_lower\_bound](#input\_autoscale\_lower\_bound) | Minimum level of autoscale metric to remove an instance | `number` | `20` | no |
| <a name="input_autoscale_lower_increment"></a> [autoscale\_lower\_increment](#input\_autoscale\_lower\_increment) | How many Amazon EC2 instances to remove when performing a scaling activity. | `number` | `-1` | no |
| <a name="input_autoscale_max"></a> [autoscale\_max](#input\_autoscale\_max) | Maximum instances to launch | `number` | `3` | no |
| <a name="input_autoscale_measure_name"></a> [autoscale\_measure\_name](#input\_autoscale\_measure\_name) | Metric used for your Auto Scaling trigger | `string` | `"CPUUtilization"` | no |
| <a name="input_autoscale_min"></a> [autoscale\_min](#input\_autoscale\_min) | Minumum instances to launch | `number` | `2` | no |
| <a name="input_autoscale_statistic"></a> [autoscale\_statistic](#input\_autoscale\_statistic) | Statistic the trigger should use, such as Average | `string` | `"Average"` | no |
| <a name="input_autoscale_unit"></a> [autoscale\_unit](#input\_autoscale\_unit) | Unit for the trigger measurement, such as Bytes | `string` | `"Percent"` | no |
| <a name="input_autoscale_upper_bound"></a> [autoscale\_upper\_bound](#input\_autoscale\_upper\_bound) | Maximum level of autoscale metric to add an instance | `number` | `80` | no |
| <a name="input_autoscale_upper_increment"></a> [autoscale\_upper\_increment](#input\_autoscale\_upper\_increment) | How many Amazon EC2 instances to add when performing a scaling activity | `number` | `1` | no |
| <a name="input_availability_zone_selector"></a> [availability\_zone\_selector](#input\_availability\_zone\_selector) | Availability Zone selector | `string` | `"Any 2"` | no |
| <a name="input_context"></a> [context](#input\_context) | Single object for setting entire context at once.<br>See description of individual variables for details.<br>Leave string and numeric variables as `null` to use default value.<br>Individual variable settings (non-null) override settings in context object,<br>except for attributes, tags, and additional\_tag\_map, which are merged. | `any` | <pre>{<br>  "additional_tag_map": {},<br>  "attributes": [],<br>  "delimiter": null,<br>  "descriptor_formats": {},<br>  "enabled": true,<br>  "environment": null,<br>  "id_length_limit": null,<br>  "label_key_case": null,<br>  "label_order": [],<br>  "label_value_case": null,<br>  "labels_as_tags": [<br>    "unset"<br>  ],<br>  "name": null,<br>  "namespace": null,<br>  "regex_replace_chars": null,<br>  "stage": null,<br>  "tags": {},<br>  "tenant": null<br>}</pre> | no |
| <a name="input_create_security_group"></a> [create\_security\_group](#input\_create\_security\_group) | Set `true` to create and configure a Security Group for the cluster. | `bool` | `true` | no |
| <a name="input_delimiter"></a> [delimiter](#input\_delimiter) | Delimiter to be used between ID elements.<br>Defaults to `-` (hyphen). Set to `""` to use no delimiter at all. | `string` | `null` | no |
| <a name="input_deployment_batch_size"></a> [deployment\_batch\_size](#input\_deployment\_batch\_size) | Percentage or fixed number of Amazon EC2 instances in the Auto Scaling group on which to simultaneously perform deployments. Valid values vary per deployment\_batch\_size\_type setting | `number` | `1` | no |
| <a name="input_deployment_batch_size_type"></a> [deployment\_batch\_size\_type](#input\_deployment\_batch\_size\_type) | The type of number that is specified in deployment\_batch\_size\_type | `string` | `"Fixed"` | no |
| <a name="input_deployment_ignore_health_check"></a> [deployment\_ignore\_health\_check](#input\_deployment\_ignore\_health\_check) | Do not cancel a deployment due to failed health checks | `bool` | `false` | no |
| <a name="input_deployment_policy"></a> [deployment\_policy](#input\_deployment\_policy) | Use the DeploymentPolicy option to set the deployment type. The following values are supported: `AllAtOnce`, `Rolling`, `RollingWithAdditionalBatch`, `Immutable`, `TrafficSplitting` | `string` | `"Rolling"` | no |
| <a name="input_deployment_timeout"></a> [deployment\_timeout](#input\_deployment\_timeout) | Number of seconds to wait for an instance to complete executing commands | `number` | `600` | no |
| <a name="input_description"></a> [description](#input\_description) | Short description of the Environment | `string` | `""` | no |
| <a name="input_descriptor_formats"></a> [descriptor\_formats](#input\_descriptor\_formats) | Describe additional descriptors to be output in the `descriptors` output map.<br>Map of maps. Keys are names of descriptors. Values are maps of the form<br>`{<br>   format = string<br>   labels = list(string)<br>}`<br>(Type is `any` so the map values can later be enhanced to provide additional options.)<br>`format` is a Terraform format string to be passed to the `format()` function.<br>`labels` is a list of labels, in order, to pass to `format()` function.<br>Label values will be normalized before being passed to `format()` so they will be<br>identical to how they appear in `id`.<br>Default is `{}` (`descriptors` output will be empty). | `any` | `{}` | no |
| <a name="input_dns_subdomain"></a> [dns\_subdomain](#input\_dns\_subdomain) | The subdomain to create on Route53 for the EB environment. For the subdomain to be created, the `dns_zone_id` variable must be set as well | `string` | `""` | no |
| <a name="input_dns_zone_id"></a> [dns\_zone\_id](#input\_dns\_zone\_id) | Route53 parent zone ID. The module will create sub-domain DNS record in the parent zone for the EB environment | `string` | `""` | no |
| <a name="input_elastic_beanstalk_application_name"></a> [elastic\_beanstalk\_application\_name](#input\_elastic\_beanstalk\_application\_name) | Elastic Beanstalk application name | `string` | n/a | yes |
| <a name="input_elb_scheme"></a> [elb\_scheme](#input\_elb\_scheme) | Specify `internal` if you want to create an internal load balancer in your Amazon VPC so that your Elastic Beanstalk application cannot be accessed from outside your Amazon VPC | `string` | `"public"` | no |
| <a name="input_enable_capacity_rebalancing"></a> [enable\_capacity\_rebalancing](#input\_enable\_capacity\_rebalancing) | Specifies whether to enable the Capacity Rebalancing feature for Spot Instances in your Auto Scaling Group | `bool` | `false` | no |
| <a name="input_enable_loadbalancer_logs"></a> [enable\_loadbalancer\_logs](#input\_enable\_loadbalancer\_logs) | Whether to enable Load Balancer Logging to the S3 bucket. | `bool` | `true` | no |
| <a name="input_enable_log_publication_control"></a> [enable\_log\_publication\_control](#input\_enable\_log\_publication\_control) | Copy the log files for your application's Amazon EC2 instances to the Amazon S3 bucket associated with your application | `bool` | `false` | no |
| <a name="input_enable_spot_instances"></a> [enable\_spot\_instances](#input\_enable\_spot\_instances) | Enable Spot Instance requests for your environment | `bool` | `false` | no |
| <a name="input_enable_stream_logs"></a> [enable\_stream\_logs](#input\_enable\_stream\_logs) | Whether to create groups in CloudWatch Logs for proxy and deployment logs, and stream logs from each instance in your environment | `bool` | `false` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Set to false to prevent the module from creating any resources | `bool` | `null` | no |
| <a name="input_enhanced_reporting_enabled"></a> [enhanced\_reporting\_enabled](#input\_enhanced\_reporting\_enabled) | Whether to enable "enhanced" health reporting for this environment.  If false, "basic" reporting is used.  When you set this to false, you must also set `enable_managed_actions` to false | `bool` | `true` | no |
| <a name="input_env_vars"></a> [env\_vars](#input\_env\_vars) | Map of custom ENV variables to be provided to the application running on Elastic Beanstalk, e.g. env\_vars = { DB\_USER = 'admin' DB\_PASS = 'xxxxxx' } | `map(string)` | `{}` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | ID element. Usually used for region e.g. 'uw2', 'us-west-2', OR role 'prod', 'staging', 'dev', 'UAT' | `string` | `null` | no |
| <a name="input_environment_type"></a> [environment\_type](#input\_environment\_type) | Environment type, e.g. 'LoadBalanced' or 'SingleInstance'.  If setting to 'SingleInstance', `rolling_update_type` must be set to 'Time', `updating_min_in_service` must be set to 0, and `loadbalancer_subnets` will be unused (it applies to the ELB, which does not exist in SingleInstance environments) | `string` | `"LoadBalanced"` | no |
| <a name="input_extended_ec2_policy_document"></a> [extended\_ec2\_policy\_document](#input\_extended\_ec2\_policy\_document) | Extensions or overrides for the IAM role assigned to EC2 instances | `string` | `""` | no |
| <a name="input_force_destroy"></a> [force\_destroy](#input\_force\_destroy) | Force destroy the S3 bucket for load balancer logs | `bool` | `false` | no |
| <a name="input_health_streaming_delete_on_terminate"></a> [health\_streaming\_delete\_on\_terminate](#input\_health\_streaming\_delete\_on\_terminate) | Whether to delete the log group when the environment is terminated. If false, the health data is kept RetentionInDays days. | `bool` | `false` | no |
| <a name="input_health_streaming_enabled"></a> [health\_streaming\_enabled](#input\_health\_streaming\_enabled) | For environments with enhanced health reporting enabled, whether to create a group in CloudWatch Logs for environment health and archive Elastic Beanstalk environment health data. For information about enabling enhanced health, see aws:elasticbeanstalk:healthreporting:system. | `bool` | `false` | no |
| <a name="input_health_streaming_retention_in_days"></a> [health\_streaming\_retention\_in\_days](#input\_health\_streaming\_retention\_in\_days) | The number of days to keep the archived health data before it expires. | `number` | `7` | no |
| <a name="input_healthcheck_healthy_threshold_count"></a> [healthcheck\_healthy\_threshold\_count](#input\_healthcheck\_healthy\_threshold\_count) | The number of consecutive successful requests before Elastic Load Balancing changes the instance health status | `number` | `3` | no |
| <a name="input_healthcheck_httpcodes_to_match"></a> [healthcheck\_httpcodes\_to\_match](#input\_healthcheck\_httpcodes\_to\_match) | List of HTTP codes that indicate that an instance is healthy. Note that this option is only applicable to environments with a network or application load balancer | `list(string)` | <pre>[<br>  "200"<br>]</pre> | no |
| <a name="input_healthcheck_interval"></a> [healthcheck\_interval](#input\_healthcheck\_interval) | The interval of time, in seconds, that Elastic Load Balancing checks the health of the Amazon EC2 instances of your application | `number` | `10` | no |
| <a name="input_healthcheck_timeout"></a> [healthcheck\_timeout](#input\_healthcheck\_timeout) | The amount of time, in seconds, to wait for a response during a health check. Note that this option is only applicable to environments with an application load balancer | `number` | `5` | no |
| <a name="input_healthcheck_unhealthy_threshold_count"></a> [healthcheck\_unhealthy\_threshold\_count](#input\_healthcheck\_unhealthy\_threshold\_count) | The number of consecutive unsuccessful requests before Elastic Load Balancing changes the instance health status | `number` | `3` | no |
| <a name="input_healthcheck_url"></a> [healthcheck\_url](#input\_healthcheck\_url) | Application Health Check URL. Elastic Beanstalk will call this URL to check the health of the application running on EC2 instances | `string` | `"/"` | no |
| <a name="input_http_listener_enabled"></a> [http\_listener\_enabled](#input\_http\_listener\_enabled) | Enable port 80 (http) | `bool` | `true` | no |
| <a name="input_id_length_limit"></a> [id\_length\_limit](#input\_id\_length\_limit) | Limit `id` to this many characters (minimum 6).<br>Set to `0` for unlimited length.<br>Set to `null` for keep the existing setting, which defaults to `0`.<br>Does not affect `id_full`. | `number` | `null` | no |
| <a name="input_instance_refresh_enabled"></a> [instance\_refresh\_enabled](#input\_instance\_refresh\_enabled) | Enable weekly instance replacement. | `bool` | `true` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | Instances type | `string` | `"t2.micro"` | no |
| <a name="input_keypair"></a> [keypair](#input\_keypair) | Name of SSH key that will be deployed on Elastic Beanstalk and DataPipeline instance. The key should be present in AWS | `string` | `""` | no |
| <a name="input_label_key_case"></a> [label\_key\_case](#input\_label\_key\_case) | Controls the letter case of the `tags` keys (label names) for tags generated by this module.<br>Does not affect keys of tags passed in via the `tags` input.<br>Possible values: `lower`, `title`, `upper`.<br>Default value: `title`. | `string` | `null` | no |
| <a name="input_label_order"></a> [label\_order](#input\_label\_order) | The order in which the labels (ID elements) appear in the `id`.<br>Defaults to ["namespace", "environment", "stage", "name", "attributes"].<br>You can omit any of the 6 labels ("tenant" is the 6th), but at least one must be present. | `list(string)` | `null` | no |
| <a name="input_label_value_case"></a> [label\_value\_case](#input\_label\_value\_case) | Controls the letter case of ID elements (labels) as included in `id`,<br>set as tag values, and output by this module individually.<br>Does not affect values of tags passed in via the `tags` input.<br>Possible values: `lower`, `title`, `upper` and `none` (no transformation).<br>Set this to `title` and set `delimiter` to `""` to yield Pascal Case IDs.<br>Default value: `lower`. | `string` | `null` | no |
| <a name="input_labels_as_tags"></a> [labels\_as\_tags](#input\_labels\_as\_tags) | Set of labels (ID elements) to include as tags in the `tags` output.<br>Default is to include all labels.<br>Tags with empty values will not be included in the `tags` output.<br>Set to `[]` to suppress all generated tags.<br>**Notes:**<br>  The value of the `name` tag, if included, will be the `id`, not the `name`.<br>  Unlike other `null-label` inputs, the initial setting of `labels_as_tags` cannot be<br>  changed in later chained modules. Attempts to change it will be silently ignored. | `set(string)` | <pre>[<br>  "default"<br>]</pre> | no |
| <a name="input_loadbalancer_certificate_arn"></a> [loadbalancer\_certificate\_arn](#input\_loadbalancer\_certificate\_arn) | Load Balancer SSL certificate ARN. The certificate must be present in AWS Certificate Manager | `string` | `""` | no |
| <a name="input_loadbalancer_connection_idle_timeout"></a> [loadbalancer\_connection\_idle\_timeout](#input\_loadbalancer\_connection\_idle\_timeout) | Classic load balancer only: Number of seconds that the load balancer waits for any data to be sent or received over the connection. If no data has been sent or received after this time period elapses, the load balancer closes the connection. | `number` | `60` | no |
| <a name="input_loadbalancer_crosszone"></a> [loadbalancer\_crosszone](#input\_loadbalancer\_crosszone) | Configure the classic load balancer to route traffic evenly across all instances in all Availability Zones rather than only within each zone. | `bool` | `true` | no |
| <a name="input_loadbalancer_is_shared"></a> [loadbalancer\_is\_shared](#input\_loadbalancer\_is\_shared) | Flag to create a shared application loadbalancer. Only when loadbalancer\_type = "application" https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/environments-cfg-alb-shared.html | `bool` | `false` | no |
| <a name="input_loadbalancer_managed_security_group"></a> [loadbalancer\_managed\_security\_group](#input\_loadbalancer\_managed\_security\_group) | Load balancer managed security group | `string` | `""` | no |
| <a name="input_loadbalancer_redirect_http_to_https"></a> [loadbalancer\_redirect\_http\_to\_https](#input\_loadbalancer\_redirect\_http\_to\_https) | Redirect HTTP traffic to HTTPS listener | `bool` | `false` | no |
| <a name="input_loadbalancer_redirect_http_to_https_host"></a> [loadbalancer\_redirect\_http\_to\_https\_host](#input\_loadbalancer\_redirect\_http\_to\_https\_host) | Defines the host for the HTTP to HTTPS redirection rule | `string` | `"#{host}"` | no |
| <a name="input_loadbalancer_redirect_http_to_https_path_pattern"></a> [loadbalancer\_redirect\_http\_to\_https\_path\_pattern](#input\_loadbalancer\_redirect\_http\_to\_https\_path\_pattern) | Defines the path pattern for the HTTP to HTTPS redirection rule | `list(string)` | <pre>[<br>  "*"<br>]</pre> | no |
| <a name="input_loadbalancer_redirect_http_to_https_port"></a> [loadbalancer\_redirect\_http\_to\_https\_port](#input\_loadbalancer\_redirect\_http\_to\_https\_port) | Defines the port for the HTTP to HTTPS redirection rule | `string` | `"443"` | no |
| <a name="input_loadbalancer_redirect_http_to_https_priority"></a> [loadbalancer\_redirect\_http\_to\_https\_priority](#input\_loadbalancer\_redirect\_http\_to\_https\_priority) | Defines the priority for the HTTP to HTTPS redirection rule | `number` | `1` | no |
| <a name="input_loadbalancer_redirect_http_to_https_status_code"></a> [loadbalancer\_redirect\_http\_to\_https\_status\_code](#input\_loadbalancer\_redirect\_http\_to\_https\_status\_code) | The redirect status code | `string` | `"HTTP_301"` | no |
| <a name="input_loadbalancer_security_groups"></a> [loadbalancer\_security\_groups](#input\_loadbalancer\_security\_groups) | Load balancer security groups | `list(string)` | `[]` | no |
| <a name="input_loadbalancer_ssl_policy"></a> [loadbalancer\_ssl\_policy](#input\_loadbalancer\_ssl\_policy) | Specify a security policy to apply to the listener. This option is only applicable to environments with an application load balancer | `string` | `""` | no |
| <a name="input_loadbalancer_subnets"></a> [loadbalancer\_subnets](#input\_loadbalancer\_subnets) | List of subnets to place Elastic Load Balancer | `list(string)` | `[]` | no |
| <a name="input_loadbalancer_type"></a> [loadbalancer\_type](#input\_loadbalancer\_type) | Load Balancer type, e.g. 'application' or 'classic' | `string` | `"classic"` | no |
| <a name="input_logs_delete_on_terminate"></a> [logs\_delete\_on\_terminate](#input\_logs\_delete\_on\_terminate) | Whether to delete the log groups when the environment is terminated. If false, the logs are kept RetentionInDays days | `bool` | `false` | no |
| <a name="input_logs_retention_in_days"></a> [logs\_retention\_in\_days](#input\_logs\_retention\_in\_days) | The number of days to keep log events before they expire. | `number` | `7` | no |
| <a name="input_managed_actions_enabled"></a> [managed\_actions\_enabled](#input\_managed\_actions\_enabled) | Enable managed platform updates. When you set this to true, you must also specify a `PreferredStartTime` and `UpdateLevel` | `bool` | `true` | no |
| <a name="input_name"></a> [name](#input\_name) | ID element. Usually the component or solution name, e.g. 'app' or 'jenkins'.<br>This is the only ID element not also included as a `tag`.<br>The "name" tag is set to the full `id` string. There is no tag with the value of the `name` input. | `string` | `null` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | ID element. Usually an abbreviation of your organization name, e.g. 'eg' or 'cp', to help ensure generated IDs are globally unique | `string` | `null` | no |
| <a name="input_prefer_legacy_service_policy"></a> [prefer\_legacy\_service\_policy](#input\_prefer\_legacy\_service\_policy) | Whether to use AWSElasticBeanstalkService (deprecated) or AWSElasticBeanstalkManagedUpdatesCustomerRolePolicy policy | `bool` | `true` | no |
| <a name="input_prefer_legacy_ssm_policy"></a> [prefer\_legacy\_ssm\_policy](#input\_prefer\_legacy\_ssm\_policy) | Whether to use AmazonEC2RoleforSSM (will soon be deprecated) or AmazonSSMManagedInstanceCore policy | `bool` | `true` | no |
| <a name="input_preferred_start_time"></a> [preferred\_start\_time](#input\_preferred\_start\_time) | Configure a maintenance window for managed actions in UTC | `string` | `"Sun:10:00"` | no |
| <a name="input_regex_replace_chars"></a> [regex\_replace\_chars](#input\_regex\_replace\_chars) | Terraform regular expression (regex) string.<br>Characters matching the regex will be removed from the ID elements.<br>If not set, `"/[^a-zA-Z0-9-]/"` is used to remove all characters other than hyphens, letters and digits. | `string` | `null` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS region | `string` | n/a | yes |
| <a name="input_rolling_update_enabled"></a> [rolling\_update\_enabled](#input\_rolling\_update\_enabled) | Whether to enable rolling update | `bool` | `true` | no |
| <a name="input_rolling_update_type"></a> [rolling\_update\_type](#input\_rolling\_update\_type) | `Health` or `Immutable`. Set it to `Immutable` to apply the configuration change to a fresh group of instances | `string` | `"Health"` | no |
| <a name="input_root_volume_iops"></a> [root\_volume\_iops](#input\_root\_volume\_iops) | The IOPS of the EBS root volume (only applies for gp3 and io1 types) | `number` | `null` | no |
| <a name="input_root_volume_size"></a> [root\_volume\_size](#input\_root\_volume\_size) | The size of the EBS root volume | `number` | `8` | no |
| <a name="input_root_volume_throughput"></a> [root\_volume\_throughput](#input\_root\_volume\_throughput) | The type of the EBS root volume (only applies for gp3 type) | `number` | `null` | no |
| <a name="input_root_volume_type"></a> [root\_volume\_type](#input\_root\_volume\_type) | The type of the EBS root volume | `string` | `"gp2"` | no |
| <a name="input_s3_bucket_access_log_bucket_name"></a> [s3\_bucket\_access\_log\_bucket\_name](#input\_s3\_bucket\_access\_log\_bucket\_name) | Name of the S3 bucket where s3 access log will be sent to | `string` | `""` | no |
| <a name="input_s3_bucket_versioning_enabled"></a> [s3\_bucket\_versioning\_enabled](#input\_s3\_bucket\_versioning\_enabled) | When set to 'true' the s3 origin bucket will have versioning enabled | `bool` | `true` | no |
| <a name="input_scheduled_actions"></a> [scheduled\_actions](#input\_scheduled\_actions) | Define a list of scheduled actions | <pre>list(object({<br>    name            = string<br>    minsize         = string<br>    maxsize         = string<br>    desiredcapacity = string<br>    starttime       = string<br>    endtime         = string<br>    recurrence      = string<br>    suspend         = bool<br>  }))</pre> | `[]` | no |
| <a name="input_security_group_create_before_destroy"></a> [security\_group\_create\_before\_destroy](#input\_security\_group\_create\_before\_destroy) | Set `true` to enable Terraform `create_before_destroy` behavior on the created security group.<br>We recommend setting this `true` on new security groups, but default it to `false` because `true`<br>will cause existing security groups to be replaced, possibly requiring the resource to be deleted and recreated.<br>Note that changing this value will always cause the security group to be replaced. | `bool` | `false` | no |
| <a name="input_security_group_create_timeout"></a> [security\_group\_create\_timeout](#input\_security\_group\_create\_timeout) | How long to wait for the security group to be created. | `string` | `"10m"` | no |
| <a name="input_security_group_delete_timeout"></a> [security\_group\_delete\_timeout](#input\_security\_group\_delete\_timeout) | How long to retry on `DependencyViolation` errors during security group deletion from<br>lingering ENIs left by certain AWS services such as Elastic Load Balancing. | `string` | `"15m"` | no |
| <a name="input_security_group_description"></a> [security\_group\_description](#input\_security\_group\_description) | The description to assign to the created Security Group.<br>Warning: Changing the description causes the security group to be replaced. | `string` | `"Security Group for the EB environment"` | no |
| <a name="input_security_group_name"></a> [security\_group\_name](#input\_security\_group\_name) | The name to assign to the created security group. Must be unique within the VPC.<br>If not provided, will be derived from the `null-label.context` passed in.<br>If `create_before_destroy` is true, will be used as a name prefix. | `list(string)` | `[]` | no |
| <a name="input_shared_loadbalancer_arn"></a> [shared\_loadbalancer\_arn](#input\_shared\_loadbalancer\_arn) | ARN of the shared application load balancer. Only when loadbalancer\_type = "application". | `string` | `""` | no |
| <a name="input_solution_stack_name"></a> [solution\_stack\_name](#input\_solution\_stack\_name) | Elastic Beanstalk stack, e.g. Docker, Go, Node, Java, IIS. For more info, see https://docs.aws.amazon.com/elasticbeanstalk/latest/platforms/platforms-supported.html | `string` | n/a | yes |
| <a name="input_spot_fleet_on_demand_above_base_percentage"></a> [spot\_fleet\_on\_demand\_above\_base\_percentage](#input\_spot\_fleet\_on\_demand\_above\_base\_percentage) | The percentage of On-Demand Instances as part of additional capacity that your Auto Scaling group provisions beyond the SpotOnDemandBase instances. This option is relevant only when enable\_spot\_instances is true. | `number` | `-1` | no |
| <a name="input_spot_fleet_on_demand_base"></a> [spot\_fleet\_on\_demand\_base](#input\_spot\_fleet\_on\_demand\_base) | The minimum number of On-Demand Instances that your Auto Scaling group provisions before considering Spot Instances as your environment scales up. This option is relevant only when enable\_spot\_instances is true. | `number` | `0` | no |
| <a name="input_spot_max_price"></a> [spot\_max\_price](#input\_spot\_max\_price) | The maximum price per unit hour, in US$, that you're willing to pay for a Spot Instance. This option is relevant only when enable\_spot\_instances is true. Valid values are between 0.001 and 20.0 | `number` | `-1` | no |
| <a name="input_ssh_listener_enabled"></a> [ssh\_listener\_enabled](#input\_ssh\_listener\_enabled) | Enable SSH port | `bool` | `false` | no |
| <a name="input_ssh_listener_port"></a> [ssh\_listener\_port](#input\_ssh\_listener\_port) | SSH port | `number` | `22` | no |
| <a name="input_stage"></a> [stage](#input\_stage) | ID element. Usually used to indicate role, e.g. 'prod', 'staging', 'source', 'build', 'test', 'deploy', 'release' | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags (e.g. `{'BusinessUnit': 'XYZ'}`).<br>Neither the tag keys nor the tag values will be modified by this module. | `map(string)` | `{}` | no |
| <a name="input_tenant"></a> [tenant](#input\_tenant) | ID element \_(Rarely used, not included by default)\_. A customer identifier, indicating who this instance of a resource is for | `string` | `null` | no |
| <a name="input_tier"></a> [tier](#input\_tier) | Elastic Beanstalk Environment tier, 'WebServer' or 'Worker' | `string` | `"WebServer"` | no |
| <a name="input_update_level"></a> [update\_level](#input\_update\_level) | The highest level of update to apply with managed platform updates | `string` | `"minor"` | no |
| <a name="input_updating_max_batch"></a> [updating\_max\_batch](#input\_updating\_max\_batch) | Maximum number of instances to update at once | `number` | `1` | no |
| <a name="input_updating_min_in_service"></a> [updating\_min\_in\_service](#input\_updating\_min\_in\_service) | Minimum number of instances in service during update | `number` | `1` | no |
| <a name="input_version_label"></a> [version\_label](#input\_version\_label) | Elastic Beanstalk Application version to deploy | `string` | `""` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | ID of the VPC in which to provision the AWS resources | `string` | n/a | yes |
| <a name="input_wait_for_ready_timeout"></a> [wait\_for\_ready\_timeout](#input\_wait\_for\_ready\_timeout) | The maximum duration to wait for the Elastic Beanstalk Environment to be in a ready state before timing out | `string` | `"20m"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_all_settings"></a> [all\_settings](#output\_all\_settings) | List of all option settings configured in the environment. These are a combination of default settings and their overrides from setting in the configuration |
| <a name="output_application"></a> [application](#output\_application) | The Elastic Beanstalk Application for this environment |
| <a name="output_autoscaling_groups"></a> [autoscaling\_groups](#output\_autoscaling\_groups) | The autoscaling groups used by this environment |
| <a name="output_ec2_instance_profile_role_name"></a> [ec2\_instance\_profile\_role\_name](#output\_ec2\_instance\_profile\_role\_name) | Instance IAM role name |
| <a name="output_elb_zone_id"></a> [elb\_zone\_id](#output\_elb\_zone\_id) | ELB zone ID |
| <a name="output_endpoint"></a> [endpoint](#output\_endpoint) | Fully qualified DNS name for the environment |
| <a name="output_hostname"></a> [hostname](#output\_hostname) | DNS hostname |
| <a name="output_id"></a> [id](#output\_id) | ID of the Elastic Beanstalk environment |
| <a name="output_instances"></a> [instances](#output\_instances) | Instances used by this environment |
| <a name="output_launch_configurations"></a> [launch\_configurations](#output\_launch\_configurations) | Launch configurations in use by this environment |
| <a name="output_load_balancer_log_bucket"></a> [load\_balancer\_log\_bucket](#output\_load\_balancer\_log\_bucket) | Name of bucket where Load Balancer logs are stored (if enabled) |
| <a name="output_load_balancers"></a> [load\_balancers](#output\_load\_balancers) | Elastic Load Balancers in use by this environment |
| <a name="output_name"></a> [name](#output\_name) | Name of the Elastic Beanstalk environment |
| <a name="output_queues"></a> [queues](#output\_queues) | SQS queues in use by this environment |
| <a name="output_security_group_arn"></a> [security\_group\_arn](#output\_security\_group\_arn) | Elastic Beanstalk environment Security Group ARN |
| <a name="output_security_group_id"></a> [security\_group\_id](#output\_security\_group\_id) | Elastic Beanstalk environment Security Group ID |
| <a name="output_security_group_name"></a> [security\_group\_name](#output\_security\_group\_name) | Elastic Beanstalk environment Security Group name |
| <a name="output_setting"></a> [setting](#output\_setting) | Settings specifically set for this environment |
| <a name="output_tier"></a> [tier](#output\_tier) | The environment tier |
| <a name="output_triggers"></a> [triggers](#output\_triggers) | Autoscaling triggers in use by this environment |
<!-- markdownlint-restore -->
