resource "azurerm_virtual_network" "network" {
  address_space       = var.network_cidrs
  location            = local.resource_group.location
  name                = var.network_name
  resource_group_name = local.resource_group.name
}

resource "azurerm_subnet" "network" {
  address_prefixes                               = var.subnet_cidrs
  name                                           = "${var.network_name}-sn"
  resource_group_name                            = local.resource_group.name
  virtual_network_name                           = azurerm_virtual_network.network.name
  enforce_private_link_endpoint_network_policies = true
}