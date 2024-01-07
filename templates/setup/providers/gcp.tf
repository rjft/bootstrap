module "mgmt" {
    source        = "../bootstrap/terraform/clouds/gcp"
    project_id    = "{{ .Project }}"
    cluster_name  = "{{ .Cluster }}"
    region        = "{{ .Region }}"
}