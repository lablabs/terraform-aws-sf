# Basic example

Configuration in this directory creates set of resources which are required by terraform-aws-sf module.

## Usage

To run this example you need to execute:

```shell script
$ terraform init
$ terraform plan
$ terraform apply
```

Run `terraform destroy` when you don’t need these resources.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| s3\_bucket | The name of AWS S3 bucket where aws-sf-lambda is stored | `string` | n/a | yes |
| s3\_bucket\_key | The key of aws-sf-lambda function used in S3 bucket | `string` | n/a | yes |
| ssh\_public\_key | Public key for SSHing into instances | `string` | n/a | yes |
| ami | Ubuntu Linux Bionic/Xenial AMI | `string` | `"ami-0b6d8a6db0c665fb7"` | no |
| aws\_region | AWS region where resources will be created | `string` | `"eu-central-1"` | no |
| aws\_zones | AWS Availability Zones where resources will be created | `list(string)` | <pre>[<br>  "eu-central-1a",<br>  "eu-central-1b",<br>  "eu-central-1c"<br>]</pre> | no |
| instance\_type | EC2 instance type | `string` | `"t3.nano"` | no |
| name | Name which is used as a prefix for the resources | `string` | `"kafka"` | no |
| node\_count | Number of instances in each AZ | `map(number)` | <pre>{<br>  "eu-central-1a": 1,<br>  "eu-central-1b": 1,<br>  "eu-central-1c": 1<br>}</pre> | no |
| stack\_name | Name of the stack that is supposed to be managed by the module | `string` | `"kafka-dev"` | no |
| vpc\_base\_cidr | AWS VPC base CIDR | `string` | `"10.1.0.0/16"` | no |

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
