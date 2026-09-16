output "pg_primary_ip" {
  value = azurerm_network_interface.nic["pg-primary"].private_ip_address
}

output "pg_standby_ip" {
  value = azurerm_network_interface.nic["pg-standby"].private_ip_address
}