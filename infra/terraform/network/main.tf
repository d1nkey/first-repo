resource "azurerm_resource_group" "rg_network" {
  name     = var.prefix
  location = var.location
}
resource "azurerm_virtual_network" "network" {
  name                = "${var.prefix}-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg_network.location
  resource_group_name = azurerm_resource_group.rg_network.name
}

resource "azurerm_subnet" "aks_nodes" {
  name                 = "${var.prefix}-subnet-aks"
  resource_group_name  = azurerm_resource_group.rg_network.name
  address_prefixes     = ["10.0.1.0/24"]
  virtual_network_name = azurerm_virtual_network.network.name
}

resource "azurerm_subnet" "aks_pods" {
  name                 = "${var.prefix}-subnet-k8s"
  resource_group_name  = azurerm_resource_group.rg_network.name
  address_prefixes     = ["10.0.2.0/24"]
  virtual_network_name = azurerm_virtual_network.network.name

  delegation {
    name = "aks-delegation"
    service_delegation {
      name    = "Microsoft.ContainerService/managedClusters"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
    }
  }

}

resource "azurerm_subnet" "aks_service" {
  name                 = "${var.prefix}-subnet-aks"
  resource_group_name  = azurerm_resource_group.rg_network.name
  address_prefixes     = ["10.0.3.0/24"]
  virtual_network_name = azurerm_virtual_network.network.name # <--- Указать имя ресурса VNet
  lifecycle {
    ignore_changes = [address_prefixes]
  }
}

resource "azurerm_subnet" "vm" {
  name                 = "${var.prefix}-subnet-vm"
  resource_group_name  = azurerm_resource_group.rg_network.name
  address_prefixes     = ["10.0.4.0/24"]
  virtual_network_name = azurerm_virtual_network.network.name
}


resource "azurerm_nat_gateway" "gateway" {
  name                    = "${var.prefix}-gateway"
  location                = azurerm_resource_group.rg_network.location
  resource_group_name     = azurerm_resource_group.rg_network.name
  sku_name                = "Standard"
  idle_timeout_in_minutes = 10
  zones                   = ["1"]
}


