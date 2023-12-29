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
    value = local.db_url
    sensitive = true
}

output "runtime_ready" {
    value = helm_release.runtime
}