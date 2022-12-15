resource "azurerm_storage_account" "kube_config_sa" {
  name                     = "kubeconfigashe"
  resource_group_name      = azurerm_resource_group.aks-rg.name
  location                 = azurerm_resource_group.aks-rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

    depends_on = [null_resource.set-kube-config]

}

resource "azurerm_storage_container" "kube_config_sc" {
  name                  = "kubeconfigcontainerashe"
  storage_account_name  = azurerm_storage_account.kube_config_sa.name
  container_access_type = "private"
}

resource "azurerm_storage_blob" "kube_config_sb" {
  name                   = "kubeconfig"
  storage_account_name   = azurerm_storage_account.kube_config_sa.name
  storage_container_name = azurerm_storage_container.kube_config_sc.name
  type                   = "Block"
  source                 = ".kube/config"
}