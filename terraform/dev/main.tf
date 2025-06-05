terraform {
  required_providers {
    databricks = {
      source  = "databricks/databricks"
      version = ">= 1.13.0"
    }
  }
  required_version = ">= 1.1.0"

  backend "azurerm" {
    resource_group_name  = "tfstate-rg-dev"
    storage_account_name = "tfstatestorageacctdev"
    container_name       = "tfstate"
    key                  = "terraform/dev/databricks.tfstate"
  }
}

provider "databricks" {
  host  = var.databricks_host
  token = var.databricks_token
}
