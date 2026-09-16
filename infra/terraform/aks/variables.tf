variable "prefix" {
    type = string
    description = "Название кластера AKS/"
}
variable "location" {
    type = string
    description = "Название локации кластера AKS/"
}

variable "subnet_aks_nodes_id" {
  type        = string
  description = "ID подсети для нод AKS"
}

variable "subnet_aks_pods_id" {
  type        = string
  description = "ID подсети для подов AKS"
}

variable "acr_id" {
  type        = string
  description = "ID подсети для подов AKS"
}