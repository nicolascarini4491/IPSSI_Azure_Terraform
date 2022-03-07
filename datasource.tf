# Création d'un datasource un peu particulier...
data "azurerm_client_config" "current" {}  // Data source : permet d'utiliser des données externes au code

# # Création d'un data source du storage account prof
# data "azurerm_storage_account" "storage_raphael" {
#   name                = "storageraphael"
#   resource_group_name = "rg-raphael"
# }

# # Création d'un data source du storage account prof
# data "azurerm_storage_account" "stripssimatthew" {
#   name                = "stripssimatthew"
#   resource_group_name = "rg-matthew"
# }

# Création d'une "sas-key" afin de lier mon compte de stockage 'st01' à l'application Microsoft Azure Storage Explorer  
data "azurerm_storage_account_sas" "saskey01" {
  connection_string = azurerm_storage_account.st01.primary_connection_string
  https_only        = true
  signed_version    = "2017-07-29"

  resource_types {
    service   = true
    container = true
    object    = true
  }

  services {
    blob  = true
    queue = false
    table = false
    file  = false
  }

  start  = "2018-03-21T00:00:00Z"
  expiry = "2020-03-21T00:00:00Z"

  permissions {
    read    = true
    write   = true
    delete  = false
    list    = false
    add     = true
    create  = true
    update  = false
    process = false
  }
}

output "sas_url_query_string" {
  value = data.azurerm_storage_account_sas.saskey01.sas
  sensitive = true
}