## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| appversion_lifecycle_delete_source_from_s3 | Whether to delete application versions from S3 source | bool | `false` | no |
| appversion_lifecycle_max_count | The max number of application versions to keep | number | `1000` | no |
| appversion_lifecycle_service_role_arn | The service role ARN to use for application version cleanup. If left empty, the `appversion_lifecycle` block will not be created | string | `` | no |
| attributes | Additional attributes (e.g. `1`) | list(string) | `<list>` | no |
| delimiter | Delimiter to be used between `name`, `namespace`, `stage`, etc. | string | `-` | no |
| description | Elastic Beanstalk Application description | string | `` | no |
| environment | Environment, e.g. 'prod', 'staging', 'dev', 'pre-prod', 'UAT' | string | `` | no |
| name | Solution name, e.g. 'app' or 'cluster' | string | - | yes |
| namespace | Namespace, which could be your organization name, e.g. 'eg' or 'cp' | string | `` | no |
| stage | Stage, e.g. 'prod', 'staging', 'dev', or 'test' | string | `` | no |
| tags | Additional tags (e.g. `map('BusinessUnit`,`XYZ`) | map(string) | `<map>` | no |

## Outputs

| Name | Description |
|------|-------------|
| elastic_beanstalk_application_name | Elastic Beanstalk Application name |

