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

resource "azurerm_resource_group" "group" {
  name     = "terraformtest"
  location = "South Central US"
}

resource "azurerm_container_group" "ods" {
  name                = "ods-container-group"
  location            = azurerm_resource_group.group.location
  resource_group_name = azurerm_resource_group.group.name
  ip_address_type     = "public"
  dns_name_label      = "aci-label"
  os_type             = "Linux"

  container {
    name   = "ed-fi-db-ods"
    image  = "edfialliance/ods-api-db-ods:latest"
    cpu    = "0.5"
    memory = "1.5"

    ports {
      port     = 5432
      protocol = "TCP"
    }

    environment_variables = {
        POSTGRES_USER = "postgres"
        POSTGRES_PASSWORD = "root@123"
    }
  }

  container {
    name   = "ed-fi-ods"
    image  = "edfialliance/ods-api-web-api:latest"
    cpu    = "0.5"
    memory = "1.5"

    ports {
      port     = 80
      protocol = "TCP"
    }

    environment_variables = {
        POSTGRES_USER = "postgres"
        POSTGRES_PASSWORD = "root@123"
        POSTGRES_PORT = "4000"
        ODS_POSTGRES_HOST = "aci-label"
        ADMIN_POSTGRES_HOST = "aci-label"
        API_MODE = "SharedInstance"
    }
  }

  container {
    name   = "ed-fi-gateway"
    image  = "edfialliance/ods-api-web-gateway:latest"
    cpu    = "0.5"
    memory = "1.5"

    ports {
      port     = 443
      protocol = "TCP"
    }

    environment_variables = {
        ADMINAPP_VIRTUAL_NAME = "admin"
        ODS_VIRTUAL_NAME = "api"
    }
  }

  container {
    name   = "ed-fi-pb-ods"
    image  = "pgbouncer/pgbouncer:latest"
    cpu    = "0.5"
    memory = "1.5"

    ports {
      port     = 4000
      protocol = "TCP"
    }

    environment_variables = {
      DATABASES = "* = host = db-ods port=5432 user=postgres password=root@123"
      PGBOUNCER_LISTEN_PORT = "4000"
    }
  }
}


