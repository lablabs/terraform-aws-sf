output "eni-az0-ip" {
  description = "IP address of the ENI in AZ0"
  value       = sort(aws_network_interface.az0[0].private_ips)[0]
}

output "eni-az1-ip" {
  description = "IP address of the ENI in AZ1"
  value       = length(var.aws_zones) > 1 ? sort(aws_network_interface.az1[0].private_ips)[0] : ""
}

output "eni-az2-ip" {
  description = "IP address of the ENI in AZ2"
  value       = length(var.aws_zones) > 2 ? sort(aws_network_interface.az2[0].private_ips)[0] : ""
}

output "eni-az0-id" {
  description = "ID of the ENI in AZ0"
  value       = aws_network_interface.az0[0].id
}

output "eni-az1-id" {
  description = "ID of the ENI in AZ1"
  value       = length(var.aws_zones) > 1 ? aws_network_interface.az1[0].id : ""
}

output "eni-az2-id" {
  description = "ID of the ENI in AZ2"
  value       = length(var.aws_zones) > 2 ? aws_network_interface.az2[0].id : ""
}
