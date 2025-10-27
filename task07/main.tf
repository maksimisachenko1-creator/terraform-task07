# Import the pre-existing Resource Group
import {
  to = azurerm_resource_group.rg
  id = "/subscriptions/8c748599-f410-42d3-8fe8-3a7060d1c7ea/resourceGroups/cmtr-ya42kk4d-mod7-rg"
}

# Define the resource block for the imported Resource Group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

# Import the pre-existing Storage Account
import {
  to = azurerm_storage_account.sa
  id = "/subscriptions/8c748599-f410-42d3-8fe8-3a7060d1c7ea/resourceGroups/cmtr-ya42kk4d-mod7-rg/providers/Microsoft.Storage/storageAccounts/cmtrya42kk4dmod7sa"
}

# Define the resource block for the imported Storage Account
# This configuration must be present for Terraform to manage the resource.
# The lifecycle block prevents any accidental modifications or deletion.
resource "azurerm_storage_account" "sa" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  lifecycle {
    prevent_destroy = true
    ignore_changes  = all
  }
}

# Data source to get details from the storage account, like the primary blob host
data "azurerm_storage_account" "sa_data" {
  name                = azurerm_storage_account.sa.name
  resource_group_name = azurerm_resource_group.rg.name
  depends_on          = [azurerm_storage_account.sa]
}

# Instantiate the CDN module
module "cdn" {
  source = "./modules/cdn"

  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  profile_name        = var.fd_profile_name
  profile_sku         = var.fd_profile_sku
  endpoint_name       = var.fd_endpoint_name
  origin_group_name   = var.fd_origin_group_name
  origin_name         = var.fd_origin_name
  route_name          = var.fd_route_name
  origin_hostname     = data.azurerm_storage_account.sa_data.primary_blob_host
}