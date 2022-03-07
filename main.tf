terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.46.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

# Création de mon groupe de ressources (RESSOURCE GROUP) 
resource "azurerm_resource_group" "rg01" {
  name          = "rg-${var.name}"                                          // Nom du groupe de ressource dans Azure 
  location      = "West Europe"                                             // Définir la géolocalisation du DC Miscrosoft Azure 
}

# Création de mon storage account 
resource "azurerm_storage_account" "st01" {
  name                      = "stripssi${var.name}"
  resource_group_name       = azurerm_resource_group.rg01.name               // Variable name -> "rg-${var.name}"
  location                  = azurerm_resource_group.rg01.location           // Variable location -> "West Europe"
  account_tier              = "Standard"                                     // Standard pour HDD, Premium pour SSD
  account_replication_type  = "LRS"                                          // GRS, LRS, ZRS... Type de réplication utilisée 
  access_tier               = "Cool"                                         // Cool / Hot : Cool -> accès très fréquent mais un espace de stockage normal
                                                                            //              Hot  -> accès peu fréquent mais un grand espace de stockage 
  network_rules {
    default_action             = "Deny"
    ip_rules                   = ["91.171.178.21"]
    virtual_network_subnet_ids = [azurerm_subnet.sbnet05.id]
  }
}

# Création d'un container 
resource "azurerm_storage_container" "cont01" {
  name                  = "${var.name}container"
  storage_account_name  = azurerm_storage_account.st01.name
  container_access_type = "private"
}

# Création d'un deuxième container à l'aide du data source de Matthew 
# resource "azurerm_storage_container" "cont02" {
#   name                  = "matthew-container"
#   storage_account_name  = data.azurerm_storage_account.stripssimatthew.name   // data . ressource_storage_account . nomTF du datasource . name (variable)
#   container_access_type = "private"
# }

# # Création d'un deuxième container à l'aide du data source du prof
# resource "azurerm_storage_container" "cont03" {
#   name                  = "raphael-container"
#   storage_account_name  = data.azurerm_storage_account.storage_raphael.name   // data . ressource_storage_account . nomTF . name (variable)
#   container_access_type = "private"
# }