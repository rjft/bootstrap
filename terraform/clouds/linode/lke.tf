resource "linode_lke_cluster" "mgmt" {
  label       = var.cluster_name
  k8s_version = var.kubernetes_vsn
  region      = var.region

  dynamic "pool" {
    for_each = var.node_pools
    content {
      type = pool.value.type
      count = pool.value.count
      autoscaler {
        min = pool.value.autoscaler.min
        max = pool.value.autoscaler.max
      }
    }
  }
}