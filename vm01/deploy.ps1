<#
 .SYNOPSIS
    Deploys a template to Azure

 .DESCRIPTION
    Deploys an Azure Resource Manager template

 .PARAMETER subscriptionId
    The subscription id where the template will be deployed.

 .PARAMETER resourceGroupName
    The resource group where the template will be deployed. Can be the name of an existing or a new resource group.

 .PARAMETER resourceGroupLocation
    Optional, a resource group location. If specified, will try to create a new resource group in this location. If not specified, assumes resource group is existing.

 .PARAMETER deploymentName
    The deployment name.

 .PARAMETER templateFilePath
    Optional, path to the template file. Defaults to template.json.

 .PARAMETER parametersFilePath
    Optional, path to the parameters file. Defaults to parameters.json. If file is not found, will prompt for parameter values based on template.

ResourceGroupName : mean-app-rg
Location          : eastus2
ProvisioningState : Succeeded
Tags              : 
ResourceId        : /subscriptions/e6fcea0b-3763-447d-bc49-b568f6716972/resourceGroups/mean-app-rg

#>
#.\deploy.ps1 -subscriptionId "e6fcea0b-3763-447d-bc49-b568f6716972" -resourceGroupName "mean-app-rg" -deploymentName "DeployVm01"
param(


 [Parameter(Mandatory=$True)]
 [string]
 $subscriptionId,

 [Parameter(Mandatory=$True)]
 [string]
 $resourceGroupName,

 [string]
 $resourceGroupLocation,

 [Parameter(Mandatory=$True)]
 [string]
 $deploymentName,

 [string]
 $templateFilePath = "template.json",

 [string]
 $parametersFilePath = "parameters.json"
)

<#
.SYNOPSIS
    Registers RPs
#>
Function RegisterRP {
    Param(
        [string]$ResourceProviderNamespace
    )

    Write-Host "Registering resource provider '$ResourceProviderNamespace'";
    Register-AzureRmResourceProvider -ProviderNamespace $ResourceProviderNamespace;
}

#******************************************************************************
# Script body
# Execution begins here
#******************************************************************************
$ErrorActionPreference = "Stop"
$app="baac3562-f63d-4610-9f1d-6e1a03edd046"
$tenant="7a86c9bd-0dd6-461b-8ceb-361ea54f2dc3"
$thumb="C1960936093BA51AFBA0E2B601B38A9349921D79"
# sign in
Write-Host "Logging in...";
#Login-AzureRmAccount;
Connect-AzureRmAccount -ServicePrincipal -ApplicationId $app -TenantId $tenant -CertificateThumbprint $thumb
# select subscription
Write-Host "Selecting subscription '$subscriptionId'";
Select-AzureRmSubscription -Subscription $subscriptionId;

# Register RPs
$resourceProviders = @("microsoft.compute","microsoft.devtestlab","microsoft.storage","microsoft.network");
if($resourceProviders.length) {
    Write-Host "Registering resource providers"
    foreach($resourceProvider in $resourceProviders) {
        RegisterRP($resourceProvider);
    }
}

#Create or check for existing resource group
$resourceGroup = Get-AzureRmResourceGroup -Name $resourceGroupName -ErrorAction SilentlyContinue
if(!$resourceGroup)
{
    Write-Host "Resource group '$resourceGroupName' does not exist. To create a new resource group, please enter a location.";
    if(!$resourceGroupLocation) {
        $resourceGroupLocation = Read-Host "resourceGroupLocation";
    }
    Write-Host "Creating resource group '$resourceGroupName' in location '$resourceGroupLocation'";
    New-AzureRmResourceGroup -Name $resourceGroupName -Location $resourceGroupLocation
}
else{
    Write-Host "Using existing resource group '$resourceGroupName'";
}

# Start the deployment
Write-Host "Starting deployment...";
if(Test-Path $parametersFilePath) {
    New-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroupName -TemplateFile $templateFilePath -TemplateParameterFile $parametersFilePath;
} else {
    New-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroupName -TemplateFile $templateFilePath;
}

Write-Host "Deployment Complete. Begin Configuration"
#CLI Login
az login --service-principal -u "baac3562-f63d-4610-9f1d-6e1a03edd046" --tenant "7a86c9bd-0dd6-461b-8ceb-361ea54f2dc3" --password "4uKwCCty0CmL+kK61TBx1i32WfarjImoimmw0ZwZ8kQ="

#ResourceGroupName "mean-app-rg" 
#VMName "mean-app-vm01"
#https://docs.microsoft.com/en-us/azure/virtual-machines/extensions/custom-script-linux
az vm extension set  --resource-group "mean-app-rg" --vm-name "mean-app-vm01" --name customScript  --publisher Microsoft.Azure.Extensions --settings .\script-config.json




#CLI Login
#az login --service-principal -u "baac3562-f63d-4610-9f1d-6e1a03edd046" --tenant "7a86c9bd-0dd6-461b-8ceb-361ea54f2dc3" --password "4uKwCCty0CmL+kK61TBx1i32WfarjImoimmw0ZwZ8kQ="
#az vm run-command invoke -g "mean-app-rg" -n "mean-app-vm01" --command-id RunShellScript --scripts "sudo apt-get update && sudo apt-get install -y nginx