module "gcp" {
    source = "../terraform/clouds/gcp"
    project_id = "pluralsh-test-384515"
    cluster_name = "bootstrap-test"
    runtime_values_file = "../helm-values/runtime.yaml"
    deletion_protection = false
}
