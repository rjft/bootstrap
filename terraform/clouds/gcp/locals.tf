locals {
  db_url = format("postgresql://console:%s@%s:5432/console", random_password.password.result, try(module.pg[0].private_ip_address, ""))
}