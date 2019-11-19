output "eni-az0-ip" {
  value = sort(aws_network_interface.az0[0].private_ips)[0]
}

output "eni-az1-ip" {
  value = length(var.aws_zones) > 1 ? sort(aws_network_interface.az1[0].private_ips)[0] : ""
}

output "eni-az2-ip" {
  value = length(var.aws_zones) > 2 ? sort(aws_network_interface.az2[0].private_ips)[0] : ""
}

output "eni-az0-id" {
  value = aws_network_interface.az0[0].id
}

output "eni-az1-id" {
  value = length(var.aws_zones) > 1 ? aws_network_interface.az1[0].id : ""
}

output "eni-az2-id" {
  value = length(var.aws_zones) > 2 ? aws_network_interface.az2[0].id : ""
}