variable "region" {
  type = string
  description = "Location in AWS"
}

variable "eks_name" {
    type = string
    description = "Name of EKS Cluster"
}

variable "node_group_name" {
  type = string
  description = "Name of Node Group"
}

variable "iam_role_name" {
    type = string
    description = "Name of IAM Role"
    default = "devops-eks-iam-role"
}

variable "nodeGroup_Role_Name" {
  type = string
  description = "Name of node group iam role"
  default = "eks-node-group-example"
}