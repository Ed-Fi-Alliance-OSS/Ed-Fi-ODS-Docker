terraform {
  required_providers {
    azurerm = {
        source  = "hashicorp/azurerm"
        version = "=2.46.0"
    }
  }
}


provider "azurerm" {
  features {}
}

# Create a new Resource Group
resource "azurerm_resource_group" "group" {
  name     = "terraformtest"
  location = "South Central US"
}

resource "azurerm_storage_account" "storage" {
  name                     = "edfivolumestorage"
  resource_group_name      = azurerm_resource_group.group.name
  location                 = azurerm_resource_group.group.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}


# Create an App Service Plan with Linux
resource "azurerm_app_service_plan" "odsapiappserviceplan" {
  name                = "odsapiappservice"
  location            = azurerm_resource_group.group.location
  resource_group_name = azurerm_resource_group.group.name

  # Define Linux as Host OS
  kind = "Linux"

  # Choose size
  sku {
    tier = "Standard"
    size = "S1"
  }

  #properties = {
    reserved = true # Mandatory for Linux plans
  #}
}

resource "azurerm_app_service" "test" {
  name                = azurerm_app_service_plan.odsapiappserviceplan.name
  location            = azurerm_resource_group.group.location
  resource_group_name = azurerm_resource_group.group.name
  app_service_plan_id = azurerm_app_service_plan.odsapiappserviceplan.id

  site_config {
    linux_fx_version = "COMPOSE|${filebase64("compose-shared-instance-env-build.yml")}"
    always_on        = "true"
  }

  app_settings = {
    WEBSITES_ENABLE_APP_SERVICE_STORAGE = true
    POSTGRES_USER = "postgres"
    POSTGRES_PASSWORD = "root@123"
    POSTGRES_PORT = "4000"
    ODS_POSTGRES_HOST = "pb-ods"
    ADMIN_POSTGRES_HOST = "pb-admin"
    API_MODE = "SharedInstance"
    ADMINAPP_VIRTUAL_NAME = "admin"
    ODS_VIRTUAL_NAME = "api"
    DATABASES = "* = host = db-ods port=5432 user=postgres password=root@123"
    PGBOUNCER_LISTEN_PORT = "4000"
  }

  storage_account {
      name = azurerm_storage_account.storage.name
      type = "AzureBlob"
      account_name = azurerm_storage_account.storage.name
      access_key = azurerm_storage_account.storage.primary_access_key
      share_name = azurerm_storage_account.storage.primary_blob_host
  }

  identity {
    type = "SystemAssigned"
  }

  lifecycle {
    ignore_changes = [
      site_config.0.linux_fx_version,
    ]
  }
}

output "primary_blob_host" {
  value       = azurerm_storage_account.storage.primary_blob_host
  description = "Primary Blob Host."
}

output "primary_blob_endpoint" {
  value       = azurerm_storage_account.storage.primary_blob_endpoint
  description = "Primary Blob Endpoint."
}
