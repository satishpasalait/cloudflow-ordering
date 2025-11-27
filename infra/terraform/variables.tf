variable "location" {
    description = "Azure region to deploy to"
    type = string
    default = "eastus"
}

variable "environment" {
    description = "Environment name (def, qa, prod, etc)"
    type = string
    default = "dev"
}

variable "resource_group_name" {
    description = "Name of the resource group to create"
    type = string
}

variable "app_base_name" {
    description = "Base name for the App Service"
    type = string
    default = "cloudflow-ordering-api"
}

variable "app_service_sku_name" {
    description = "App Service Plan SKU (e.g., B1, S1, P1v2)"
    type = string
    default = "B1"
}

variable "sql_server_name" {
    description = "Azure SQL server name (must be globally unique)"
    type = string
}

variable "sql_admin_login" {
    description = "SQL admin login"
    type = string
}

variable "sql_admin_password" {
    description = "SQL admin password"
    type = string
    sensitive = true
}

variable "sql_database_name" {
    description = "Database name"
    type = string
    default = "CloudFlowOrderingDb"
}

variable "key_vault_name" {
    description = "Key Vault name (must be globally unique)"
    type = string
}

variable "app_insights_name" {
    description = "Application Insights name"
    type = string
}

variable "deployer_object_id" {
    description = "Object ID of the deployer (for Key Vault access)"
    type = string
}

variable "subscription_id" {
    description = "Azure Subscription ID"
    type = string
}