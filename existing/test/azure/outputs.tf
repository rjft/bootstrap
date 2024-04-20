output "identity_client_id" {
  value = module.externaldns.externaldns_client_id
}

output "db_url" {
  value = module.mgmt.db_url
  sensitive = true
}