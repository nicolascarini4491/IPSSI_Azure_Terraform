# Création d'un espace de travail log analytics (pour les données de journal d'activité Azure Monitor)
resource "azurerm_log_analytics_workspace" "logws01" {                    
  name                = "${var.name}-log-ws"
  location            = azurerm_resource_group.rg01.location
  resource_group_name = azurerm_resource_group.rg01.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_monitor_diagnostic_setting" "mds01" {
  name               = "${var.name}-mds"
  target_resource_id = azurerm_key_vault.kv01.id                            // id de mon key vault (Cible des logs et metrics)
  // storage_account_id = azurerm_storage_account.st01.id                      
  log_analytics_workspace_id = azurerm_log_analytics_workspace.logws01.id   // id de mon log analytics workspace (Destination de stockage des logs et des metrics)

  log {
    category = "AzurePolicyEvaluationDetails"
    enabled  = true

    retention_policy {                                                      // Envoie officiellement les logs
      enabled = true
    }
  }

  log {
    category = "AuditEvent"
    enabled  = true

    retention_policy {
      enabled = true
    }
  }

  metric {
    category = "AllMetrics"

    retention_policy {
      enabled = true 
    }
  }
}

# Création d'un Monitor Action Group (groupe d'utilisateurs) à prévenir en cas d'alertes
resource "azurerm_monitor_action_group" "monitor-ag01" {
  name                = "nicolas-monitoractiongroup"
  resource_group_name = azurerm_resource_group.rg01.name
  short_name          = "MAG01"

  email_receiver {
    name          = var.name
    email_address = var.mail-nicolas
  }
  email_receiver {
    name          = var.name-raphael
    email_address = var.mail-raphael
  }
  email_receiver {
    name          = var.name-matthew
    email_address = var.mail-matthew
  }
}

# Création d'une alerte
resource "azurerm_monitor_metric_alert" "alert-cpu90-vm01" {
name                = "nicolas-alert-90cpu-vm"
resource_group_name = azurerm_resource_group.rg01.name
scopes              = [azurerm_virtual_machine.main.id]
description         = "CPU de la VM > 90%"
target_resource_location = azurerm_virtual_machine.main.location
target_resource_type = "Microsoft.Compute/virtualMachines"

  criteria {
    metric_namespace = "Microsoft.Compute/virtualMachines"
    metric_name = "Percentage CPU"
    operator    = "GreaterThan"
    threshold   = 90
    aggregation = "Maximum"
  }

  action {
    action_group_id = azurerm_monitor_action_group.monitor-ag01.id
  }  
}