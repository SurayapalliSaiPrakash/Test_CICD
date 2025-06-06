terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.72.0"
    }
    databricks = {
      source  = "databricks/databricks"
      version = "1.27.0"
    }
    azuread = {
      source = "hashicorp/azuread"
      version = "2.43.0"
    }
    time = {
      source = "hashicorp/time"
      version = "0.9.1"
    }
  }
}

provider "azurerm" {
  features {}
  skip_provider_registration = true
}

provider "azuread" {
  # Configuration options
}

provider "time" {
  # Configuration options
}

provider "databricks" {
  host = https://adb-1716834444966310.10.azuredatabricks.net
  azure_workspace_resource_id = /subscriptions/1070209d-7223-4e99-9cff-f57bc4baeca6/resourceGroups/dbricks-dev-wus-rg
}
