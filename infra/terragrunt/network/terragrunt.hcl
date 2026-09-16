include "root" {
    path = find_in_parent_folders()
}

terraform {
    source = " /../../../terraform/network"
}

inputs = {
    prefix = "dev"
    location = "westeurope"
}