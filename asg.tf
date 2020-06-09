resource "aws_launch_configuration" "default" {
  name_prefix          = var.name
  iam_instance_profile = var.iam_instance_profile_id
  security_groups      = var.sg_ids
  image_id             = var.ami
  instance_type        = var.instance_type
  key_name             = var.key_pair_id
  user_data            = data.template_file.user_data.rendered
  ebs_optimized        = var.ebs_optimized

  root_block_device {
    volume_type           = var.ebs_type
    iops                  = var.ebs_iops
    volume_size           = var.root_ebs_size
    delete_on_termination = var.ebs_delete_on_termination
  }

  lifecycle {
    create_before_destroy = true
  }
}

data "template_file" "user_data" {
  template = file("${path.module}/templates/user-data.yml.tpl")
  vars = {
    before_sf_init_userdata = var.before_sf_init_userdata
    after_sf_init_userdata  = var.after_sf_init_userdata
  }
}

resource "aws_autoscaling_group" "default" {
  count                     = length(var.aws_zones)
  name                      = "${var.name}-${element(var.aws_zones, count.index)}"
  default_cooldown          = "1"
  wait_for_capacity_timeout = "0"
  health_check_grace_period = 600
  health_check_type         = "EC2"
  min_size                  = lookup(var.node_count, element(var.aws_zones, count.index))
  max_size                  = lookup(var.node_count, element(var.aws_zones, count.index))
  desired_capacity          = lookup(var.node_count, element(var.aws_zones, count.index))
  vpc_zone_identifier       = [lookup(var.subnets, element(var.aws_zones, count.index))]
  launch_configuration      = aws_launch_configuration.default.id

  load_balancers    = var.load_balancers
  target_group_arns = var.target_group_arns

  enabled_metrics = [
    "GroupStandbyInstances",
    "GroupTotalInstances",
    "GroupPendingInstances",
    "GroupTerminatingInstances",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupMinSize",
    "GroupMaxSize",
  ]

  tags = concat(
    flatten(
      [for key in keys(var.tags) :
        {
          key                 = key
          value               = var.tags[key]
          propagate_at_launch = true
        }
      ]
    ),
    list(
      {
        key                 = "Name"
        value               = "${var.name}-${element(var.aws_zones, count.index)}"
        propagate_at_launch = true
      },
      {
        key                 = var.tag_stack_name
        value               = var.stack_name
        propagate_at_launch = true
      }
    )
  )
}

resource "aws_autoscaling_lifecycle_hook" "default" {
  count                  = length(var.aws_zones)
  name                   = "aws-sf"
  autoscaling_group_name = element(aws_autoscaling_group.default.*.name, count.index)
  default_result         = "ABANDON"
  heartbeat_timeout      = 60
  lifecycle_transition   = "autoscaling:EC2_INSTANCE_LAUNCHING"
}
