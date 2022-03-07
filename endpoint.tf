# Création d'un endpoint (=carte réseau) associer à mon keyvault et connecté au sous réseau sécurité (subnet-security // sbnet05)
resource "azurerm_private_endpoint" "endpoint01" {
  name                = "nicolas-IPSSI-endpoint"
  location            = azurerm_resource_group.rg01.location
  resource_group_name = azurerm_resource_group.rg01.name
  subnet_id           = azurerm_subnet.sbnet05.id                           // ID du sous réseau dans lequel va se trouver la ressource 

  private_service_connection {
    name                           = "nicolas-kv-psc"
    private_connection_resource_id = azurerm_key_vault.kv01.id              // ID de la ressource cible (ici le keyvault)
    is_manual_connection           = false
    subresource_names              = ["vault"]                              // précise le type de ressource cible 
  }
}
