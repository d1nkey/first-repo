resource "azurerm_resource_group" "rg_storage" {
  name     = "${var.prefix}-rg-storage" # Было: var.prefix или "dev"
  location = var.location
}

resource "azurerm_container_registry" "acr" {
  name                = "${var.prefix}acr2026project"
  resource_group_name = azurerm_resource_group.rg_storage.name
  location            = azurerm_resource_group.rg_storage.location
  sku                 = "Standard"
  admin_enabled       = false
}