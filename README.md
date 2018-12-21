Terraform module to provision an HTTP style ingress rule based on hostname and path for an ALB using target groups. Originally from [Cloudposse's module](https://github.com/cloudposse/terraform-aws-alb-ingress)

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| deregistration\_delay | The amount of time to wait in seconds while deregistering target | string | `15` | no |
| health\_check\_healthy\_threshold | The number of consecutive health checks successes required before healthy | string | `2` | no |
| health\_check\_interval | The duration in seconds in between health checks | string | `15` | no |
| health\_check\_matcher | The HTTP response codes to indicate a healthy check | string | `200-399` | no |
| health\_check\_path | The destination for the health check request | string | `/` | no |
| health\_check\_timeout | The amount of time to wait in seconds before failing a health check request | string | `10` | no |
| health\_check\_unhealthy\_threshold | The number of consecutive health check failures required before unhealthy | string | `2` | no |
| hosts | Hosts to match in Hosts header, at least one of hosts or paths must be set | list | `<list>` | no |
| listener\_arns | A list of ALB listener ARNs to attach ALB listener rule to | list | `<list>` | no |
| listener\_arns\_count | The number of ARNs in listener_arns, this is necessary to work around a limitation in Terraform where counts cannot be computed | string | `0` | no |
| name | Solution name, e.g. `app` | string | - | yes |
| paths | Path pattern to match (a maximum of 1 can be defined), at least one of hosts or paths must be set | list | `<list>` | no |
| port | The port for generated ALB target group (if target_group_arn not set) | string | `80` | no |
| priority | The priority for the rule between 1 and 50000 (1 being highest priority) | string | `100` | no |
| protocol | The protocol for generated ALB target group (if target_group_arn not set) | string | `HTTP` | no |
| tags | Additional tags (e.g. `map(`BusinessUnit`,`XYZ`) | map | `<map>` | no |
| target\_group\_arn | ALB target group ARN, if this is an empty string a new one will be generated | string | `` | no |
| target\_type | - | string | `ip` | no |
| vpc\_id | The VPC ID where generated ALB target group will be provisioned (if target_group_arn not set) | string | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| target\_group\_arn | ALB Target group ARN |
| target\_group\_arn\_suffix | ALB Target group ARN suffix |
| target\_group\_name | ALB Target group name |
