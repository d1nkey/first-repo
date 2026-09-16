resource "azurerm_resource_group" "rg_aks" {
  name     = "${var.prefix}-rg-aks"
  location = var.location
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "${var.prefix}-aks"
  location            = azurerm_resource_group.rg_aks.location
  resource_group_name = azurerm_resource_group.rg_aks.name
  dns_prefix          = "${var.prefix}-k8s"

  # 1. Приватный кластер (API доступен только внутри VNet)
  private_cluster_enabled = true

  default_node_pool {
    name           = "default"
    node_count     = 2
    vm_size        = "Standard_B2s"
    vnet_subnet_id = var.subnet_aks_nodes_id # Привязка к subnet-aks-nodes
    pod_subnet_id  = var.subnet_aks_pods_id  # Привязка к subnet-aks-pods
  }

  identity {
    type = "SystemAssigned"
  }

  # 2. Сетевой профиль Azure CNI
  network_profile {
    network_plugin = "azure"
    service_cidr   = "172.16.0.0/16"
    dns_service_ip = "172.16.0.10"
  }
}

# 3. Выдача прав AKS для автоматического скачивания образов из ACR (AcrPull)
resource "azurerm_role_assignment" "aks_acr_pull" {
  principal_id         = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  role_definition_name = "AcrPull"
  scope                = var.acr_id
}