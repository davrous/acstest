param name string

@allowed([
    'Central US'
    'East Asia'
    'East US 2'
    'West Europe'
    'West US 2'
])
param swaLocation string = 'Central US'

@allowed([
    'Free'
    'Standard'
])
param swaSkuName string = 'Free'

param swaAllowConfigFileUpdates bool = true

@allowed([
    'Disabled'
    'Enabled'
])
param swaStagingEnvironmentPolicy string = 'Enabled'

@secure()
param acsvcConnectionString string

@secure()
param cosdbaConnectionString string

var staticApp = {
    name: 'staticwebapp-${name}'
    location: swaLocation
    skuName: swaSkuName
    allowConfigFileUpdates: swaAllowConfigFileUpdates
    stagingEnvironmentPolicy: swaStagingEnvironmentPolicy
    connectionStrings: {
        acs: acsvcConnectionString
        cosmosDb: cosdbaConnectionString
    }
}

resource swa 'Microsoft.Web/staticSites@2021-03-01' = {
    name: staticApp.name
    location: staticApp.location
    sku: {
        name: staticApp.skuName
    }
    properties: {
        allowConfigFileUpdates: staticApp.allowConfigFileUpdates
        stagingEnvironmentPolicy: staticApp.stagingEnvironmentPolicy
    }
}

resource swaconfig 'Microsoft.Web/staticSites/config@2021-03-01' = {
    name: '${swa.name}/appsettings'
    properties: {
        ACS_ConnectionString: staticApp.connectionStrings.acs
        MyAccount_COSMOSDB: staticApp.connectionStrings.cosmosDb
    }
}

output id string = swa.id
output name string = swa.name
output deploymentKey string = swa.listSecrets().properties.apiKey
