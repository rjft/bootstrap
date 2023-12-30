module "mgmt" {
    source              = "../bootstrap/terraform/clouds/gcp"
    project_id          = "{{ .Project }}"
    cluster_name        = "{{ .Cluster }}"
    runtime_values_file = "../helm-values/runtime.yaml"
}