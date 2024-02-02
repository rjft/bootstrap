data "aws_eks_cluster" "cluster" {
  name = var.cluster_name
}

data "aws_eks_cluster_auth" "cluster" {
  name = var.cluster_name
}

resource "plural_cluster" "this" {
    handle   = var.cluster_handle
    name     = var.cluster_name
    tags     = var.tags
    protect  = var.protect
    # bindings = var.bindings
    kubeconfig = { 
      host                   = data.aws_eks_cluster.cluster.endpoint
      cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
      token                  = data.aws_eks_cluster_auth.cluster.token
    }
}