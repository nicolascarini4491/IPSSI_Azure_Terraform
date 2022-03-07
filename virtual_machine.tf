# Déploiement d'une VM Ubuntu associée à l'interface network créé dans network.tf 
resource "azurerm_virtual_machine" "main" {
  name                  = "${var.name}-vm"
  location              = azurerm_resource_group.rg01.location
  resource_group_name   = azurerm_resource_group.rg01.name
  network_interface_ids = [azurerm_network_interface.net-int01.id]      // association avec l'interface réseau "net-int01" (voir network.tf)
  vm_size               = "Standard_B1ls"                               // Azure VM Size : influence le prix de la VM (voir azureprice.net)

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk2"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"                                  
  }
  os_profile {
    computer_name  = "Ubuntu18.4-01"                                    // Hostname
    admin_username = "super_admin"                                      // Nom du super utilisateur (=root)
    admin_password = random_password.admin_password.result              // Récupération du mot de passe d'administration généré (voir keyvault.tf)
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
}
