output "cluster" {
    value = module.eks
}

output "vpc" {
    value = module.vpc
}

output "db" {
    value = module.db
    sensitive = true
}

output "db_url" {
    value = local.db_url
    sensitive = true
}

output "ready" {
    value = local.cluster_ready
}