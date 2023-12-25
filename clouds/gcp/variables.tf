variable "cluster_name" {
  type = string
  default = "plural"
}

variable "project_id" {
  type = string
}

variable "region" {
  description = "The region to host the cluster in"
  default     = "us-central1"
}

variable "network" {
  description = "The VPC network created to host the cluster in"
  default     = "plural-network"
}

variable "subnetwork" {
  description = "The subnetwork created to host the cluster in"
  default     = "plural-subnet"
}

variable "ip_range_pods_name" {
  description = "The secondary ip range to use for pods"
  default     = "ip-range-pods"
}

variable "ip_range_services_name" {
  description = "The secondary ip range to use for services"
  default     = "ip-range-svc"
}

variable "db_name" {
  type = string
  default = "plural"
}

variable "install_runtime" {
  type = bool
  default = true
}