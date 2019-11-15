# aws-sf

## Overview

Creates ASGs with static IP and EBS volume for each launched EC2 instance.

The static IPs and EBS volumes are managed by [aws-sf-lambda](https://git.pixelfederation.com/infra/lambda-infra/tree/master/aws-sf-lambda/src) lambda function that gets triggered on instance launch.

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
  asg_extra_tags          = local.kafka_tags
  load_balancers          = [aws_elb.kafka.name]
  stack_name              = "kafka"
  instance_type           = local.kafka_instance_type
  ebs_size                = local.kafka_ebs_size
}
```
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| name | Name which is used as a prefix for the resources | string | n/a | yes |
| stack_name | Name of the stack that is supposed to be managed by the module  | string | n/a | yes |
| node\_count | Number of nodes to launch in AZs | map | n/a | yes |
| subnets | ID of subnets where the module should launch EC2 instances | map | n/a | yes |
| aws_zones | Name of the AZs | list | n/a | yes |
| key_pair_id | SSH key pair id | string | n/a | yes |
| vpc_id | ID of the VPC | string | n/a | yes |
| aws_region | AWS region | string | n/a | yes |
| iam_instance_profile_id | IAM instance profile id associated with the EC2 instances | string | n/a | yes |
| ami | ID of ami used to launch instances | string | n/a | yes |
| sg_ids | ID of security groups that are assigned to the instances | list | n/a | yes |
| lambda_s3_bucket | S3 bucket where the lambda function package is stored | string | n/a | yes |
| lambda_s3_bucket_key | S3 bucket key of the lambda function package | string | n/a | yes |
| instance_type | Instance type of the instances | string | `"t3.medium"` | no |
| ebs_type | Type of the EBS volume | string | `"gp2"` | no |
| ebs_size | Size of the EBS volume | string | `"20"` | no |
| ebs_encrypted | Enable ebs encryption | string | `"true"` | no |
| ebs_delete_on_termination | Delete EBS volume on termination | string | `"true"` | no |
| ebs_optimized | Enable EBS optimization | string | `"true"` | no |
| asg_extra_tags | List of aws tags added to the instances | list | [{ key = "Terraform", value = "true", propagate_at_launch = true }] | no |
| load_balancers | List of LBs added to the ASGs | list | `<list>` | no |
| target_group_arns | List of targer group ARNs added to the ASGs | list | `<list>` | no |
