resource "aws_network_interface" "az0" {
  count           = lookup(var.node_count, element(var.aws_zones, 0))
  subnet_id       = lookup(var.subnets, element(var.aws_zones, 0))
  security_groups = var.sg_ids
  description     = var.name

  tags = merge({
    Name                        = var.name
    "${var.tag_stack_name}"     = var.stack_name
    "${var.tag_inventory_name}" = "${var.name}-${element(var.aws_zones, 0)}-${count.index}"
  }, var.tags)
}

resource "aws_network_interface" "az1" {
  count           = length(var.aws_zones) > 1 ? lookup(var.node_count, element(var.aws_zones, 1)) : 0
  subnet_id       = lookup(var.subnets, element(var.aws_zones, 1))
  security_groups = var.sg_ids
  description     = var.name

  tags = merge({
    Name                        = var.name
    "${var.tag_stack_name}"     = var.stack_name
    "${var.tag_inventory_name}" = "${var.name}-${element(var.aws_zones, 1)}-${count.index}"
  }, var.tags)

}

resource "aws_network_interface" "az2" {
  count           = length(var.aws_zones) > 2 ? lookup(var.node_count, element(var.aws_zones, 2)) : 0
  subnet_id       = lookup(var.subnets, element(var.aws_zones, 2))
  security_groups = var.sg_ids
  description     = var.name

  tags = merge({
    Name                        = var.name
    "${var.tag_stack_name}"     = var.stack_name
    "${var.tag_inventory_name}" = "${var.name}-${element(var.aws_zones, 2)}-${count.index}"
  }, var.tags)

}
