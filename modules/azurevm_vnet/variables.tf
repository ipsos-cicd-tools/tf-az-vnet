variable "resource_group_name" {
  type     = string
  nullable = false
}

variable "location" {
  type        = string
  description = "(Required) The location/region where the RG and virtual network is created. Changing this forces new resources to be created."
  nullable    = false
}

variable "tags" {
  type = map(string)
}

variable "vnet_name" {
  type     = string
  nullable = false
}

variable "address_space" {
  type        = list(string)
  description = " (Required) The address space that is used the virtual network. You can supply more than one address space."
  nullable    = false

  validation {
    condition     = length(var.address_space) > 0
    error_message = "Please provide at least one cidr as address space."
  }
}

variable "subnets" {
  type = map(object(
    {
      # name             = string
      address_prefixes                  = list(string)
      private_endpoint_network_policies = string
      service_endpoints                 = optional(list(string))
      # Route this subnet's outbound internet traffic through var.nat_gateway.
      nat_gateway_enabled = optional(bool, false)
      # null = provider default. Set false so NAT/firewall is the only egress path.
      default_outbound_access_enabled = optional(bool)
      delegation = optional(list(
        object({
          name = string
          service_delegation = object({
            name    = string
            actions = optional(list(string))
          })
      })))
  }))
  #   validation {
  #     condition     = alltrue([for s in var.subnets : can(regex("^[a-zA-Z0-9_-]+$", s.name))])
  #     error_message = "The subnet name must only contain letters, numbers, hyphens or underscores."
  #   }
  description = "Subnets to create"
}

variable "nat_gateway" {
  type = object({
    name                    = string
    sku_name                = optional(string, "Standard")
    idle_timeout_in_minutes = optional(number, 4)
    # Standard: omit for no-zone or set a single zone. StandardV2: must be omitted (zone-redundant).
    zones = optional(list(string))
    # Defaults to "pip-<name>".
    public_ip_name = optional(string)
  })
  default     = null
  description = "Optional NAT Gateway with a static public IP for fixed-address outbound internet access. Attach it to subnets with subnets[*].nat_gateway_enabled. Null (default) creates nothing."

  validation {
    condition     = var.nat_gateway == null || contains(["Standard", "StandardV2"], try(var.nat_gateway.sku_name, ""))
    error_message = "nat_gateway.sku_name must be Standard or StandardV2."
  }

  validation {
    condition     = var.nat_gateway == null || try(var.nat_gateway.sku_name, "") != "StandardV2" || try(var.nat_gateway.zones, null) == null
    error_message = "nat_gateway.zones must be omitted when sku_name is StandardV2."
  }

  validation {
    condition     = var.nat_gateway == null || (try(var.nat_gateway.idle_timeout_in_minutes, 4) >= 4 && try(var.nat_gateway.idle_timeout_in_minutes, 4) <= 120)
    error_message = "nat_gateway.idle_timeout_in_minutes must be between 4 and 120."
  }
}

