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
      address_prefixes = list(string)
      private_endpoint_network_policies = string
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

