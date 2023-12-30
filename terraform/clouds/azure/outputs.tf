output "cluster" {
    value = module.aks
}

output "network" {
    value = azurerm_virtual_network.network
}

output "db" {
    value = module.postgresql
}

output "db_url" {
    value = local.db_url
    sensitive = true
}
