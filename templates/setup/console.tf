resource "helm_release" "runtime" {
  name             = "runtime"
  namespace        = "plural-runtime"
  chart            = "runtime"
  repository       = "https://pluralsh.github.io/bootstrap"
  version          = "0.1.10"
  create_namespace = true
  timeout          = 600
  values           = [
    file("${path.module}/../helm-values/runtime.yaml")
  ]

  depends_on = [ module.mgmt.cluster ]
}

resource "null_resource" "console" {
  provisioner "local-exec" {
    command = "plural cd control-plane-values --name {{ .Cluster }} --dsn \"${module.mgmt.db_url}\" --domain {{ .Subdomain }} --file console.yaml"
    working_dir = "${path.module}/../helm-values"
  }
}

data "local_sensitive_file" "console" {
  filename = "${path.module}/../helm-values/console.yaml"
  depends_on = [ null_resource.console ]
}

resource "helm_release" "console" {
  name             = "console"
  namespace        = "plrl-console"
  chart            = "console"
  repository       = "https://pluralsh.github.io/console"
  version          = "0.1.21"
  create_namespace = true
  timeout          = 300
  values           = [
    data.local_sensitive_file.console.content
  ]

  depends_on = [ module.mgmt.cluster, helm_release.runtime, module.mgmt.db_url ]
}