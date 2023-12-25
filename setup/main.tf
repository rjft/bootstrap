
resource "kubernetes_namespace" "plural-runtime" {
  metadata {
    name = "plural-runtime"
    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = "runtime"
    }
  }

  depends_on = [ var.cluster_endpoint ]
}

provider "helm" {}

resource "helm_release" "runtime" {
  name       = "runtime"
  namespace  = "plural-runtime"
  chart      = "../charts/runtime"
  timeout    = 1200
  values     = [
    file(var.values_file)
  ]

  depends_on = [ kubernetes_namespace.plural-runtime.id ]
}