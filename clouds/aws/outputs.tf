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
    value = format("postgresql://console:%s@%s:5432/console", random_password.password.result, module.db.db_instance_address)
    sensitive = true
}