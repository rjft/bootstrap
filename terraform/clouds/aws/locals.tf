locals {
  db_url = format("postgresql://console:%s@%s:5432/console", random_password.password.result, try(module.db[0].db_instance_address, ""))
}