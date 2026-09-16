include "root" {
    path = find_in_parent_folders()
}

terraform {
    source = " /../../../terraform/aks"
}
dependency "network" {
  config_path = "../network"

  mock_outputs = {
    resource_group_name = "mock-rg"
    location            = "westeurope"
    subnet_nodes_id     = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/mock-rg/providers/Microsoft.Network/virtualNetworks/mock-vnet/subnets/mock-subnet-nodes"
    subnet_pods_id      = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/mock-rg/providers/Microsoft.Network/virtualNetworks/mock-vnet/subnets/mock-subnet-pods"
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
}

dependency "storage" {
  config_path = "../storage"

  mock_outputs = {
    acr_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/mock-rg/providers/Microsoft.ContainerRegistry/registries/mockacr"
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
}


inputs = {
  resource_group_name = dependency.network.outputs.resource_group_name
  location            = dependency.network.outputs.location
  subnet_aks_nodes_id = dependency.network.outputs.subnet_nodes_id
  subnet_aks_pods_id  = dependency.network.outputs.subnet_pods_id
  acr_id              = dependency.storage.outputs.acr_id
}