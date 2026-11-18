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
  # null keeps the provider/Azure default; false forces egress through an explicit
  # path (NAT Gateway, firewall) instead of Azure's implicit default outbound IP.
  default_outbound_access_enabled = var.subnets[each.value].default_outbound_access_enabled

  # azurerm 5.x replaced the `service_endpoints` list with repeated `service_endpoint`
  # blocks. The input stays a list of service names so callers don't have to change.
  dynamic "service_endpoint" {
    for_each = coalesce(var.subnets[each.value].service_endpoints, [])
    content {
      service = service_endpoint.value
    }
  }

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

  # Precondition rather than a variable validation: cross-variable validations need
  # Terraform >= 1.9 and this module still supports 1.8.x.
  lifecycle {
    precondition {
      condition     = !var.subnets[each.value].nat_gateway_enabled || var.nat_gateway != null
      error_message = "Subnet '${each.value}' has nat_gateway_enabled = true but var.nat_gateway is not set."
    }
  }
}