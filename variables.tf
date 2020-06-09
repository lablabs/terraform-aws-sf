### default values - start ###

variable "instance_type" {
  description = "Instance type of the instances"
  type        = string
  default     = "t3.medium"
}

variable "ebs_type" {
  description = "Type of the EBS volume "
  type        = string
  default     = "gp2"
}

variable "root_ebs_size" {
  description = "Size of the root EBS volume"
  default     = "20"
  type        = string
}

variable "ebs_size" {
  description = "Size of the EBS volume"
  default     = "20"
  type        = string
}

variable "ebs_iops" {
  description = "IOPS for EBS volumes"
  type        = string
  default     = ""
}

variable "ebs_encrypted" {
  description = "Enable EBS encryption"
  type        = string
  default     = "true"
}

variable "ebs_delete_on_termination" {
  description = "Delete EBS volume on termination"
  type        = string
  default     = "true"
}

variable "ebs_optimized" {
  description = "Enable EBS optimization"
  default     = "true"
  type        = string
}

variable "tags" {
  type = map(string)
  default = {
    Terraform = true
  }
  description = "Additional tags, e.g. `map('BusinessUnit','XYZ')`"
}

variable "tag_stack_name" {
  description = "Name of the Stack tag which is used by the aws-sf lambda "
  type        = string
  default     = "Stack"
}

variable "tag_inventory_name" {
  description = "Name of the Inventory tag which is used by the aws-sf lambda"
  type        = string
  default     = "Inventory"
}

variable "load_balancers" {
  description = "List of LBs added to the ASGs"
  type        = list(string)
  default     = []
}

variable "target_group_arns" {
  description = "List of target group ARNs added to the ASGs"
  type        = list(string)
  default     = []
}

variable "before_sf_init_userdata" {
  description = "Additional commands to execute on machine before sf init was run"
  type        = string
  default     = ""
}

variable "after_sf_init_userdata" {
  description = "Additional commands to execute on machine after sf init was run"
  type        = string
  default     = ""
}

### default values - end ###

variable "name" {
  description = "Name which is used as a prefix for the resources"
  type        = string
}

variable "stack_name" {
  description = "Name of the stack that is supposed to be managed by the module"
  type        = string
}

variable "node_count" {
  description = "Number of nodes to launch in AZs"
  type        = map(string)
}

variable "subnets" {
  description = "ID of subnets where the module should launch EC2 instances"
  type        = map(string)
}

variable "aws_zones" {
  description = "Name of the AZs"
  type        = list(string)
}

variable "key_pair_id" {
  description = "SSH key pair ID"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "iam_instance_profile_id" {
  description = "IAM instance profile ID associated with the EC2 instances"
  type        = string
}

variable "ami" {
  description = "ID of AMI used to launch instances"
  type        = string
}

variable "sg_ids" {
  description = "ID of security groups that are assigned to the instances"
  type        = list(string)
}

variable "lambda_s3_bucket" {
  description = "S3 bucket where the lambda function package is stored"
  type        = string
}

variable "lambda_s3_bucket_key" {
  description = "S3 bucket key of the lambda function package"
  type        = string
}
