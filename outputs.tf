output "eni-az0-ip" {
  description = "IP address of the ENI in AZ0"
  value       = flatten(concat(aws_network_interface.az0.*.private_ips, [""]))[0]
}

output "eni-az1-ip" {
  description = "IP address of the ENI in AZ1"
  value       = flatten(concat(aws_network_interface.az0.*.private_ips, [""]))[0]
}

output "eni-az2-ip" {
  description = "IP address of the ENI in AZ2"
  value       = flatten(concat(aws_network_interface.az0.*.private_ips, [""]))[0]
}

output "eni-az0-id" {
  description = "ID of the ENI in AZ0"
  value       = concat(aws_network_interface.az0.*.id, [""])[0]
}

output "eni-az1-id" {
  description = "ID of the ENI in AZ1"
  value       = concat(aws_network_interface.az1.*.id, [""])[0]
}

output "eni-az2-id" {
  description = "ID of the ENI in AZ2"
  value       = concat(aws_network_interface.az2.*.id, [""])[0]
}
