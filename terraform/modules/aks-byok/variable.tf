variable "cluster_name" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "cluster_handle" {
  type = string
}

variable "tags" {
  type = map(string)
  default = {}
}

variable "protect" {
  type = bool
  default = false
}

variable "bindings" {
  type = list(any)
  default = []
}