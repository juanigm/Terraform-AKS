data "aws_caller_identity" "current" {}

resource "aws_eks_cluster" "eks-cluster" {
  name     = "eks-${random_string.random.result}"
  role_arn = aws_iam_role.eks-iam-role.arn
  version = 1.24

  vpc_config {
    subnet_ids = module.vpc.public_subnets
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly-EKS,
  ]

}


resource "aws_eks_node_group" "eks-cluster-node-groups" {
  cluster_name    = aws_eks_cluster.eks-cluster.name
  node_group_name = var.node_group_name
  node_role_arn   = aws_iam_role.eks-node-group-iam-role.arn
  subnet_ids      = module.vpc.public_subnets
  
  

  instance_types = [ "t3.medium" ]

  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
    aws_iam_role_policy_attachment.AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
  ]

}






