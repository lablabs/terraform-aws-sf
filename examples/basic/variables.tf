variable "ssh_public_key" {
  type        = string
  description = "Public key for SSHing into instances"
}

variable "s3_bucket" {
  type        = string
  description = "The name of AWS S3 bucket where aws-sf-lambda is stored"
}

variable "s3_bucket_key" {
  type        = string
  description = "The key of aws-sf-lambda function used in S3 bucket"
}

variable "aws_region" {
  type        = string
  description = "AWS region where resources will be created"
  default     = "eu-central-1"
}

variable "aws_zones" {
  type        = list(string)
  description = "AWS Availability Zones where resources will be created"
  default     = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
}

variable "node_count" {
  type        = map(number)
  description = "Number of instances in each AZ"
  default = {
    "eu-central-1a" : 1
    "eu-central-1b" : 1
    "eu-central-1c" : 1
  }
}

variable "vpc_base_cidr" {
  type        = string
  description = "AWS VPC base CIDR"
  default     = "10.1.0.0/16"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type"
  default     = "t3.nano"
}

variable "ami" {
  type        = string
  description = "Ubuntu Linux Bionic/Xenial AMI"
  default     = "ami-0b6d8a6db0c665fb7"
}

variable "name" {
  type        = string
  description = "Name which is used as a prefix for the resources"
  default     = "kafka"
}

variable "stack_name" {
  type        = string
  description = "Name of the stack that is supposed to be managed by the module"
  default     = "kafka-dev"
}
