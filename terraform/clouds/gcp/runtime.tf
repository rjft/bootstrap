
resource "helm_release" "runtime" {
  name             = "runtime"
  namespace        = "plural-runtime"
  chart            = "runtime"
  repository       = "https://pluralsh.github.io/bootstrap"
  version          = var.runtime_vsn
  create_namespace = true
  timeout          = 300
  values           = [
    file(var.runtime_values_file)
  ]
}