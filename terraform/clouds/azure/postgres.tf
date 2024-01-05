resource "random_password" "password" {
  length      = 20
  min_lower   = 1
  min_numeric = 1
  min_upper   = 1
  special     = false
}

resource "azurerm_private_dns_zone" "postgres" {
  name                = "postgres.database.azure.com"
  resource_group_name = local.resource_group.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "postgres" {
  name                  = "plural.postgres.com"
  private_dns_zone_name = azurerm_private_dns_zone.postgres.name
  virtual_network_id    = azurerm_virtual_network.network.id
  resource_group_name   = local.resource_group.name
}

resource "azurerm_postgresql_flexible_server" "postgres" {
  name                   = var.db_name
  resource_group_name    = local.resource_group.name
  location               = local.resource_group.location
  version                = "13"
  delegated_subnet_id    = azurerm_subnet.postgres.id
  private_dns_zone_id    = azurerm_private_dns_zone.postgres.id
  administrator_login    = "console"
  administrator_password = random_password.password.result
  zone                   = "1"

  storage_mb = var.postgres_disk
  sku_name   = var.postgres_sku
}