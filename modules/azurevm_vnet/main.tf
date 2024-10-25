# #Create Resource Group
# resource "azurerm_resource_group" "default" {

#   name     = var.resource_group_name
#   location = var.location

#   tags = var.tags
# }

# Create Virtual Network
resource "azurerm_virtual_network" "default" {

  resource_group_name = var.resource_group_name
  location            = var.location

  name          = var.vnet_name
  address_space = var.address_space

  tags = var.tags
}

resource "azurerm_subnet" "subnet" {
  for_each = local.subnet_names

  name                              = each.value
  resource_group_name               = var.resource_group_name
  virtual_network_name              = azurerm_virtual_network.default.name
  address_prefixes                  = var.subnets[each.value].address_prefixes
  private_endpoint_network_policies = var.subnets[each.value].private_endpoint_network_policies

  dynamic "delegation" {
    for_each = var.subnets[each.value].delegation == null ? [] : var.subnets[each.value].delegation
    content {
      name = delegation.value.name

      service_delegation {
        name    = delegation.value.service_delegation.name
        actions = delegation.value.service_delegation.actions
      }
    }
  }
}