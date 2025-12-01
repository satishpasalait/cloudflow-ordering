param location string
param baseName string
param sqlAdminLogin string

@secure()
param sqlAdminPassword string

// Unique server name per RG
var sqlServerName = toLower('${baseName}-sql-${uniqueString(resourceGroup().id)}')
var sqlDBName = '${baseName}-db'

resource sqlServer 'Microsoft.Sql/servers@2024-11-01-preview' = {
  name: sqlServerName
  location: location
  properties: {
    administratorLogin: sqlAdminLogin
    administratorLoginPassword: sqlAdminPassword
    version: '12.0'
  }
}

resource sqlDatabase 'Microsoft.Sql/servers/databases@2024-11-01-preview' = {
  name: '${sqlServer.name}/${sqlDBName}'
  location: location
  properties: {
    sku: {
      name: 'S0'
      tier: 'Standard'
      capacity: 10
    }
    maxSizeBytes: 2147483648 // 2 GB
  }
  dependsOn: [
    sqlServer
  ]
}

// Output the SQL connection string
output sqlServerName string = sqlServer.name
output sqlDbName string = sqlDatabase.name
output sqlFqdn string = sqlServer.properties.fullyQualifiedDomainName

