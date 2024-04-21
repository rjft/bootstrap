data "azurerm_kubernetes_cluster" "cluster" {
    name = var.cluster_name
    resource_group_name = var.resource_group
}

resource "azurerm_federated_identity_credential" "externaldns" {
  name                = "fc-externaldns"
  resource_group_name = var.resource_group
  audience            = ["api://AzureADTokenExchange"]
  issuer              = data.azurerm_kubernetes_cluster.cluster.oidc_issuer_url
  parent_id           = azurerm_user_assigned_identity.externaldns.id
  subject             = "system:serviceaccount:plrl-runtime:externaldns"
}

resource "azurerm_federated_identity_credential" "certmanager" {
  name                = "fc-cert-manager"
  resource_group_name = var.resource_group
  audience            = ["api://AzureADTokenExchange"]
  issuer              = data.azurerm_kubernetes_cluster.cluster.oidc_issuer_url
  parent_id           = azurerm_user_assigned_identity.externaldns.id
  subject             = "system:serviceaccount:cert-manager:cert-manager"
}