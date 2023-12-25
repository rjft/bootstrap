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
    value = format("postgresql://console:%s@%s:5432/console", random_password.password.result, module.postgresql.server_fqdn)
    sensitive = true
}