module "mgmt" {
    source              = "../bootstrap/terraform/clouds/azure"
    resource_group_name = "{{ .Project }}"
    cluster_name        = "{{ .Cluster }}"
}