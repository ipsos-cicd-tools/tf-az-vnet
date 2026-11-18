# Plan-only tests with a mocked provider: no Azure credentials needed.
# Run from this directory with `terraform init -backend=false && terraform test`.
mock_provider "azurerm" {}

variables {
  resource_group_name = "rg"
  location            = "northeurope"
  tags                = {}
  vnet_name           = "vnet"
  address_space       = ["10.0.0.0/24"]
}

run "no_nat_by_default" {
  command = plan
  variables {
    subnets = { a = { address_prefixes = ["10.0.0.0/27"], private_endpoint_network_policies = "Enabled" } }
  }
  assert {
    condition     = length(azurerm_nat_gateway.default) == 0 && length(azurerm_public_ip.nat) == 0 && length(azurerm_subnet_nat_gateway_association.subnet) == 0
    error_message = "NAT resources must not be created unless var.nat_gateway is set."
  }
}

run "service_endpoints_list_to_blocks" {
  command = plan
  variables {
    subnets = { a = { address_prefixes = ["10.0.0.0/27"], private_endpoint_network_policies = "Enabled", service_endpoints = ["Microsoft.Storage", "Microsoft.KeyVault"] } }
  }
  assert {
    condition     = toset([for e in azurerm_subnet.subnet["a"].service_endpoint : e.service]) == toset(["Microsoft.Storage", "Microsoft.KeyVault"])
    error_message = "service_endpoints list must map to one service_endpoint block per service."
  }
}

run "nat_on_selected_subnet" {
  command = plan
  variables {
    nat_gateway = { name = "ng" }
    subnets = {
      a = { address_prefixes = ["10.0.0.0/27"], private_endpoint_network_policies = "Enabled", nat_gateway_enabled = true }
      b = { address_prefixes = ["10.0.0.32/27"], private_endpoint_network_policies = "Enabled" }
    }
  }
  assert {
    condition     = length(azurerm_nat_gateway.default) == 1 && keys(azurerm_subnet_nat_gateway_association.subnet) == ["a"] && azurerm_public_ip.nat[0].name == "pip-ng"
    error_message = "NAT Gateway must attach only to subnets with nat_gateway_enabled = true."
  }
}

run "nat_flag_without_gateway_fails" {
  command = plan
  variables {
    subnets = { a = { address_prefixes = ["10.0.0.0/27"], private_endpoint_network_policies = "Enabled", nat_gateway_enabled = true } }
  }
  expect_failures = [azurerm_subnet.subnet]
}

run "v2_with_zones_rejected" {
  command = plan
  variables {
    nat_gateway = { name = "ng", sku_name = "StandardV2", zones = ["1"] }
    subnets     = {}
  }
  expect_failures = [var.nat_gateway]
}
