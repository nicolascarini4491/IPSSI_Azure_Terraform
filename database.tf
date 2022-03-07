# # Création d'un serveur MSSQL
# resource "azurerm_mssql_server" "msqlssrv01" {
#   name                         = "nicolasmssqlserver"
#   resource_group_name          = azurerm_resource_group.rg01.name
#   location                     = azurerm_resource_group.rg01.location
#   version                      = "12.0"
#   administrator_login          = "missadministrator"
#   administrator_login_password = random_password.password.result
#   minimum_tls_version          = "1.2"
# }

# # Création d'une base de données MSSQL ServerLess
# resource "azurerm_mssql_database" "db01" {
#     name                        = "nicolas-serverless-db"
#     server_id                   = azurerm_mssql_server.msqlssrv01.id    // Ressource_mssql_server . nom_mssqlserver_TF . id (variable)
#     collation                   = "SQL_Latin1_General_CP1_CI_AS"
#     license_type                = "BasePrice"
#     auto_pause_delay_in_minutes = 120                                   // Temps en minutes après lequel la base de données est automatiquement mise en pause
#     max_size_gb                 = 1
#     min_capacity                = 0.5                                   // Doit être précisé et différent de '0' pour ce type de 'sku_name' 
#     read_replica_count          = 0
#     sku_name                    = "GP_S_Gen5_1"                         // Nombre maximal de VCores : 0.5 - 1
#     zone_redundant              = false
# }
