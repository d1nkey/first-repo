include "root" {
    path = find_in_parent_folders()
}

terraform {
    source = " /../../../terraform/vm"
}

dependency "network" {
  config_path = "../network"

  mock_outputs = {
    resource_group_name = "mock-rg"
    location            = "westeurope"
    subnet_vm_id        = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/mock-rg/providers/Microsoft.Network/virtualNetworks/mock-vnet/subnets/mock-subnet-vm"
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
}

dependency "storage" {
      config_path = "../storage"
  
      mock_outputs = {
          storage_output = "mock-storage-output"
      }
  }

inputs = {
  resource_group_name = dependency.network.outputs.resource_group_name
  location            = dependency.network.outputs.location
  subnet              = dependency.network.outputs.subnet_vm_id
  vms = {
    "pg-primary" = {}
    "pg-standby" = {}
  }
}