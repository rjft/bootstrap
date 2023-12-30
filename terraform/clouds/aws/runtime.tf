module "eks_blueprints_addons" {
  source = "aws-ia/eks-blueprints-addons/aws"
  version = "~> 1.12" #ensure to update this to the latest/desired version

  cluster_name      = module.eks.cluster_name
  cluster_endpoint  = module.eks.cluster_endpoint
  cluster_version   = module.eks.cluster_version
  oidc_provider_arn = module.eks.oidc_provider_arn

  eks_addons = {
    aws-ebs-csi-driver = {
      most_recent = true
    }
    coredns = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
  }

  # mostly need this module to install the lb controller here.
  enable_aws_load_balancer_controller    = true
  enable_cluster_proportional_autoscaler = true
  enable_metrics_server                  = true
}

resource "helm_release" "runtime" {
  name             = "runtime"
  namespace        = "plural-runtime"
  chart            = "runtime"
  repository       = "https://pluralsh.github.io/bootstrap"
  version          = var.runtime_vsn
  create_namespace = true
  timeout          = 300
  values           = [
    file(var.runtime_values_file)
  ]
}