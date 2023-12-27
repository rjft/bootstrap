provider "helm" {
  kubernetes {
    host                   = module.aks.cluster_fqdn
    cluster_ca_certificate = base64decode(module.aks.cluster_ca_certificate)
    client_certificate     = base64decode(module.aks.client_certificate)
    client_key             = base64decode(module.aks.client_key)
  }
}

resource "helm_release" "runtime" {
  name             = "runtime"
  namespace        = "plural-runtime"
  chart            = "runtime"
  repository       = "https://pluralsh.github.io/bootstrap"
  version          = "0.1.3"
  create_namespace = true
  timeout          = 300
  values           = [
    file(var.runtime_values_file)
  ]
}