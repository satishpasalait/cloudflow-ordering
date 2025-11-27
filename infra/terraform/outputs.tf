output "app_service_url" {
    description = "URL of the deployed App Service"
    value = "https://${azurerm_windows_web_app.app.default_hostname}"
}

output "key_vault_uri" {
    description = "Key Vault URI"
    value = azurerm_key_vault.kv.vault_uri
}

output "sql_server_fqdn" {
    description = "SQL Server fully qualified domain name"
    value = azurerm_mssql_server.sql.fully_qualified_domain_name
}