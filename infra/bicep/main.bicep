@description('Development location')
param location string = resourceGroup().location

@description('Environment name (dev/test/prod)')
param environment string = 'dev'

@description('Base name prefix for all resourcces')
param baseName string = 'cloudflow-order'

@description('SQL admin login')
param sqlAdminLogin string = 'sqladminuser'

@secure()
@description('SQL admin password')
param sqlAdminPassword string

var namePrefix = '${baseName}-${environment}'

//
// SQL Server + Database
//
module sql './sql.bicep' = {
    name: 'sqlModule'
    params: {
        location: location
        baseName: namePrefix
        sqlAdminLogin: sqlAdminLogin
        sqlAdminPassword: sqlAdminPassword
    }
}

//
// Applicaiton Insights
//
module appInsights './appinsights.bicep' = {
    name: 'appInsightsModule'
    params: {
        location: location
        baseName: namePrefix
    }
}


//
// Build SQL connection string to store in Key Vault
//
var sqlConnectionString = 'Server=tcp:${sql.outputs.sqlFqdn},1433;Initial Catalog=${sql.outputs.sqlDbName};Persist Security Info=False;User ID=${sqlAdminLogin};Password=${sqlAdminPassword};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;'


//
// Key Vault (stores SQL connection string as secret)
//
module keyVault './keyvault.bicep' = {
    name: 'keyVaultModule'
    params: {
        location: location
        keyVaultName: toLower('${namePrefix}-kv')
        sqlConnectionSecretName: 'SqlConnectionString'
        sqlConnectionString: sqlConnectionString
    }
}

//
// App Service Plan + Web App
//
module appService './appservice.bicep' = {
    name: 'appServiceModule'
    params: {
        location: location
        baseName: namePrefix
        appInsightsConnectionString: appInsights.outputs.connectionString
        sqlConnectionSecretUri: keyVault.outputs.sqlConnectionSecretUri
        skuName: 'S1'
        skuTier: 'Standard'
    }
}

output webAppUrl string = 'https://${appService.outputs.webAppName}.azurewebsites.net'
output webAppName string = appService.outputs.webAppName
output keyVaultName string = keyVault.outputs.keyValultName
output sqlServerName string = sql.outputs.sqlServerName
output sqlDatabaseName string = sql.outputs.sqlDbName
