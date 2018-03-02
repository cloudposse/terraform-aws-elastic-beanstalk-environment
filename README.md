## terraform-aws-elastic-beanstalk-environment [![Build Status](https://travis-ci.org/cloudposse/terraform-aws-elastic-beanstalk-environment.svg)](https://travis-ci.org/cloudposse/terraform-aws-elastic-beanstalk-environment)

<!---
  --- This file was automatically generated by the `build-harness`
  --- Make changes instead to `.README.md` and rebuild.
  --->

Terraform module to provision AWS Elastic Beanstalk environment

## Input

<!--------------------------------REQUIRE POSTPROCESSING-------------------------------->
|  Name |  Default  |  Description  |
|:------|:---------:|:--------------:|
| alb_zone_id |{} |ALB zone id|
| app |__REQUIRED__ |EBS application name|
| attributes |[] |Additional attributes (e.g. `policy` or `role`)|
| autoscale_lower_bound |"20" |Minimum level of autoscale metric to add instance|
| autoscale_max |"3" |Maximum instances in charge|
| autoscale_min |"2" |Minumum instances in charge|
| autoscale_upper_bound |"80" |Maximum level of autoscale metric to remove instance|
| config_source |"" |S3 source for config|
| delimiter |"-" |Delimiter to be used between `name`, `namespace`, `stage`, etc.|
| env_default_key |"DEFAULT_ENV_%d" |Default ENV variable key for Elastic Beanstalk `aws:elasticbeanstalk:application:environment` setting|
| env_default_value |"UNSET" |Default ENV variable value for Elastic Beanstalk `aws:elasticbeanstalk:application:environment` setting|
| env_vars |{} |Map of custom ENV variables to be provided to the Jenkins application running on Elastic Beanstalk, e.g. `env_vars = { JENKINS_USER = 'admin' JENKINS_PASS = 'xxxxxx' }`|
| healthcheck_url |"/healthcheck" |Application Health Check URL. Elastic Beanstalk will call this URL to check the health of the application running on EC2 instances|
| http_listener_enabled |"false" |Enable port 80 (http)|
| ssh_source_restriction |"0.0.0.0/0" |Used to lock down SSH access to the EC2 instances. You can specify a CIDR or a security group id|
| instance_type |"t2.micro" |Instances type|
| associate_public_ip_address |"false" |Specifies whether to launch instances in your VPC with public IP addresses.|
| keypair |__REQUIRED__ |Name of SSH key that will be deployed on Elastic Beanstalk and DataPipeline instance. The key should be present in AWS|
| root_volume_size |"8" |The size of the EBS root volume|
| root_volume_type |"gp2" |The type of the EBS root volume|
| availability_zones |"Any 2" |Choose the number of AZs for your instances|
| loadbalancer_certificate_arn |"" |Load Balancer SSL certificate ARN. The certificate must be present in AWS Certificate Manager|
| loadbalancer_type |"classic" |Load Balancer type, e.g. 'application' or 'classic'|
| name |"app" |Solution name, e.g. 'app' or 'jenkins'|
| namespace |"global" |Namespace, which could be your organization name, e.g. 'cp' or 'cloudposse'|
| notification_endpoint |"" |Notification endpoint|
| notification_protocol |"email" |Notification protocol|
| notification_topic_arn |"" |Notification topic arn|
| notification_topic_name |"" |Notification topic name|
| private_subnets |__REQUIRED__ |List of private subnets to place EC2 instances|
| public_subnets |__REQUIRED__ |List of public subnets to place Elastic Load Balancer|
| security_groups |__REQUIRED__ |List of security groups to be allowed to connect to the EC2 instances|
| solution_stack_name |"" |Elastic Beanstalk stack, e.g. Docker, Go, Node, Java, IIS. [Read more](http://docs.aws.amazon.com/elasticbeanstalk/latest/dg/concepts.platforms.html)|
| ssh_listener_enabled |"false" |Enable ssh port|
| ssh_listener_port |"22" |SSH port|
| stage |"default" |Stage, e.g. 'prod', 'staging', 'dev', or 'test'|
| tags |{} |Additional tags (e.g. `map('BusinessUnit`,`XYZ`)|
| tier |"WebServer" |Elastic Beanstalk Environment tier, e.g. ('WebServer', 'Worker')|
| rolling_update_type |"Health" |Set it to 'Immutable' to apply the configuration change to a fresh group of instances [Read more](https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/using-features.rollingupdates.html)|
| updating_max_batch |"1" |Maximum count of instances up during update|
| updating_min_in_service |"1" |Minimum count of instances up during update|
| vpc_id |__REQUIRED__ |ID of the VPC in which to provision the AWS resources|
| wait_for_ready_timeout |"20m" ||
| zone_id |"" |Route53 parent zone ID. The module will create sub-domain DNS records in the parent zone for the EB environment|

## Output

<!--------------------------------REQUIRE POSTPROCESSING-------------------------------->
|  Name | Description  |
|:------|:------------:|
| ec2_instance_profile_role_name | Instance IAM role name  |
| elb_dns_name | ELB technical host  |
| elb_zone_id | ELB zone id  |
| host | DNS hostname  |
| name | Name  |
| security_group_id | Security group id  |

## Help

**Got a question?**

File a GitHub [issue](https://github.com/cloudposse/terraform-aws-elastic-beanstalk-environment/issues), send us an [email](mailto:hello@cloudposse.com) or reach out to us on [Gitter](https://gitter.im/cloudposse/).

## Contributing

### Bug Reports & Feature Requests

Please use the [issue tracker](https://github.com/cloudposse/terraform-aws-elastic-beanstalk-environment/issues) to report any bugs or file feature requests.

### Developing

If you are interested in being a contributor and want to get involved in developing `terraform-aws-elastic-beanstalk-environment`, we would love to hear from you! Shoot us an [email](mailto:hello@cloudposse.com).

In general, PRs are welcome. We follow the typical "fork-and-pull" Git workflow.

 1. **Fork** the repo on GitHub
 2. **Clone** the project to your own machine
 3. **Commit** changes to your own branch
 4. **Push** your work back up to your fork
 5. Submit a **Pull request** so that we can review your changes

**NOTE:** Be sure to merge the latest from "upstream" before making a pull request!

## License

[APACHE 2.0](LICENSE) © 2017 [Cloud Posse, LLC](https://cloudposse.com)

See [LICENSE](LICENSE) for full details.

    Licensed to the Apache Software Foundation (ASF) under one
    or more contributor license agreements.  See the NOTICE file
    distributed with this work for additional information
    regarding copyright ownership.  The ASF licenses this file
    to you under the Apache License, Version 2.0 (the
    "License"); you may not use this file except in compliance
    with the License.  You may obtain a copy of the License at

      http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing,
    software distributed under the License is distributed on an
    "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
    KIND, either express or implied.  See the License for the
    specific language governing permissions and limitations
    under the License.

## About

This project is maintained and funded by [Cloud Posse, LLC][website]. Like it? Please let us know at <hello@cloudposse.com>

We love [Open Source Software](https://github.com/cloudposse/)!

See [our other projects][community]
or [hire us][hire] to help build your next cloud-platform.

  [website]: http://cloudposse.com/
  [community]: https://github.com/cloudposse/
  [hire]: http://cloudposse.com/contact/

### Contributors

|[![Erik Osterman][erik_img]][erik_web]<br/>[Erik Osterman][erik_web] |[![Igor Rodionov][igor_img]][igor_web]<br/>[Igor Rodionov][igor_img] |[![Andriy Knysh][andriy_img]][andriy_web]<br/>[Andriy Knysh][andriy_web] |
|---|---|---|

[andriy_img]: https://avatars0.githubusercontent.com/u/7356997?v=4&u=ed9ce1c9151d552d985bdf5546772e14ef7ab617&s=144
[andriy_web]: https://github.com/aknysh/

[erik_img]: http://s.gravatar.com/avatar/88c480d4f73b813904e00a5695a454cb?s=144
[erik_web]: https://github.com/osterman/

[igor_img]: http://s.gravatar.com/avatar/bc70834d32ed4517568a1feb0b9be7e2?s=144
[igor_web]: https://github.com/goruha/

[konstantin_img]: https://avatars1.githubusercontent.com/u/11299538?v=4&u=ed9ce1c9151d552d985bdf5546772e14ef7ab617&s=144
[konstantin_web]: https://github.com/comeanother/

[sergey_img]: https://avatars1.githubusercontent.com/u/1134449?v=4&u=ed9ce1c9151d552d985bdf5546772e14ef7ab617&s=144
[sergey_web]: https://github.com/s2504s/

[valeriy_img]: https://avatars1.githubusercontent.com/u/10601658?v=4&u=ed9ce1c9151d552d985bdf5546772e14ef7ab617&s=144
[valeriy_web]: https://github.com/drama17/

[vladimir_img]: https://avatars1.githubusercontent.com/u/26582191?v=4&u=ed9ce1c9151d552d985bdf5546772e14ef7ab617&s=144
[vladimir_web]: https://github.com/SweetOps/
