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

  server_name                   = var.postgres_name
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

  vnet_rule_name_prefix = "plural-postgresql-vnet-rule-"
  vnet_rules = [
    { name = "subnet1", subnet_id = azurerm_subnet.network.id }
  ]
}