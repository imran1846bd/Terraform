terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.77.0"
    }
  }
}

provider "azurerm" {
    subscription_id = "7031074b-8de3-4a1"
    tenant_id = "40111bb2-bdde-498"
    client_id = "f363f6cd-"
    client_secret = "SE-8Q~e4ax53Gi"
    features {}

}
resource "azurerm_resource_group" "appgrp" {
  name     = "app-grp"
  location = "North Europe"
}

resource "azurerm_storage_account" "appazure1846cicada" {
  name                     = "appazure1846cicada"
  resource_group_name      = "app-grp"
  location                 = "North Europe"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind = "StorageV2"


}
