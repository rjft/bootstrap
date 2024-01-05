module "aks" {
  source = "Azure/aks/azurerm"
  version = "7.5.0"

  kubernetes_version  = var.kubernetes_version
  cluster_name        = var.cluster_name
  resource_group_name = local.resource_group.name
  prefix              = var.cluster_name
  os_disk_size_gb     = 60
  sku_tier            = "Standard"
  rbac_aad            = true
  vnet_subnet_id      = azurerm_subnet.network.id
  node_pools          = {for name, pool in var.node_pools : name => merge({vnet_subnet_id = azurerm_subnet.network.id}, pool)}
}