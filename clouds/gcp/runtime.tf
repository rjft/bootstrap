data "google_client_config" "current" {}

provider "helm" {
  kubernetes {
    host                   = module.gke.endpoint
    cluster_ca_certificate = base64decode(module.gke.ca_certificate)
    token                  = data.google_client_config.current.access_token
  }
}

module "runtime" {
  count = var.install_runtime ? 1 : 0
  source = "../../setup"
  cluster_endpoint = module.aks.cluster_fqdn
}