# aws-sf

## Overview

Creates ASGs with static IP and EBS volume for each launched EC2 instance.

The static IPs and EBS volumes are managed by aws-sf-lambdalambda function that gets triggered on instance launch.

## Example

```
module "infra" {
  source                  = "../"
  name                    = "kafka-${local.environment_name}"
  node_count              = local.kafka_node_count
  subnets                 = local.kafka_subnets
  key_pair_id             = data.terraform_remote_state.base_state.outputs.key_pair_id
  vpc_id                  = data.terraform_remote_state.base_state.outputs.vpc_id
  aws_region              = data.terraform_remote_state.base_state.outputs.region
  aws_zones               = data.terraform_remote_state.base_state.outputs.availability_zones
  iam_instance_profile_id = aws_iam_instance_profile.kafka.id
  ami                     = local.base_ami
  lambda_s3_bucket        = aws_s3_bucket.lambda.id
  lambda_s3_bucket_key    = local.lambda_s3_bucket_key
  sg_ids                  = [aws_security_group.kafka.id]
  tags                    = local.kafka_tags
  load_balancers          = [aws_elb.kafka.name]
  stack_name              = "kafka"
  instance_type           = local.kafka_instance_type
  ebs_size                = local.kafka_ebs_size
}
```

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
| ebs\_iops | IOPS for EBS volumes | `string` | `""` | no |
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
