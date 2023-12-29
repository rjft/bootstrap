module "mgmt" {
    source              = "../terraform/clouds/azure"
    resource_group_name = "{{ .Project }}"
    cluster_name        = "{{ .Cluster }}"
    runtime_values_file = "../helm-values/runtime.yaml"
}