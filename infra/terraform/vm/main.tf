locals {
   vm_names = toset (["pg-primary", "pg-standby"])
}

resource "azurerm_resource_group" "rg_virtual_machine" {
  name     = "${var.prefix}-rg-vm"
  location = var.location
}
resource "azurerm_network_interface" "nic" {
  for_each            = var.vms
  name                = "${var.prefix}-nic-${each.key}" # Динамическое имя для каждого интерфейса
  location            = var.location
  resource_group_name = azurerm_resource_group.rg_virtual_machine.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet
    private_ip_address_allocation = "Dynamic"
  }
}
resource "azurerm_network_security_group" "nsg" {
  for_each = local.vm_names
  name                = "${var.prefix}-nsg"
  location            = azurerm_resource_group.rg_virtual_machine.location
  resource_group_name = azurerm_resource_group.rg_virtual_machine.name

  security_rule {
    name                       = "test123"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "Production"
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
  for_each            = var.vms
  name                = "${var.prefix}-${each.key}"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg_virtual_machine.name
  size                = "Standard_D4_v5"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.nic[each.key].id # Привязка соответствующей NIC по ключу
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}
