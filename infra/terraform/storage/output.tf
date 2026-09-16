output "acr_id" {
  description = "ID приватного Azure Container Registry для настройки прав доступа AKS"
  value       = azurerm_container_registry.acr.id
}

output "acr_login_server" {
  description = "URL реестра контейнеров (например, myappregistry.azurecr.io) для docker push"
  value       = azurerm_container_registry.acr.login_server
}