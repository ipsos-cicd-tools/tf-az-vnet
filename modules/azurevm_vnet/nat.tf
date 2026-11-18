# Optional NAT Gateway: gives selected subnets a fixed public egress IP (e.g. for
# third parties that allowlist source addresses). Everything here is gated on
# var.nat_gateway so existing callers see no change.

locals {
  nat_enabled     = var.nat_gateway != null
  nat_subnet_keys = local.nat_enabled ? toset([for k, s in var.subnets : k if s.nat_gateway_enabled]) : toset([])
}

# The public IP SKU must match the NAT Gateway SKU (Standard <-> Standard, StandardV2 <-> StandardV2),
# and a zonal NAT Gateway needs its IP in the same zone.
resource "azurerm_public_ip" "nat" {
  count = local.nat_enabled ? 1 : 0

  name                = coalesce(var.nat_gateway.public_ip_name, "pip-${var.nat_gateway.name}")
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = var.nat_gateway.sku_name
  zones               = var.nat_gateway.zones
  tags                = var.tags
}

resource "azurerm_nat_gateway" "default" {
  count = local.nat_enabled ? 1 : 0

  name                    = var.nat_gateway.name
  resource_group_name     = var.resource_group_name
  location                = var.location
  sku_name                = var.nat_gateway.sku_name
  idle_timeout_in_minutes = var.nat_gateway.idle_timeout_in_minutes
  zones                   = var.nat_gateway.zones
  tags                    = var.tags
}

resource "azurerm_nat_gateway_public_ip_association" "default" {
  count = local.nat_enabled ? 1 : 0

  nat_gateway_id       = azurerm_nat_gateway.default[0].id
  public_ip_address_id = azurerm_public_ip.nat[0].id
}

resource "azurerm_subnet_nat_gateway_association" "subnet" {
  for_each = local.nat_subnet_keys

  subnet_id      = azurerm_subnet.subnet[each.value].id
  nat_gateway_id = azurerm_nat_gateway.default[0].id
}
