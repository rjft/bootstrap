resource "linode_database_postgresql" "postgres" {
  count = var.create_db ? 1 : 0
  label = "console"
  engine_id = var.engine_id
  region = var.region
  type = var.db_size

  allow_list = var.db_allowlist
  cluster_size = 1
  encrypted = true
  replication_type = "semi_synch"
  replication_commit_type = "remote_write"
  ssl_connection = true

  updates {
    day_of_week = "saturday"
    duration = 1
    frequency = "monthly"
    hour_of_day = 22
    week_of_month = 2
  }
}
