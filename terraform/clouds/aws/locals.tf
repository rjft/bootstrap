locals {
  db_url = format("postgresql://console:%s@%s:5432/console", random_password.password.result, module.db.db_instance_address)
}