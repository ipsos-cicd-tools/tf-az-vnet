terraform {
  required_version = ">=1.8.2"

  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      # 5.x: subnet service endpoints are `service_endpoint` blocks (see main.tf).
      # Callers still on azurerm 4.x should stay on module 1.0.x.
      version = ">= 5.0.0, < 6.0.0"
    }
  }
}