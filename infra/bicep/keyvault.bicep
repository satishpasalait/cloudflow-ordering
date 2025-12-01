param location string
param keyVaultName string

param sqlConnectionSecretName string

@secure()
param sqlConnectionString string

resource keyVault 'Microsoft.KeyVault/vaults@2024-10-01' = {
  name: keyVaultName
  location: location
  properties: {
    sku: {
      name: 'standard'
      family: 'A'
    }
    tenantId: subscription().tenantId
    accessPolicies: []
    enabledForDeployment: true
    enabledForTemplateDeployment: true
    enableSoftDelete: true
    enablePurgeProtection: true
  }
}

resource sqlConnectionSecret 'Microsoft.KeyVault/vaults/secrets@2024-10-01' = {
  name: '${keyVault.name}/${sqlConnectionSecretName}'
  properties: {
    value: sqlConnectionString
  }
  dependsOn: [
    keyVault
  ]
}

output keyValultName string = keyVault.name
output keyVaultId string = keyVault.id
output sqlConnectionSecretUri string = sqlConnectionSecret.properties.secretUriwithVersion
