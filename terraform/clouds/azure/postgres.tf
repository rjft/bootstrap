resource "random_password" "password" {
  length      = 20
  min_lower   = 1
  min_numeric = 1
  min_upper   = 1
  special     = false
}

resource "azurerm_private_dns_zone" "postgres" {
  count = var.create_db ? 1 : 0

  name                = "plrl.database.azure.com"
  resource_group_name = local.resource_group.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "postgres" {
  count = var.create_db ? 1 : 0

  name                  = "plrl.postgres.com"
  private_dns_zone_name = azurerm_private_dns_zone.postgres[0].name
  virtual_network_id    = azurerm_virtual_network.network.id
  resource_group_name   = local.resource_group.name
}

resource "azurerm_postgresql_flexible_server" "postgres" {
  count = var.create_db ? 1 : 0
  name                   = var.db_name
  resource_group_name    = local.resource_group.name
  location               = local.resource_group.location
  version                = "13"
  delegated_subnet_id    = azurerm_subnet.postgres.id
  private_dns_zone_id    = azurerm_private_dns_zone.postgres[0].id
  administrator_login    = "console"
  administrator_password = random_password.password.result
  zone                   = "1"

  storage_mb = var.postgres_disk
  sku_name   = var.postgres_sku

  high_availability {
    mode = "ZoneRedundant"
  }

  lifecycle {
    ignore_changes = [ zone ]
  }
}

resource "azurerm_postgresql_flexible_server_database" "example" {
  count     = var.create_db ? 1 : 0
  name      = "console"
  server_id = azurerm_postgresql_flexible_server.postgres[0].id
  collation = "en_US.utf8"
  charset   = "utf8"
}