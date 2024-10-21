terraform {
  required_version = ">=1.8.2"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">4.81.0"
    }
  }
}