targetScope = 'subscription'

param name string
@allowed([
    'Australia Central'
    'Australia East'
    'Australia Southeast'
    'Brazil South'
    'Canada Central'
    'Canada East'
    'Central India'
    'Central US'
    'East Asia'
    'East US'
    'East US 2'
    'France Central'
    'Germany West Central'
    'Japan East'
    'Japan West'
    'Jio India West'
    'Korea Central'
    'Korea South'
    'North Central US'
    'North Europe'
    'Norway East'
    'South Africa North'
    'South Central US'
    'South India'
    'Southeast Asia'
    'Sweden Central'
    'Switzerland North'
    'UAE North'
    'UK South'
    'UK West'
    'West Central US'
    'West Europe'
    'West India'
    'West US'
    'West US 2'
    'West US 3'
])
param location string = 'West US'

// Cosmos DB
@allowed([
    'Standard'
])
param cosdbaAccountOfferType string = 'Standard'
param cosdbaAutomaticFailover bool = true
@allowed([
    'Strong'
    'BoundedStaleness'
    'Session'
    'ConsistentPrefix'
    'Eventual'
])
param cosdbaConsistencyLevel string = 'Session'
@allowed([
    'Australia Central'
    'Australia East'
    'Australia Southeast'
    'Brazil South'
    'Canada Central'
    'Canada East'
    'Central India'
    'Central US'
    'East Asia'
    'East US'
    'East US 2'
    'France Central'
    'Germany West Central'
    'Japan East'
    'Japan West'
    'Jio India West'
    'Korea Central'
    'Korea South'
    'North Central US'
    'North Europe'
    'Norway East'
    'South Africa North'
    'South Central US'
    'South India'
    'Southeast Asia'
    'Sweden Central'
    'Switzerland North'
    'UAE North'
    'UK South'
    'UK West'
    'West Central US'
    'West Europe'
    'West India'
    'West US'
    'West US 2'
    'West US 3'
])
param cosdbaPrimaryRegion string = 'West US'
param cosdbaEnableServerless bool = true
@allowed([
    'Local'
    'Zone'
    'Geo'
])
param cosdbaBackupStorageRedundancy string = 'Local'

// Azure Communication Services
@allowed([
    'Africa'
    'Asia Pacific'
    'Australia'
    'Brazil'
    'Canada'
    'Europe'
    'France'
    'Germany'
    'India'
    'Japan'
    'Korea'
    'United Kingdom'
    'United States'
])
param acsvcDataLocation string = 'United States'

// Static Web App
@allowed([
    'Central US'
    'East Asia'
    'East US 2'
    'West Europe'
    'West US 2'
])
param swaLocation string = 'Central US'
param swaSkuName string = 'Free'
param swaAllowConfigFileUpdates bool = true
@allowed([
    'Disabled'
    'Enabled'
])
param swaStagingEnvironmentPolicy string = 'Enabled'

resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
    name: 'rg-${name}'
    location: location
}

module resources './main.bicep' = {
    name: 'Resources'
    scope: rg
    params: {
        name: name

        cosdbaLocation: rg.location
        cosdbaAccountOfferType: cosdbaAccountOfferType
        cosdbaAutomaticFailover: cosdbaAutomaticFailover
        cosdbaConsistencyLevel: cosdbaConsistencyLevel
        cosdbaPrimaryRegion: cosdbaPrimaryRegion
        cosdbaEnableServerless: cosdbaEnableServerless
        cosdbaBackupStorageRedundancy: cosdbaBackupStorageRedundancy

        acsvcDataLocation: acsvcDataLocation

        swaLocation: swaLocation
        swaSkuName: swaSkuName
        swaAllowConfigFileUpdates: swaAllowConfigFileUpdates
        swaStagingEnvironmentPolicy: swaStagingEnvironmentPolicy
    }
}

output cosdbaConnectionString string = resources.outputs.cosdbaConnectionString
output acsvcConnectionString string = resources.outputs.acsvcConnectionString
output swaDeploymentKey string = resources.outputs.swaDeploymentKey
