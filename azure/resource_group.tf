resource "azurerm_resource_group" "main" {
  location = var.location
  name     = coalesce(var.resource_group_name, "${random_id.prefix.hex}-rg")
}