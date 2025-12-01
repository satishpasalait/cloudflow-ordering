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

output sqlServerName string = sql.outputs.sqlServerName
output sqlDatabaseName string = sql.outputs.sqlDbName
