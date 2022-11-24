variable "resource_group_name" {
  type        = string
  description = "RG name in Azure"
}
variable "location" {
  type        = string
  description = "Resources location in Azure"
}
variable "cluster_name" {
  type        = string
  description = "AKS name in Azure"
}
variable "kubernetes_version" {
  type        = string
  description = "Kubernetes version"
}
variable "system_node_count" {
  type        = number
  description = "Number of AKS worker nodes"
}
variable "acr_name" {
  type        = string
  description = "ACR name"
}

variable "vnet_name" {
  type        = string
  description = "Vnet name"
}

variable "subnet-name" {
  type        = string
  description = "Subnet name"
}

variable "vnet-ip" {
  type = list(string)
  description = "List of vnet ip"
  default = ["192.168.0.0/16"]
}

variable "subnet-ip" {
  type = list(string)
  description = "List of vnet ip"
  default = ["192.168.0.0/24"]
}