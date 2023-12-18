terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.77.0"
    }
  }
}

provider "azurerm" {
    subscription_id = "7031074b-8de3"
    tenant_id = "40111bb2-bdde"
    client_id = "f363f6cd-465d-"
    client_secret = "SE-8Q~e4ax53GiP"
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
resource "azurerm_storage_container" "data" {
  name                  = "data"
  storage_account_name  = "appazure1846cicada"
  container_access_type = "blob"
}
resource "azurerm_storage_blob" "doc" {
  name                   = "numorical doc"
  storage_account_name   = "appazure1846cicada"
  storage_container_name = "data"
  type                   = "Block"
  source                 = "NUMERICAL-INTEGRARION.docx"
}
