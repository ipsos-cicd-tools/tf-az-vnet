output "subnet_ids" {
  value = { for s in azurerm_subnet.subnet : s.name => s.id }
}

output "vnet_id" {
  value = azurerm_virtual_network.default.id
}

output "vnet_name" {
  value = azurerm_virtual_network.default.name
}

output "nat_gateway_id" {
  description = "ID of the NAT Gateway, or null when var.nat_gateway is not set."
  value       = try(azurerm_nat_gateway.default[0].id, null)
}

output "nat_public_ip" {
  description = "Static egress IP of the NAT Gateway (share with parties that allowlist source IPs), or null when var.nat_gateway is not set."
  value       = try(azurerm_public_ip.nat[0].ip_address, null)
}

output "nat_public_ip_id" {
  description = "ID of the NAT Gateway public IP, or null when var.nat_gateway is not set."
  value       = try(azurerm_public_ip.nat[0].id, null)
}
