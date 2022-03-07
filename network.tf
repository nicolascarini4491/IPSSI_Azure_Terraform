# Création d'un réseau virtuel dans Azure 
resource "azurerm_virtual_network" "vnet01" {
  name                = "${var.name}-IPSSI-VNet1"
  location            = azurerm_resource_group.rg01.location
  resource_group_name = azurerm_resource_group.rg01.name
  address_space       = ["192.16.0.0/16"]
  dns_servers         = ["192.16.254.6", "192.16.254.8"]        // Les serveurs DNS se trouveront dans le sous réseau dédié aux serveurs 
}

resource "azurerm_subnet" "sbnet01" {
  name                 = "default"
  resource_group_name  = azurerm_resource_group.rg01.name
  virtual_network_name = azurerm_virtual_network.vnet01.name
  address_prefixes     = ["192.16.1.0/24"]
  enforce_private_link_endpoint_network_policies = true
  enforce_private_link_service_network_policies  = true
  service_endpoints = ["Microsoft.KeyVault","Microsoft.Storage"]
}

resource "azurerm_subnet" "sbnet02" {
  name                 = "subnet-user"
  resource_group_name  = azurerm_resource_group.rg01.name
  virtual_network_name = azurerm_virtual_network.vnet01.name
  address_prefixes     = ["192.16.224.0/24"]
  enforce_private_link_endpoint_network_policies = true
  enforce_private_link_service_network_policies  = true
  service_endpoints = ["Microsoft.KeyVault","Microsoft.Storage"]
}

resource "azurerm_subnet" "sbnet03" {
  name                 = "subnet-switch"
  resource_group_name  = azurerm_resource_group.rg01.name
  virtual_network_name = azurerm_virtual_network.vnet01.name
  address_prefixes     = ["192.16.234.0/24"]
  enforce_private_link_endpoint_network_policies = true
  enforce_private_link_service_network_policies  = true
  service_endpoints = ["Microsoft.KeyVault","Microsoft.Storage"]
}

resource "azurerm_subnet" "sbnet04" {
  name                 = "subnet-server"
  resource_group_name  = azurerm_resource_group.rg01.name
  virtual_network_name = azurerm_virtual_network.vnet01.name
  address_prefixes     = ["192.16.254.0/24"]
  enforce_private_link_endpoint_network_policies = true
  enforce_private_link_service_network_policies  = true
  service_endpoints = ["Microsoft.KeyVault","Microsoft.Storage"]
}

resource "azurerm_subnet" "sbnet05" {
  name                 = "subnet-security"
  resource_group_name  = azurerm_resource_group.rg01.name
  virtual_network_name = azurerm_virtual_network.vnet01.name
  address_prefixes     = ["192.16.214.0/24"]
  enforce_private_link_endpoint_network_policies = true
  enforce_private_link_service_network_policies  = true
  service_endpoints = ["Microsoft.KeyVault","Microsoft.Storage"]
}

variable "subnet" {
    type = map 
    default = {
#         "default" = ["192.16.1.0/24"] 
#         "subnet-security" = ["192.16.214.0/24"]
#         "subnet-user" = ["192.16.224.0/24"]
#         "subnet-switch" = ["192.16.234.0/24"]
          "subnet-management" = ["192.16.244.0/24"]
          "subnet-visit" = ["192.16.204.0/24"]
#         "subnet-server" = ["192.16.254.0/24"]
    }
}
resource "azurerm_subnet" "subnet" {
  for_each = var.subnet

  name                 = each.key
  resource_group_name  = azurerm_resource_group.rg01.name
  virtual_network_name = azurerm_virtual_network.vnet01.name
  address_prefixes     = each.value
  enforce_private_link_endpoint_network_policies = true
  enforce_private_link_service_network_policies  = true
  service_endpoints = ["Microsoft.KeyVault","Microsoft.Storage"]
}

# Création d'une interface réseau logique à associer avec, par exemple, des VM 
resource "azurerm_network_interface" "net-int01" {
  name                = "${var.prefix}-nic"
  location            = azurerm_resource_group.rg01.location
  resource_group_name = azurerm_resource_group.rg01.name

  ip_configuration {
    name                          = "config-ip-int-01"
    subnet_id                     = azurerm_subnet.sbnet04.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.ip-pub01.id
  }
}

# Demande d'une adresse IP Publique à associer avec, par exemple, des interfaces logiques de VM    
resource "azurerm_public_ip" "ip-pub01" {
  name                = "nicolas-PublicIp1"
  resource_group_name = azurerm_resource_group.rg01.name
  location            = azurerm_resource_group.rg01.location
  allocation_method   = "Static"

  tags = {
    environment = "Production"
  }
}

