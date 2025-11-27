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
