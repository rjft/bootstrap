locals {
  db_name = var.db_name == "" ? "${var.cluster_name}-plural-db" : var.db_name
  db_url = format("postgresql://console:%s@%s:5432/console", random_password.password.result, try(module.db[0].db_instance_address, ""))
}