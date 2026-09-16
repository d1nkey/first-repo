include "root" {
    path = find_in_parent_folders()
}

terraform {
    source = " /../../../terraform/storage"
}

dependency "network" {
  config_path = "../network"

  # Моки нужны для прохождения validate/plan до развертывания сети
  mock_outputs = {
    resource_group_name = "mock-rg"
    location            = "westeurope"
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
}


inputs = {
   resource_group_name = dependency.network.outputs.resource_group_name
   location = dependency.network.outputs.location
}