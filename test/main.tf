module "gcp" {
    source = "../terraform/clouds/gcp"
    project_id = "pluralsh-test-384515"
    cluster_name = "bootstrap-test"
    network = "plrl-network"
    subnetwork = "plrl-subnetwork"
    allocated_range_name = "google-managed-services"
    deletion_protection = false
}

resource "helm_release" "runtime" {
  name             = "runtime"
  namespace        = "plural-runtime"
  chart            = "runtime"
  repository       = "https://pluralsh.github.io/bootstrap"
  version          = "0.1.8"
  create_namespace = true
  timeout          = 600
  values           = [
    file("${path.module}/../helm-values/runtime.yaml")
  ]

  depends_on = [ module.gcp.cluster ]
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

  depends_on = [ module.gcp.cluster, helm_release.runtime, module.gcp.db_url ]
}