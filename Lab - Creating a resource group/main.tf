terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.77.0"
    }
  }
}

provider "azurerm" {
    subscription_id = "7031074b"
    tenant_id = "40111bb2-bdde-"
    client_id = "f363f6cd-46"
    client_secret = "SE-8Q~e4ax53"
    features {}

}
resource "azurerm_resource_group" "appgrp" {
  name     = "app-grp"
  location = "North Europe"
}
