module "mgmt" {
  source = "../../../terraform/clouds/azure"

  cluster_name = "plural-existing-test"
  network_name = "plural-existing-test"
  location     = "eastus"
  db_name      = "plural-existing-test" 

  postgres_dns_zone = "plrl-test.postgres.database.azure.com"
  network_link_name = "plrl-test.postgres.com"

  workload_identity_enabled = true
}