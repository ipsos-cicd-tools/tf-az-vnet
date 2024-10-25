<!-- BEGIN_TF_DOCS -->
## Usage
Basic usage of this module is as follows:
```
module "azurevm_vnet" {
  source  = "git::https://github.com/ipsos-cicd-tools/<repo name>//modules/azurevm_vnet?ref=<version number>"
  
  ## Required Variables ##
  address_space  = 
  location  = 
  resource_group_name  = 
  subnets  = 
  tags  = 
  vnet_name  = 
}
```
## Resources

| Name | Type |
|------|------|
| [azurerm_subnet.subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_virtual_network.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) | resource |
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_address_space"></a> [address\_space](#input\_address\_space) | (Required) The address space that is used the virtual network. You can supply more than one address space. | `list(string)` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | (Required) The location/region where the RG and virtual network is created. Changing this forces new resources to be created. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | n/a | `string` | n/a | yes |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | Subnets to create | <pre>map(object(<br/>    {<br/>      # name             = string<br/>      address_prefixes                  = list(string)<br/>      private_endpoint_network_policies = string<br/>      delegation = optional(list(<br/>        object({<br/>          name = string<br/>          service_delegation = object({<br/>            name    = string<br/>            actions = optional(list(string))<br/>          })<br/>      })))<br/>  }))</pre> | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(string)` | n/a | yes |
| <a name="input_vnet_name"></a> [vnet\_name](#input\_vnet\_name) | n/a | `string` | n/a | yes |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_subnet_ids"></a> [subnet\_ids](#output\_subnet\_ids) | n/a |
| <a name="output_vnet_id"></a> [vnet\_id](#output\_vnet\_id) | n/a |
| <a name="output_vnet_name"></a> [vnet\_name](#output\_vnet\_name) | n/a |
<!-- END_TF_DOCS -->