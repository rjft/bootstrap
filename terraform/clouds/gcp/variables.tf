variable "cluster_name" {
  type = string
  default = "plural"
}

variable "create_db" {
  type = bool
  default = true
}

variable "deletion_protection" {
  type = bool
  default = true
}

variable "kubernetes_version" {
  type = string
  default = "1.27.3-gke.100"
}

variable "node_pools" {
  type = list(any)
  default = [ {name = "default-node-pool"} ]
}

variable "node_pools_taints" {
  type = map(list(object({ key = string, value = string, effect = string })))
  default = { "all": [], "default-node-pool": [] }
}

variable "node_pools_labels" {
  type = map(map(string))
  default = { "all": {}, "default-node-pool": {} }
}

variable "node_pools_tags" {
  type = map(list(string))
  default = { "all": [], "default-node-pool": [] }
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

variable "subnet_cidr" {
  default = "10.0.0.0/17"
}

variable "pods_cidr" {
  default = "192.168.0.0/18"
}

variable "allocated_range" {
  default = "google-managed-services-default"
}

variable "db_size" {
  default = "db-custom-4-8192"
}

variable "services_cidr" {
  default = "192.168.64.0/18"
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
