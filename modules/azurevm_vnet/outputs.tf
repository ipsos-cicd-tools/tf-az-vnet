output "subnet_ids" {
  value = { for s in azurerm_subnet.subnet : s.name => s.id }
}

output "vnet_id" {
  value = azurerm_virtual_network.default.id
}

output "vnet_name" {
  value = azurerm_virtual_network.default.name
}