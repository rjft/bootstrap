module "gcp" {
    source = "../terraform/clouds/gcp"
    project_id = "pluralsh-test-384515"
    cluster_name = "bootstrap-test"
    runtime_values_file = "../helm-values/runtime.yaml"
    deletion_protection = false
}

resource "null_resource" "console" {
  provisioner "local-exec" {
    command = "plural cd control-plane-values --name bootstrap-test --dsn \"${module.gcp.db_url}\" --domain plrl.onplural.sh --file console.yaml"
    working_dir = "${path.module}/../helm-values"
  }
}

# hack around a helm provider bug
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
    data.local_sensitive_file.console.content
  ]

  depends_on = [ null_resource.console, module.gcp.cluster ]
}