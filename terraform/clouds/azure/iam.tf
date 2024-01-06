resource "azurerm_role_assignment" "aks-network-identity-kubelet" {
  scope                = azurerm_virtual_network.network.id
  role_definition_name = "Network Contributor"
  principal_id         = module.aks[0].kubelet_identity.principal_id

  depends_on = [module.aks, azurerm_virtual_network.network]
}

resource "azurerm_role_assignment" "aks-network-identity-ssi" {
  scope                = azurerm_virtual_network.network.id
  role_definition_name = "Network Contributor"
  principal_id         = module.aks[0].cluster_identity.principal_id

  depends_on = [module.aks, azurerm_virtual_network.network]
}