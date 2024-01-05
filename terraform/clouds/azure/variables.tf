variable "cluster_name" {
    type = string
    default = "plural"
}

variable "db_name" {
  type = string
  default = "plural"
}

variable "create_db" {
  type = bool
  default = true
}

variable "kubernetes_version" {
  type = string
  default = "1.27.3"
}

variable "create_resource_group" {
    type = bool
    default = false
}

variable "resource_group_name" {
  type = string
  default = "plural"
}

variable "location" {
  type = string
  default = "centralus"
}

variable "network_name" {
  type = string
  default = "plural"
}

variable "network_cidrs" {
  type = list(string)
  default = ["10.52.0.0/16"]
}

variable "subnet_cidrs" {
  type = list(string)
  default = ["10.52.0.0/20"]
}

variable "postgres_cidrs" {
  type = list(string)
  default = ["10.0.2.0/24"]
}

variable "postgres_disk" {
  type = number
  default = 32768
}

variable "postgres_sku" {
  type = string
  default = "GP_Standard_D4s_v3"
}

variable "db_sku" {
  default = "GP_Gen5_2"
}

variable "node_pools" {
  type = map(any)
  default = {
    plural = {
      vm_size = "Standard_D2s_v3"
      node_count = 3
      min_count = 1
      max_count = 20
      enable_auto_scaling = true
    }
  }
}