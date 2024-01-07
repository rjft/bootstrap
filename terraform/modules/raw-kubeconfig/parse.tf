locals {
  kubeconfig = yamldecode(var.kubeconfig)
}

output "cluster" {
  value = local.kubeconfig.clusters[0]
}

output "user" {
  value = local.kubeconfig.users[0].user
}