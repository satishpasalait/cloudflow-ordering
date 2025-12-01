param location string
param baseName string

param appInsightsConnectionString string
param sqlConnectionSecretUri string

@description('App Service plan SKU name (e.g., F1, B1, S1, P1v3)')
param skuName string = 'S1'

@description('App Service plan SKU tier (e.g., Free, Basic, Standard, PremiumV2)')
param skuTier string = 'Standard'

var appServicePlanName = '${baseName}-asp'
var webAppName = '${baseName}-web'

resource appServicePlan 'Microsoft.Web/serverfarms@2023-12-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: skuName
    tier: skuTier
    size: skuName
    capacity: 1
  }
  properties: {
    reserved: false
    isXenon: false
    hyperV: false
    targetWorkerCount: 0
    targetWorkerSizeId: 0
  }
}

resource webApp 'Microsoft.Web/sites@2023-12-01' = {
  name: webAppName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
    siteConfig: {
      appSettings: [
        {
          name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
          value: appInsightsConnectionString
        }
        {
          name: 'AZURE_SQL_CONNECTIONSTRING'
          value: '@Microsoft.KeyVault(SecretUri=${sqlConnectionSecretUri})'
        }
      ]
    }
  }
  dependsOn: [
    appServicePlan
  ]
}

output webAppName string = webApp.name
output WebAppUrl string = 'https://${webApp.properties.defaultHostName}'
output principlalId string = webApp.identity.principalId
