resource "random_password" "password" {
  length      = 20
  min_lower   = 1
  min_numeric = 1
  min_upper   = 1
  special     = false
}

module "postgresql" {
  count = var.create_db ? 1 : 0
  source = "Azure/postgresql/azurerm"

  resource_group_name = local.resource_group.name
  location            = local.resource_group.location

  server_name                   = local.db_name
  sku_name                      = var.db_sku
  storage_mb                    = 5120
  auto_grow_enabled             = true
  backup_retention_days         = 7
  geo_redundant_backup_enabled  = false
  administrator_login           = "console"
  administrator_password        = random_password.password.result
  server_version                = "11"
  ssl_enforcement_enabled       = true
  public_network_access_enabled = false
  db_names                      = ["console"]
  db_charset                    = "UTF8"
  db_collation                  = "English_United States.1252"
}

resource "azurerm_private_endpoint" "pg" {
  count = var.create_db ? 1 : 0

  name                = "${local.resource_group.name}-${local.db_name}"
  location            = local.resource_group.location
  resource_group_name = local.resource_group.name
  subnet_id           = azurerm_subnet.network.id

  private_service_connection {
    name                           = "${local.resource_group.name}-${local.db_name}"
    private_connection_resource_id = module.postgresql[0].server_id
    subresource_names              = ["postgresqlServer"]
    is_manual_connection           = false
  }
}