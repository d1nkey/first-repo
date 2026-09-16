variable "prefix" {
    type = string
    description = "Название ресурсной группы виртуальной машины"
}
variable "location" {
    type = string
    description = "Локация ресурсной группы виртуальной машины"
}

variable "subnet" {
    type = string
    description = "Подсеть к которой надо подключить карту"
}
variable "vms" {
  description = "Map of VMs to create"
  type        = map(any)
  default = {
    "pg-primary" = {}
    "pg-standby" = {}
  }
}