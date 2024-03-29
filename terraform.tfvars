resource_group_name = "test_aks_terraform"
location            = "East US 2"
cluster_name        = "aks-cluster-test"
kubernetes_version  = "1.23.12"
system_node_count   = 2
acr_name            = "myacrtest"
vnet_name           = "aks-vnet"
subnet-name         = "aks-subnet"
vnet-ip             = ["192.168.0.0/16"]
subnet-ip           = ["192.168.0.0/24"]