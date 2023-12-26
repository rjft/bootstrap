locals {
  db_url = format("postgresql://console:%s@%s:5432/plural", random_password.password.result, module.pg.dns_name)
}