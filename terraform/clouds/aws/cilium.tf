resource "helm_release" "cilium" {
  name             = "cilium"
  namespace        = "kube-system"
  chart            = "cilium"
  repository       = "https://helm.cilium.io/"
  version          = "1.14.5"
  create_namespace = false
  timeout          = 300
  wait             = true
  values           = [
    data.local_sensitive_file.cilium.content
  ]

  set {
    name  = "k8sServiceHost"
    value = replace(module.eks.cluster_endpoint, "https://", "")
  }

  set {
    name  = "k8sServicePort"
    value = "443"
  }

  depends_on = [ null_resource.delete_aws_cni, null_resource.delete_kube_proxy, module.eks.cluster ]
}

data "local_sensitive_file" "cilium" {
  filename = "${path.module}/cilium.yaml"
}
