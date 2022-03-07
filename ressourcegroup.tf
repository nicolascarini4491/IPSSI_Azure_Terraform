# Création de mon groupe de ressources (RESSOURCE GROUP) 
# variable "NBR_RG" {
#     type = "number"
#     default = 2
# }

# Création de trois groupes de ressources à l'aide d'une boucle COUNT
resource "azurerm_resource_group" "rg02" {                  // azurerm_resource_group.rg02[0] , azurerm_resource_group.rg02[1] , azurerm_resource_group.rg02[2]
    count = 3
    name          = "rg-clone-${var.name}${count.index}"        // rg-clone-nicolas0 , rg-clone-nicolas1 , rg-clone-nicolas2                         
    location      = var.location                            // Utilisation de la variable "Location" présente dans variable.tf                                 
}

# Création d'un log analytics workspace rattaché au 2e RG créé dans la boucle COUNT  
resource "azurerm_log_analytics_workspace" "logws02" {
  name                = "${var.name}-log-ws"
  location            = azurerm_resource_group.rg02[1].location
  resource_group_name = azurerm_resource_group.rg02[1].name
  sku                 = "PerGB2018"
  retention_in_days   = var.retention
}
