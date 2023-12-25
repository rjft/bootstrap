
module "runtime" {
  count = var.install_runtime ? 1 : 0
  source = "../../setup"
  cluster_endpoint = module.aks.cluster_fqdn
}