provider "aws" {
  region = var.aws_region
}

resource "aws_iam_instance_profile" "kafka" {
  name = "kafka_instance_profile"
  role = aws_iam_role.kafka.name
}

resource "aws_iam_role" "kafka" {
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "kafka" {
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:DescribeInstances"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_policy_attachment" "kafka" {
  name       = "kafka-policy-attachment"
  policy_arn = aws_iam_policy.kafka.arn
  roles      = [aws_iam_role.kafka.name]
}

resource "aws_key_pair" "ssh_key" {
  key_name   = "ssh-key"
  public_key = var.ssh_public_key
}

resource "aws_security_group" "kafka" {
  vpc_id = aws_vpc.kafka.id

  ingress {
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    protocol    = -1
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_vpc" "kafka" {
  cidr_block = var.vpc_base_cidr
}

resource "aws_subnet" "kafka" {
  count = length(var.aws_zones)

  cidr_block              = cidrsubnet(var.vpc_base_cidr, 4, count.index)
  availability_zone       = var.aws_zones[count.index]
  vpc_id                  = aws_vpc.kafka.id
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.kafka.id
}

resource "aws_route_table" "this" {
  vpc_id = aws_vpc.kafka.id
}

resource "aws_route" "this" {
  route_table_id         = aws_route_table.this.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

resource "aws_main_route_table_association" "this" {
  route_table_id = aws_route_table.this.id
  vpc_id         = aws_vpc.kafka.id
}

module "sf" {
  source                  = "../.."
  ami                     = var.ami
  aws_zones               = var.aws_zones
  iam_instance_profile_id = aws_iam_instance_profile.kafka.id
  key_pair_id             = aws_key_pair.ssh_key.id
  name                    = var.stack_name
  node_count              = var.node_count
  sg_ids                  = [aws_security_group.kafka.id]
  stack_name              = var.name
  subnets                 = { for s in aws_subnet.kafka : s.availability_zone => s.id }
  instance_type           = var.instance_type
  lambda_function_version = "0.1.1"
}
