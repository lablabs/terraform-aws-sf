locals {
  lambda_zip_filename  = "${var.lambda_function_zip_filename}${var.lambda_function_version}.zip"
  lambda_zip_file_path = "${path.module}/${local.lambda_zip_filename}"
  lambda_url           = "${var.lambda_function_zip_base_url}${var.lambda_function_version}/${var.lambda_function_zip_filename}${var.lambda_function_version}.zip"
}

resource "null_resource" "lambda_code" {
  triggers = {
    url : var.lambda_function_zip_base_url
    filename : var.lambda_function_zip_filename
    version : var.lambda_function_version
  }

  provisioner "local-exec" {
    command = "curl -sSL -o ${path.module}/${local.lambda_zip_filename} ${local.lambda_url}"
  }
}

resource "aws_lambda_function" "asg" {
  function_name = "${var.name}-aws-sf"
  filename      = local.lambda_zip_file_path
  role          = aws_iam_role.lambda_asg.arn
  handler       = "main.handle"
  description   = "triggered by ASGs"
  memory_size   = 128
  runtime       = "python3.6"
  timeout       = 30

  environment {
    variables = {
      TAG_STACK_NAME     = var.tag_stack_name
      TAG_STACK_VALUE    = var.stack_name
      TAG_INVENTORY_NAME = var.tag_inventory_name
    }
  }

  tags = merge({
    Name = "${var.name}-aws-sf"
  }, var.tags)

  depends_on = [null_resource.lambda_code]
}

resource "aws_iam_role_policy" "policy_lambda_asg" {
  name = "${var.name}-aws-sf-lambda"
  role = aws_iam_role.lambda_asg.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:*",
        "ec2:*",
        "autoscaling:CompleteLifecycleAction",
        "autoscaling:DescribeAutoScalingGroups"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role" "lambda_asg" {
  name = "${var.name}-aws-sf-lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
  tags               = var.tags
}

resource "aws_lambda_permission" "asg" {
  statement_id  = "${var.name}-AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.asg.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.lambda_asg.arn
}

resource "aws_cloudwatch_event_rule" "lambda_asg" {
  name          = "${var.name}-aws-sf-lambda"
  description   = "Trigger a lambda function when an instance launches in the ASGs"
  event_pattern = data.template_file.aws_cloudwatch_event_rule_pattern.rendered
}

data "template_file" "aws_cloudwatch_event_rule_pattern" {
  template = file("${path.module}/templates/cloudwatch-event-rule.json.tpl")
  vars = {
    asg-arns = jsonencode(aws_autoscaling_group.default.*.name)
  }
}

resource "aws_cloudwatch_event_target" "lambda_asg" {
  rule = aws_cloudwatch_event_rule.lambda_asg.name
  arn  = aws_lambda_function.asg.arn
}
