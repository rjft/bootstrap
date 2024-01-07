output "cluster" {
  value = linode_lke_cluster.mgmt
}

output "ready" {
  value = linode_lke_cluster.mgmt
}

output "db_url" {
  value = local.db_url
}