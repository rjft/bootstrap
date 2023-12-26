
locals {
  resource_group = {
    name     = var.create_resource_group ? azurerm_resource_group.main[0].name : var.resource_group_name
    location = var.location
  }
  db_url = format("postgresql://console:%s@%s:5432/console", random_password.password.result, module.postgresql.server_fqdn)
}