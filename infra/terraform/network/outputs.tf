output "resource_group_name" {
  description = "Имя ресурсной группы"
  value       = azurerm_resource_group.rg_network.name
}

output "location" {
  description = "Локация"
  value       = azurerm_resource_group.rg_network.location
}

output "subnet_nodes_id" {
    description = "Подсеть нод"
    value = azurerm_subnet.aks_nodes.id
}

output "subnet_pods_id"{
    description = "Подсеть под"
    value = azurerm_subnet.aks_pods.id
}

output "subnet_service_id"{
    description = "Подсеть под"
    value = azurerm_subnet.aks_service.id
}

output "subnet_vm_id"{
    description = "Подсеть под"
    value = azurerm_subnet.vm.id
}