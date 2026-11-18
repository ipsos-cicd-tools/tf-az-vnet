<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.8.2 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 5.0.0, < 6.0.0 |

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 5.14.0 |

## Modules

No modules.

## Resources

| Name | Type |
| ---- | ---- |
| [azurerm_nat_gateway.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/nat_gateway) | resource |
| [azurerm_nat_gateway_public_ip_association.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/nat_gateway_public_ip_association) | resource |
| [azurerm_public_ip.nat](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_subnet.subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet_nat_gateway_association.subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_nat_gateway_association) | resource |
| [azurerm_virtual_network.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_address_space"></a> [address\_space](#input\_address\_space) | (Required) The address space that is used the virtual network. You can supply more than one address space. | `list(string)` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | (Required) The location/region where the RG and virtual network is created. Changing this forces new resources to be created. | `string` | n/a | yes |
| <a name="input_nat_gateway"></a> [nat\_gateway](#input\_nat\_gateway) | Optional NAT Gateway with a static public IP for fixed-address outbound internet access. Attach it to subnets with subnets[*].nat\_gateway\_enabled. Null (default) creates nothing. | <pre>object({<br/>    name                    = string<br/>    sku_name                = optional(string, "Standard")<br/>    idle_timeout_in_minutes = optional(number, 4)<br/>    # Standard: omit for no-zone or set a single zone. StandardV2: must be omitted (zone-redundant).<br/>    zones = optional(list(string))<br/>    # Defaults to "pip-<name>".<br/>    public_ip_name = optional(string)<br/>  })</pre> | `null` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | n/a | `string` | n/a | yes |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | Subnets to create | <pre>map(object(<br/>    {<br/>      # name             = string<br/>      address_prefixes                  = list(string)<br/>      private_endpoint_network_policies = string<br/>      service_endpoints                 = optional(list(string))<br/>      # Route this subnet's outbound internet traffic through var.nat_gateway.<br/>      nat_gateway_enabled = optional(bool, false)<br/>      # null = provider default. Set false so NAT/firewall is the only egress path.<br/>      default_outbound_access_enabled = optional(bool)<br/>      delegation = optional(list(<br/>        object({<br/>          name = string<br/>          service_delegation = object({<br/>            name    = string<br/>            actions = optional(list(string))<br/>          })<br/>      })))<br/>  }))</pre> | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(string)` | n/a | yes |
| <a name="input_vnet_name"></a> [vnet\_name](#input\_vnet\_name) | n/a | `string` | n/a | yes |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_nat_gateway_id"></a> [nat\_gateway\_id](#output\_nat\_gateway\_id) | ID of the NAT Gateway, or null when var.nat\_gateway is not set. |
| <a name="output_nat_public_ip"></a> [nat\_public\_ip](#output\_nat\_public\_ip) | Static egress IP of the NAT Gateway (share with parties that allowlist source IPs), or null when var.nat\_gateway is not set. |
| <a name="output_nat_public_ip_id"></a> [nat\_public\_ip\_id](#output\_nat\_public\_ip\_id) | ID of the NAT Gateway public IP, or null when var.nat\_gateway is not set. |
| <a name="output_subnet_ids"></a> [subnet\_ids](#output\_subnet\_ids) | n/a |
| <a name="output_vnet_id"></a> [vnet\_id](#output\_vnet\_id) | n/a |
| <a name="output_vnet_name"></a> [vnet\_name](#output\_vnet\_name) | n/a |
<!-- END_TF_DOCS -->