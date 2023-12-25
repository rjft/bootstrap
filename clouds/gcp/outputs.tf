output "cluster" {
    value = module.gke
}

output "network" {
    value = module.gcp-network
}

output "db" {
    value = module.pg
}

output "db_url" {
    value = format("postgresql://console:%s@%s:5432/plural", random_password.password.result, module.pg.dns_name)
    sensitive = true
}