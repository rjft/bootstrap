module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name    = var.cluster_name
  cluster_version = var.kubernetes_version

  cluster_endpoint_public_access = var.public

  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.public_subnets

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = merge(var.node_group_defaults,
    {ami_release_version = data.aws_ssm_parameter.eks_ami_release_version.value})

  eks_managed_node_groups = var.managed_node_groups

  create_cloudwatch_log_group = var.create_cloudwatch_log_group

  # # Extend cluster security group rules
  cluster_security_group_additional_rules = {
    ingress_nodes_ephemeral_ports_tcp = {
      description                = "Nodes on ephemeral ports"
      protocol                   = "tcp"
      from_port                  = 1025
      to_port                    = 65535
      type                       = "ingress"
      source_node_security_group = true
    }
  }

  # # Extend node-to-node security group rules
  node_security_group_additional_rules = {
    ingress_self_all = {
      description = "Node to node all ports/protocols"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "ingress"
      self        = true
    }
  }
}

data "aws_eks_cluster_auth" "this" {
  name = module.eks.cluster_name

  depends_on = [ module.eks.eks_managed_node_groups ]
}

data "aws_ssm_parameter" "eks_ami_release_version" {
  name = "/aws/service/eks/optimized-ami/${module.eks.cluster_version}/amazon-linux-2/recommended/release_version"
}

resource "null_resource" "delete_aws_cni" {
  provisioner "local-exec" {
    command = "curl -s -k -XDELETE -H 'Authorization: Bearer ${data.aws_eks_cluster_auth.this.token}' -H 'Accept: application/json' -H 'Content-Type: application/json' '${module.eks.cluster_endpoint}/apis/apps/v1/namespaces/kube-system/daemonsets/aws-node'"
  }
  depends_on = [ module.eks.eks_managed_node_groups, data.aws_eks_cluster_auth.this ] # wait for node groups to be created and running before we delete the CNI and kube-proxy as without this they won't come up
}

resource "null_resource" "delete_kube_proxy" {
  provisioner "local-exec" {
    command = "curl -s -k -XDELETE -H 'Authorization: Bearer ${data.aws_eks_cluster_auth.this.token}' -H 'Accept: application/json' -H 'Content-Type: application/json' '${module.eks.cluster_endpoint}/apis/apps/v1/namespaces/kube-system/daemonsets/kube-proxy'"
  }
  depends_on = [ module.eks.eks_managed_node_groups, data.aws_eks_cluster_auth.this ] # wait for node groups to be created and running before we delete the CNI and kube-proxy as without this they won't come up
}
