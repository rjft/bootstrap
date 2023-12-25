provider "helm" {
  kubernetes {
    host                   = module.aks.cluster_fqdn
    cluster_ca_certificate = base64decode(module.aks.cluster_ca_certificate)
    client_certificate     = base64decode(module.aks.client_certificate)
    client_key             = base64decode(module.aks.client_key)
  }
}

module "runtime" {
  count = var.install_runtime ? 1 : 0
  source = "../../setup"
  cluster_endpoint = module.aks.cluster_fqdn
}