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
    default = "1.27"
}

variable "public" {
    type = bool
    default = true
}

variable "vpc_name" {
    type = string
    default = "plural"
}

variable "vpc_cidr" {
    type = string
    default = "10.0.0.0/16"
}

variable "private_subnets" {
    type = string
    default = ["10.0.1.0/20", "10.0.2.0/20", "10.0.3.0/20"]
}

variable "public_subnets" {
    type = string
    default = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}

variable "install_runtime" {
  type = bool
  default = true
}

variable "deletion_protection" {
  type = bool
  default = true
}

variable "runtime_values_file" {
  type = string
  default = "../../helm-values/runtime.yaml"
}

variable "db_instance_class" {
    default = "db.t4g.large"
}