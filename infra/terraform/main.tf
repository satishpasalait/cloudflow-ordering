terraform {
    required_version = ">= 1.5.0"

    required_providers {
        azurerm = {
            source = "hashicorp/azurerm"
            version = ">= 3.0"
        }
    }
}

provider "azurerm" {
    features {}
    subscription_id = "${var.subscription_id}"

    # since providers are already registered, tell TF not to try
    resource_provider_registrations = "none"
}

#Current tenant info
data "azurerm_client_config" "current" {}

#-------------------------------------------
# Resource Group
#-------------------------------------------
resource "azurerm_resource_group" "rg" {
    name        = var.resource_group_name
    location    = var.location
}

#-------------------------------------------
# Locals (naming + SQL connection string)
#-------------------------------------------
locals {
    app_service_name            = "${var.app_base_name}-${var.environment}-asp"
    app_service_plan_name       = "${var.app_base_name}-${var.environment}-plan"

    # Build SQL connection string
    sql_connection_string       = "Server=tcp:${var.sql_server_name}.database.windows.net,1433;Initial Catalog=${var.sql_database_name};Persist Security Info=False;User ID=${var.sql_admin_login};Password=${var.sql_admin_password};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"

    apsnetcore_environment      = "${var.environment == "prod" ? "Production" : "Development"}"
}

#-------------------------------------------
# App Service Plan (Windows)
#-------------------------------------------
resource "azurerm_app_service_plan" "plan" {
    name                    = local.app_service_plan_name
    location                = azurerm_resource_group.rg.location
    resource_group_name     = azurerm_resource_group.rg.name
    kind                    = "Windows"

    sku {
        tier = var.app_service_sku_name == "B1" ? "Basic" : "Standard"
        size = var.app_service_sku_name
    }
}

#-------------------------------------------
# Application Insights
#-------------------------------------------
resource "azurerm_application_insights" "appinsights" {
    name                    = var.app_insights_name
    location                = azurerm_resource_group.rg.location
    resource_group_name     = azurerm_resource_group.rg.name
    application_type        = "web"
}

#-------------------------------------------
# SQL Server + Firewall + Database
#-------------------------------------------
resource "azurerm_mssql_server" "sql" {
    name                            = var.sql_server_name
    resource_group_name             = azurerm_resource_group.rg.name
    location                        = azurerm_resource_group.rg.location
    version                         = "12.0"
    administrator_login             = var.sql_admin_login
    administrator_login_password    = var.sql_admin_password
}

# Allow Azure services (0.0.0.0)
resource "azurerm_mssql_firewall_rule" "allow_azure" {
    name = "AllowAzureServices"
    server_id = azurerm_mssql_server.sql.id
    start_ip_address = "0.0.0.0"
    end_ip_address = "0.0.0.0"
}

resource "azurerm_mssql_database" "db" {
    name = var.sql_database_name
    server_id = azurerm_mssql_server.sql.id
    sku_name = "GP_Gen5_2"
    collation = "SQL_Latin1_General_CP1_CI_AS"
}

#-------------------------------------------
# Key Vault (RBAC mode)
#-------------------------------------------
resource "azurerm_key_vault" "kv" {
    name = var.key_vault_name
    location = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    tenant_id = data.azurerm_client_config.current.tenant_id
    sku_name = "standard"
    soft_delete_retention_days = 7
    purge_protection_enabled = false

    #RBAC instead of access policies
    #enable_rbac_authorization = true
    public_network_access_enabled = true
}

# Store connection string as Key Vault secret "ConnectionStrings--OrderingDb"
resource "azurerm_key_vault_secret" "sql_conn" {
    name = "ConnectionStrings--OrderingDb"
    value = local.sql_connection_string
    key_vault_id = azurerm_key_vault.kv.id
}


#-------------------------------------------
# App Service (Windows Web App) with Managed Identity
#-------------------------------------------
resource "azurerm_windows_web_app" "app" {
    name = local.app_service_name
    location = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    service_plan_id = azurerm_app_service_plan.plan.id

    identity {
      type = "SystemAssigned"
    }

    site_config {
        always_on = true

    }

    app_settings = {
        "ApplicationInsights__ConnectionString" = azurerm_application_insights.appinsights.connection_string
        "KeyVault__Url" = azurerm_key_vault.kv.vault_uri
        #"ASPNETCORE_ENVIRONMENT" = local.aspnetcore_environment
    }

    https_only = true

    depends_on = [
        azurerm_application_insights.appinsights,
        azurerm_key_vault.kv,
        azurerm_mssql_database.db
    ]
}


#-------------------------------------------
# Key Vault RBAC: allow Web App to read secrets
# Role: Key Vault Secrets User
#-------------------------------------------
resource "azurerm_role_assignment" "kv_secrets_user" {
    scope = azurerm_key_vault.kv.id
    role_definition_name = "Key Vault Secrets User"
    principal_id = azurerm_windows_web_app.app.identity[0].principal_id
}

#-------------------------------------------
# Key Vault RBAC: allow deployer to manage secrets
# Role: Key Vault Secrets Officer
#-------------------------------------------
resource "azurerm_role_assignment" "kv_deployer_secrets_officer" {
    scope = azurerm_key_vault.kv.id
    role_definition_name = "Key Vault Secrets Officer"
    principal_id = var.deployer_object_id
}