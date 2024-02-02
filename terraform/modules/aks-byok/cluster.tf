
data "azurerm_kubernetes_cluster" "cluster" {
  name = var.cluster_name
  resource_group_name = var.resource_group_name
}

resource "plural_cluster" "this" {
    handle   = var.cluster_handle
    name     = var.cluster_name
    tags     = var.tags
    protect  = var.protect
    # bindings = var.bindings
    kubeconfig = {
      host                   = data.azurerm_kubernetes_cluster.cluster.kube_config[0].host
      client_certificate     = base64decode(data.azurerm_kubernetes_cluster.cluster.kube_config[0].client_certificate)
      client_key             = base64decode(data.azurerm_kubernetes_cluster.cluster.kube_config[0].client_key)
      cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.cluster.kube_config[0].cluster_ca_certificate)
    }
}