# Configure the Microsoft Azure Provider

# Azure Provider source and version being used
terraform {
  backend "azurerm" {
    resource_group_name  = "terraform-tfstates2"
    storage_account_name = "statestfashe2"
    container_name       = "tfstatedevops"
    key                  = "prod.terraform.tfstate"
  } 

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

provider "azurerm" {
  features {}
}

