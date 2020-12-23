<!-- markdownlint-disable -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12.26 |
| aws | >= 2.0 |
| null | >= 2.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 2.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| additional\_security\_groups | List of security groups to be allowed to connect to the EC2 instances | `list(string)` | `[]` | no |
| additional\_settings | Additional Elastic Beanstalk setttings. For full list of options, see https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/command-options-general.html | <pre>list(object({<br>    namespace = string<br>    name      = string<br>    value     = string<br>  }))</pre> | `[]` | no |
| additional\_tag\_map | Additional tags for appending to tags\_as\_list\_of\_maps. Not added to `tags`. | `map(string)` | `{}` | no |
| alb\_zone\_id | ALB zone id | `map(string)` | <pre>{<br>  "ap-northeast-1": "Z1R25G3KIG2GBW",<br>  "ap-northeast-2": "Z3JE5OI70TWKCP",<br>  "ap-south-1": "Z18NTBI3Y7N9TZ",<br>  "ap-southeast-1": "Z16FZ9L249IFLT",<br>  "ap-southeast-2": "Z2PCDNR3VC2G1N",<br>  "ca-central-1": "ZJFCZL7SSZB5I",<br>  "eu-central-1": "Z1FRNW7UH4DEZJ",<br>  "eu-west-1": "Z2NYPWQ7DFZAZH",<br>  "eu-west-2": "Z1GKAAAUGATPF1",<br>  "eu-west-3": "ZCMLWB8V5SYIT",<br>  "sa-east-1": "Z10X7K2B4QSOFV",<br>  "us-east-1": "Z117KPS5GTRQ2G",<br>  "us-east-2": "Z14LCN19Q5QHIC",<br>  "us-west-1": "Z1LQECGX5PH1X",<br>  "us-west-2": "Z38NKT9BP95V3O"<br>}</pre> | no |
| allowed\_security\_groups | List of security groups to add to the EC2 instances | `list(string)` | `[]` | no |
| ami\_id | The id of the AMI to associate with the Amazon EC2 instances | `string` | `null` | no |
| application\_port | Port application is listening on | `number` | `80` | no |
| application\_subnets | List of subnets to place EC2 instances | `list(string)` | n/a | yes |
| associate\_public\_ip\_address | Whether to associate public IP addresses to the instances | `bool` | `false` | no |
| attributes | Additional attributes (e.g. `1`) | `list(string)` | `[]` | no |
| autoscale\_lower\_bound | Minimum level of autoscale metric to remove an instance | `number` | `20` | no |
| autoscale\_lower\_increment | How many Amazon EC2 instances to remove when performing a scaling activity. | `number` | `-1` | no |
| autoscale\_max | Maximum instances to launch | `number` | `3` | no |
| autoscale\_measure\_name | Metric used for your Auto Scaling trigger | `string` | `"CPUUtilization"` | no |
| autoscale\_min | Minumum instances to launch | `number` | `2` | no |
| autoscale\_statistic | Statistic the trigger should use, such as Average | `string` | `"Average"` | no |
| autoscale\_unit | Unit for the trigger measurement, such as Bytes | `string` | `"Percent"` | no |
| autoscale\_upper\_bound | Maximum level of autoscale metric to add an instance | `number` | `80` | no |
| autoscale\_upper\_increment | How many Amazon EC2 instances to add when performing a scaling activity | `number` | `1` | no |
| availability\_zone\_selector | Availability Zone selector | `string` | `"Any 2"` | no |
| context | Single object for setting entire context at once.<br>See description of individual variables for details.<br>Leave string and numeric variables as `null` to use default value.<br>Individual variable settings (non-null) override settings in context object,<br>except for attributes, tags, and additional\_tag\_map, which are merged. | <pre>object({<br>    enabled             = bool<br>    namespace           = string<br>    environment         = string<br>    stage               = string<br>    name                = string<br>    delimiter           = string<br>    attributes          = list(string)<br>    tags                = map(string)<br>    additional_tag_map  = map(string)<br>    regex_replace_chars = string<br>    label_order         = list(string)<br>    id_length_limit     = number<br>  })</pre> | <pre>{<br>  "additional_tag_map": {},<br>  "attributes": [],<br>  "delimiter": null,<br>  "enabled": true,<br>  "environment": null,<br>  "id_length_limit": null,<br>  "label_order": [],<br>  "name": null,<br>  "namespace": null,<br>  "regex_replace_chars": null,<br>  "stage": null,<br>  "tags": {}<br>}</pre> | no |
| delimiter | Delimiter to be used between `namespace`, `environment`, `stage`, `name` and `attributes`.<br>Defaults to `-` (hyphen). Set to `""` to use no delimiter at all. | `string` | `null` | no |
| deployment\_batch\_size | Percentage or fixed number of Amazon EC2 instances in the Auto Scaling group on which to simultaneously perform deployments. Valid values vary per deployment\_batch\_size\_type setting | `number` | `1` | no |
| deployment\_batch\_size\_type | The type of number that is specified in deployment\_batch\_size\_type | `string` | `"Fixed"` | no |
| deployment\_ignore\_health\_check | Do not cancel a deployment due to failed health checks | `bool` | `false` | no |
| deployment\_timeout | Number of seconds to wait for an instance to complete executing commands | `number` | `600` | no |
| description | Short description of the Environment | `string` | `""` | no |
| dns\_subdomain | The subdomain to create on Route53 for the EB environment. For the subdomain to be created, the `dns_zone_id` variable must be set as well | `string` | `""` | no |
| dns\_zone\_id | Route53 parent zone ID. The module will create sub-domain DNS record in the parent zone for the EB environment | `string` | `""` | no |
| elastic\_beanstalk\_application\_name | Elastic Beanstalk application name | `string` | n/a | yes |
| elb\_scheme | Specify `internal` if you want to create an internal load balancer in your Amazon VPC so that your Elastic Beanstalk application cannot be accessed from outside your Amazon VPC | `string` | `"public"` | no |
| enable\_log\_publication\_control | Copy the log files for your application's Amazon EC2 instances to the Amazon S3 bucket associated with your application | `bool` | `false` | no |
| enable\_spot\_instances | Enable Spot Instance requests for your environment | `bool` | `false` | no |
| enable\_stream\_logs | Whether to create groups in CloudWatch Logs for proxy and deployment logs, and stream logs from each instance in your environment | `bool` | `false` | no |
| enabled | Set to false to prevent the module from creating any resources | `bool` | `null` | no |
| enhanced\_reporting\_enabled | Whether to enable "enhanced" health reporting for this environment.  If false, "basic" reporting is used.  When you set this to false, you must also set `enable_managed_actions` to false | `bool` | `true` | no |
| env\_vars | Map of custom ENV variables to be provided to the application running on Elastic Beanstalk, e.g. env\_vars = { DB\_USER = 'admin' DB\_PASS = 'xxxxxx' } | `map(string)` | `{}` | no |
| environment | Environment, e.g. 'uw2', 'us-west-2', OR 'prod', 'staging', 'dev', 'UAT' | `string` | `null` | no |
| environment\_type | Environment type, e.g. 'LoadBalanced' or 'SingleInstance'.  If setting to 'SingleInstance', `rolling_update_type` must be set to 'Time', `updating_min_in_service` must be set to 0, and `loadbalancer_subnets` will be unused (it applies to the ELB, which does not exist in SingleInstance environments) | `string` | `"LoadBalanced"` | no |
| extended\_ec2\_policy\_document | Extensions or overrides for the IAM role assigned to EC2 instances | `string` | `"{}"` | no |
| force\_destroy | Force destroy the S3 bucket for load balancer logs | `bool` | `false` | no |
| health\_streaming\_delete\_on\_terminate | Whether to delete the log group when the environment is terminated. If false, the health data is kept RetentionInDays days. | `bool` | `false` | no |
| health\_streaming\_enabled | For environments with enhanced health reporting enabled, whether to create a group in CloudWatch Logs for environment health and archive Elastic Beanstalk environment health data. For information about enabling enhanced health, see aws:elasticbeanstalk:healthreporting:system. | `bool` | `false` | no |
| health\_streaming\_retention\_in\_days | The number of days to keep the archived health data before it expires. | `number` | `7` | no |
| healthcheck\_url | Application Health Check URL. Elastic Beanstalk will call this URL to check the health of the application running on EC2 instances | `string` | `"/healthcheck"` | no |
| http\_listener\_enabled | Enable port 80 (http) | `bool` | `true` | no |
| id\_length\_limit | Limit `id` to this many characters.<br>Set to `0` for unlimited length.<br>Set to `null` for default, which is `0`.<br>Does not affect `id_full`. | `number` | `null` | no |
| instance\_refresh\_enabled | Enable weekly instance replacement. | `bool` | `true` | no |
| instance\_type | Instances type | `string` | `"t2.micro"` | no |
| keypair | Name of SSH key that will be deployed on Elastic Beanstalk and DataPipeline instance. The key should be present in AWS | `string` | `""` | no |
| label\_order | The naming order of the id output and Name tag.<br>Defaults to ["namespace", "environment", "stage", "name", "attributes"].<br>You can omit any of the 5 elements, but at least one must be present. | `list(string)` | `null` | no |
| loadbalancer\_certificate\_arn | Load Balancer SSL certificate ARN. The certificate must be present in AWS Certificate Manager | `string` | `""` | no |
| loadbalancer\_crosszone | Configure the classic load balancer to route traffic evenly across all instances in all Availability Zones rather than only within each zone. | `bool` | `true` | no |
| loadbalancer\_managed\_security\_group | Load balancer managed security group | `string` | `""` | no |
| loadbalancer\_security\_groups | Load balancer security groups | `list(string)` | `[]` | no |
| loadbalancer\_ssl\_policy | Specify a security policy to apply to the listener. This option is only applicable to environments with an application load balancer | `string` | `""` | no |
| loadbalancer\_subnets | List of subnets to place Elastic Load Balancer | `list(string)` | `[]` | no |
| loadbalancer\_type | Load Balancer type, e.g. 'application' or 'classic' | `string` | `"classic"` | no |
| logs\_delete\_on\_terminate | Whether to delete the log groups when the environment is terminated. If false, the logs are kept RetentionInDays days | `bool` | `false` | no |
| logs\_retention\_in\_days | The number of days to keep log events before they expire. | `number` | `7` | no |
| managed\_actions\_enabled | Enable managed platform updates. When you set this to true, you must also specify a `PreferredStartTime` and `UpdateLevel` | `bool` | `true` | no |
| name | Solution name, e.g. 'app' or 'jenkins' | `string` | `null` | no |
| namespace | Namespace, which could be your organization name or abbreviation, e.g. 'eg' or 'cp' | `string` | `null` | no |
| prefer\_legacy\_ssm\_policy | Whether to use AmazonEC2RoleforSSM (will soon be deprecated) or AmazonSSMManagedInstanceCore policy | `bool` | `true` | no |
| preferred\_start\_time | Configure a maintenance window for managed actions in UTC | `string` | `"Sun:10:00"` | no |
| regex\_replace\_chars | Regex to replace chars with empty string in `namespace`, `environment`, `stage` and `name`.<br>If not set, `"/[^a-zA-Z0-9-]/"` is used to remove all characters other than hyphens, letters and digits. | `string` | `null` | no |
| region | AWS region | `string` | n/a | yes |
| rolling\_update\_enabled | Whether to enable rolling update | `bool` | `true` | no |
| rolling\_update\_type | `Health` or `Immutable`. Set it to `Immutable` to apply the configuration change to a fresh group of instances | `string` | `"Health"` | no |
| root\_volume\_size | The size of the EBS root volume | `number` | `8` | no |
| root\_volume\_type | The type of the EBS root volume | `string` | `"gp2"` | no |
| solution\_stack\_name | Elastic Beanstalk stack, e.g. Docker, Go, Node, Java, IIS. For more info, see https://docs.aws.amazon.com/elasticbeanstalk/latest/platforms/platforms-supported.html | `string` | n/a | yes |
| spot\_fleet\_on\_demand\_above\_base\_percentage | The percentage of On-Demand Instances as part of additional capacity that your Auto Scaling group provisions beyond the SpotOnDemandBase instances. This option is relevant only when enable\_spot\_instances is true. | `number` | `-1` | no |
| spot\_fleet\_on\_demand\_base | The minimum number of On-Demand Instances that your Auto Scaling group provisions before considering Spot Instances as your environment scales up. This option is relevant only when enable\_spot\_instances is true. | `number` | `0` | no |
| spot\_max\_price | The maximum price per unit hour, in US$, that you're willing to pay for a Spot Instance. This option is relevant only when enable\_spot\_instances is true. Valid values are between 0.001 and 20.0 | `number` | `-1` | no |
| ssh\_listener\_enabled | Enable SSH port | `bool` | `false` | no |
| ssh\_listener\_port | SSH port | `number` | `22` | no |
| ssh\_source\_restriction | Used to lock down SSH access to the EC2 instances | `string` | `"0.0.0.0/0"` | no |
| stage | Stage, e.g. 'prod', 'staging', 'dev', OR 'source', 'build', 'test', 'deploy', 'release' | `string` | `null` | no |
| tags | Additional tags (e.g. `map('BusinessUnit','XYZ')` | `map(string)` | `{}` | no |
| tier | Elastic Beanstalk Environment tier, 'WebServer' or 'Worker' | `string` | `"WebServer"` | no |
| update\_level | The highest level of update to apply with managed platform updates | `string` | `"minor"` | no |
| updating\_max\_batch | Maximum number of instances to update at once | `number` | `1` | no |
| updating\_min\_in\_service | Minimum number of instances in service during update | `number` | `1` | no |
| version\_label | Elastic Beanstalk Application version to deploy | `string` | `""` | no |
| vpc\_id | ID of the VPC in which to provision the AWS resources | `string` | n/a | yes |
| wait\_for\_ready\_timeout | The maximum duration to wait for the Elastic Beanstalk Environment to be in a ready state before timing out | `string` | `"20m"` | no |

## Outputs

| Name | Description |
|------|-------------|
| all\_settings | List of all option settings configured in the environment. These are a combination of default settings and their overrides from setting in the configuration |
| application | The Elastic Beanstalk Application specified for this environment |
| autoscaling\_groups | The autoscaling groups used by this environment |
| ec2\_instance\_profile\_role\_name | Instance IAM role name |
| elb\_zone\_id | ELB zone id |
| endpoint | Fully qualified DNS name for the environment |
| hostname | DNS hostname |
| id | ID of the Elastic Beanstalk environment |
| instances | Instances used by this environment |
| launch\_configurations | Launch configurations in use by this environment |
| load\_balancers | Elastic Load Balancers in use by this environment |
| name | Name |
| queues | SQS queues in use by this environment |
| security\_group\_id | Security group id |
| setting | Settings specifically set for this environment |
| tier | The environment tier |
| triggers | Autoscaling triggers in use by this environment |

<!-- markdownlint-restore -->
