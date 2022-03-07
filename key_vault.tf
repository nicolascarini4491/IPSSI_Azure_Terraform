# Création de mon Key Vault 
resource "azurerm_key_vault" "kv01" {
  name                        = "${var.name}keyvault"
  location                    = azurerm_resource_group.rg01.location
  resource_group_name         = azurerm_resource_group.rg01.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id    // ID du propriétaire du keyvault (AD, Utilisateur, Domaine...)
    object_id = data.azurerm_client_config.current.object_id    // Utilisateur ou Groupe qui vont avoir les droits suivants vont s'appliquer

    key_permissions = [       // Liste des autorisations sur les clés
      "get",
    ]

    secret_permissions = [    // Liste des autorisations sur les secrets
      "set",
      "backup",
      "get",
      "delete",
      "purge",
      "recover",
      "restore",
      "list"
    ]

    storage_permissions = [   // Liste des autorisations sur le stockage
      "get",
    ]
  }
  network_acls {
    default_action             = "Deny"
    bypass                     = "AzureServices"
    ip_rules                   = ["91.171.178.21"]
    virtual_network_subnet_ids = [azurerm_subnet.sbnet05.id]
  }
}

# Création d'un secret dans mon key vault
resource "azurerm_key_vault_secret" "s01" {
  name         = "${var.name}-secret"
  value        = random_password.password.result            // Récupère la valeur du password généré plus bas dans le code
  key_vault_id = azurerm_key_vault.kv01.id                  // ressource_key_vault . nom_TF . id (variable)
}

# Création d'un secret contenant le password admin des vm dans mon key vault
resource "azurerm_key_vault_secret" "s02" {
  name         = "${var.name}-secret-admin"
  value        = random_password.admin_password.result            // Récupère la valeur du admin_password généré plus bas dans le code
  key_vault_id = azurerm_key_vault.kv01.id                        // ressource_key_vault . nom_TF . id (variable)
}

# Génération d'un mdp aléatoire en sensitive value 
resource "random_password" "password" {
  length           = 20
  special          = true
  min_lower        = 1
  min_upper        = 1
  min_numeric      = 1
  min_special      = 1
  override_special = "_%@"
}

# Génération d'un mdp aléatoire pour l'administration 
resource "random_password" "admin_password" {
  length           = 10
  special          = true
  min_lower        = 1
  min_upper        = 1
  min_numeric      = 1
  min_special      = 1
  override_special = "*@"
}

## Tentative de génération de clé publique - échec
# resource "azurerm_ssh_public_key" "ssh-pkey01" {
#   name                = "nicolas-ssh_pkey01"
#   resource_group_name = azurerm_resource_group.rg01.name
#   location            = "West Europe"
#   public_key          = file("/home/super_admin/.ssh/id_rsa")
# }
