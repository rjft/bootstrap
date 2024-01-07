locals {
  db_url = var.create_db ? format("postgresql://%s:%s@%s:5432/console", linode_database_postgresql.postgres[0].root_username, linode_database_postgresql.postgres[0].root_password, linode_database_postgresql.postgres[0].host_primary) : ""
}