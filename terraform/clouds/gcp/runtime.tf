data "google_client_config" "current" {}

provider "helm" {
  kubernetes {
    host                   = module.gke.endpoint
    cluster_ca_certificate = base64decode(module.gke.ca_certificate)
    token                  = data.google_client_config.current.access_token
  }
}

resource "helm_release" "runtime" {
  name       = "runtime"
  namespace  = "plural-runtime"
  chart      = "${path.module}/../../../charts/runtime"
  create_namespace = true
  timeout    = 300
  values     = [
    file(var.runtime_values_file)
  ]
}