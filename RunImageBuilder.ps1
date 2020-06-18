#Connect to Azure
Login-AzAccount
Select-AzSubscription "b20a9108-a5ef-474b-a027-4dbf612ca600"

# Step 1: Import module
Import-Module Az.Accounts

# Step 2: get existing context
$currentAzContext = Get-AzContext

# destination image resource group
$imageResourceGroup="aibwinsig01"

# location (see possible locations in main docs)
$location="westus"

# your subscription, this will get your current subscription
$subscriptionID=$currentAzContext.Subscription.Id

# name of the image to be created
$imageName="aibCustomImgWin10"

# image template name
$imageTemplateName="helloImageTemplateWin02ps"

# distribution properties object name (runOutput), i.e. this gives you the properties of the managed image on completion
$runOutputName="winclientR01"

# create resource group
New-AzResourceGroup -Name $imageResourceGroup -Location $location


#Variables
$imageResourceGroup = "aibwinsig"
$templateFilePath = "C:\Users\ShaunJacob\Documents\GitHub\SJAzureImageBuilder\AzureImageBuilder-SharedImage.json"
$location = "Westus2"
$imageTemplateName = "testwin10shared"


#Submit template to AIB
#New-AzResourceGroupDeployment -ResourceGroupName $imageResourceGroup -TemplateFile $templateFilePath -ApiVersion "2019-05-01-preview" -ima $imageTemplateName -svclocation $location
New-AzResourceGroupDeployment -ResourceGroupName $imageResourceGroup -TemplateFile $templateFilePath -OutVariable Output -Verbose

#Run the build
$Output.Outputs["imageTemplateName"].Value

Invoke-AzResourceAction -ResourceGroupName $imageResourceGroup -ResourceType Microsoft.VirtualMachineImages/imageTemplates -ResourceName AIBo7ydjba3c26rg -Action Run -Force

#Get Status
(Get-AzResource -ResourceGroupName $imageResourceGroup -ResourceType Microsoft.VirtualMachineImages/imageTemplates -Name AIBo7ydjba3c26rg).Properties.lastRunStatus | select -ExpandProperty message

$urlBuildStatus = [System.String]::Format("{0}subscriptions/{1}/resourceGroups/$imageResourceGroup/providers/Microsoft.VirtualMachineImages/imageTemplates/{2}?api-version=2019-05-01-preview", $managementEp, $currentAzureContext.Subscription.Id,$imageTemplateName)