# aws-sf

## Overview

Creates ASGs with static IP and EBS volume for each launched EC2 instance.

The static IPs and EBS volumes are managed by [aws-sf-lambda](#aws-sf-lambda) lambda function that gets triggered on instance launch.

## Requirements

This plugin requires Ubuntu AMI to be used, see [aws-sf-userdata](#aws-sf-userdata) related project for further reference.

Every release of lambda function code should provide a zip file with a unique 
url (a combination of `lambda_function_zip_base_url` and 
`lambda_function_zip_filename` input variables). In other case, 
`aws_lambda_function` resource may not be updated correctly. 

For downloading the lambda function zip file a `curl` tool is used.

## Related projects

### aws-sf-lambda

A lambda function which is used for attaching of static ENIs and EBS volumes to
an EC2 instance launched by AWS ASGs.

URL: https://github.com/lablabs/aws-sf-lambda

### aws-sf-userdata

User data bash scripts which are used for network and storage setup once EC2
instances are running.

URL: https://github.com/lablabs/aws-sf-userdata

## Examples

See [Basic example](examples/basic/README.md) for further information.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| ami | ID of AMI used to launch instances | `string` | n/a | yes |
| aws\_region | AWS region | `string` | n/a | yes |
| aws\_zones | Name of the AZs | `list(string)` | n/a | yes |
| iam\_instance\_profile\_id | IAM instance profile ID associated with the EC2 instances | `string` | n/a | yes |
| key\_pair\_id | SSH key pair ID | `string` | n/a | yes |
| lambda\_s3\_bucket | S3 bucket where the lambda function package is stored | `string` | n/a | yes |
| lambda\_s3\_bucket\_key | S3 bucket key of the lambda function package | `string` | n/a | yes |
| name | Name which is used as a prefix for the resources | `string` | n/a | yes |
| node\_count | Number of nodes to launch in AZs | `map(string)` | n/a | yes |
| sg\_ids | ID of security groups that are assigned to the instances | `list(string)` | n/a | yes |
| stack\_name | Name of the stack that is supposed to be managed by the module | `string` | n/a | yes |
| subnets | ID of subnets where the module should launch EC2 instances | `map(string)` | n/a | yes |
| vpc\_id | ID of the VPC | `string` | n/a | yes |
| after\_sf\_init\_userdata | Additional commands to execute on machine after sf init was run | `string` | `""` | no |
| before\_sf\_init\_userdata | Additional commands to execute on machine before sf init was run | `string` | `""` | no |
| ebs\_delete\_on\_termination | Delete EBS volume on termination | `string` | `"true"` | no |
| ebs\_encrypted | Enable EBS encryption | `string` | `"true"` | no |
| ebs\_iops | IOPS for EBS volumes | `string` | `null` | no |
| ebs\_optimized | Enable EBS optimization | `string` | `"true"` | no |
| ebs\_size | Size of the EBS volume | `string` | `"20"` | no |
| ebs\_type | Type of the EBS volume | `string` | `"gp2"` | no |
| instance\_type | Instance type of the instances | `string` | `"t3.medium"` | no |
| load\_balancers | List of LBs added to the ASGs | `list(string)` | `[]` | no |
| root\_ebs\_size | Size of the root EBS volume | `string` | `"20"` | no |
| tag\_inventory\_name | Name of the Inventory tag which is used by the aws-sf lambda | `string` | `"Inventory"` | no |
| tag\_stack\_name | Name of the Stack tag which is used by the aws-sf lambda | `string` | `"Stack"` | no |
| tags | Additional tags, e.g. `map('BusinessUnit','XYZ')` | `map(string)` | <pre>{<br>  "Terraform": true<br>}</pre> | no |
| target\_group\_arns | List of target group ARNs added to the ASGs | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| eni-az0-id | ID of the ENI in AZ0 |
| eni-az0-ip | IP address of the ENI in AZ0 |
| eni-az1-id | ID of the ENI in AZ1 |
| eni-az1-ip | IP address of the ENI in AZ1 |
| eni-az2-id | ID of the ENI in AZ2 |
| eni-az2-ip | IP address of the ENI in AZ2 |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
