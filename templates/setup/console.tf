
resource "null_resource" "console" {
  provisioner "local-exec" {
    command = "plural cd control-plane-values --name {{ .Cluster }} --dsn \"${module.mgmt.db_url}\" --domain {{ .Domain }} --file console.yaml"
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
  version          = "0.1.15"
  create_namespace = true
  timeout          = 300
  values           = [
    data.local_sensitive_file.console
  ]

  depends_on = [ null_resource.console, module.mgmt.cluster ]
}