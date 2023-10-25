terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.77.0"
    }
  }
}

provider "azurerm" {
    subscription_id = "7031074b-8de3-4a18-9242-379f4bac0778"
    tenant_id = "40111bb2-bdde-498a-9ecd-ee261089b87e"
    client_id = "f363f6cd-465d-46ca-91ec-9229560c8052"
    client_secret = "SE-8Q~e4ax53GiPPjF5zcck2h46zjN1_P_ERAdj6"
    features {}

}
resource "azurerm_resource_group" "appgrp" {
  name     = "app-grp"
  location = "North Europe"
}