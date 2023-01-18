output "endpoint" {
  value = aws_eks_cluster.eks-cluster.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.eks-cluster.certificate_authority[0].data
}

output "Resources-info"{
    value = aws_eks_node_group.eks-cluster-node-groups.resources
}

output "Instace-Types"{
    value = aws_eks_node_group.eks-cluster-node-groups.instance_types
}

