variable "cluster_name" {
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
    default = true
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

variable "postgres_name" {
  type = string
  default = "plural"
}

variable "db_sku" {
  default = "GP_Gen5_2"
}

variable "install_runtime" {
  type = bool
  default = true
}

variable "runtime_values_file" {
  type = string
  default = "../../helm-values/runtime.yaml"
}