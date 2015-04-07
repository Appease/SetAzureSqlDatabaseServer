# halt immediately on any errors which occur in this module
$ErrorActionPreference = 'Stop'
Import-Module 'C:\Program Files (x86)\Microsoft SDKs\Azure\PowerShell\ResourceManager\AzureResourceManager' -Force -RequiredVersion '0.8.8'
Import-Module 'C:\Program Files (x86)\Microsoft SDKs\Azure\PowerShell\ServiceManagement\Azure' -Force -RequiredVersion '0.8.8'

function Invoke(

    [string]
    [ValidateNotNullOrEmpty()]
    [Parameter(
        Mandatory=$true,
        ValueFromPipelineByPropertyName=$true)]
    $Name,

    [string]
    [ValidateNotNullOrEmpty()]
    [Parameter(
        Mandatory=$true,
        ValueFromPipelineByPropertyName=$true)]
    $ResourceGroupName,

    [string]
    [ValidateNotNullOrEmpty()]
    [Parameter(
        Mandatory=$true,
        ValueFromPipelineByPropertyName=$true)]
    $Location,

    [string]
    [ValidateNotNullOrEmpty()]
    [Parameter(
        Mandatory=$true,
        ValueFromPipelineByPropertyName=$true)]
    $AdministratorLogin,

    [string]
    [ValidateNotNullOrEmpty()]
    [Parameter(
        Mandatory=$true,
        ValueFromPipelineByPropertyName=$true)]
    $AdministratorLoginPassword,

    [string]
    [ValidateNotNullOrEmpty()]
    [Parameter(
        Mandatory=$true,
        ValueFromPipelineByPropertyName=$true)]
    $Version
){

    $ApiVersion = '2014-04-01'
    $ResourceType = 'Microsoft.Sql/servers'
    $AzureSqlDatabaseServerResources = AzureResourceManager\Get-AzureResource -ResourceType $ResourceType 
    $ExistingAzureSqlDatabaseServerResource = $AzureSqlDatabaseServerResources | ? {$_.Name -eq $Name}

    Write-Output $ExistingAzureSqlDatabaseServerResource
        
    # handle new
    If(!$ExistingAzureSqlDatabaseServerResource){
        
        # build up property Hashtable from parameters
        $Properties = @{
            administratorLogin=$AdministratorLogin;
            administratorLoginPassword=$AdministratorLoginPassword;
            version=$Version
        }
        
        AzureResourceManager\New-AzureResource `
        -Location $Location `
        -Name $Name `
        -ResourceGroupName $ResourceGroupName `
        -ResourceType $ResourceType `
        -ApiVersion $ApiVersion `
        -PropertyObject $Properties
    }
    # handle existing
    Else{

        $ExistingAzureSqlDatabaseServer = Get-AzureSqlDatabaseServer -ServerName $Name

        # handle location
        if($ExistingAzureSqlDatabaseServer.Location -ne $Location){            
            throw "Changing an Azure Sql Database Server location is (currently) unsupported"
        }

        # handle resource group
        If($ExistingAzureSqlDatabaseServerResource.ResourceGroupName -ne $ResourceGroupName){
            
            throw "Changing an Azure Sql Database Server resource group is (currently) unsupported"

            # @TODO: 
            # according to: http://azure.microsoft.com/en-us/documentation/articles/powershell-azure-resource-manager/
            # the following should work but Move-AzureResource is not present in the 0.8.8 sdk.. 
            # AzureResourceManager\Move-AzureResource -DestinationResourceGroupName $ResourceGroupName -ResourceId 
        }

        # handle administrator login
        If($ExistingAzureSqlDatabaseServer.AdministratorLogin -ne $AdministratorLogin){
            throw "Changing the Azure Sql Database Server administrator login is (currently) unsupported"
        }

        # handle version
        If($ExistingAzureSqlDatabaseServer.Version -ne $Version){
            AzureResourceManager\Set-AzureResource `
            -Name $Name `
            -ResourceGroupName $ResourceGroupName `
            -ResourceType $ResourceType `
            -ApiVersion $ApiVersion `
            -PropertyObject @{version=$Version}
        }

        # cannot get existing password so just overwrite it to ensure it's set to the desired value
        Azure\Set-AzureSqlDatabaseServer -ServerName $Name -AdminPassword $AdministratorLoginPassword        
    }
}

Export-ModuleMember -Function Invoke
