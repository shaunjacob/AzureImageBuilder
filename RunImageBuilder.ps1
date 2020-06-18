# Connect to Azure
Login-AzAccount
Select-AzSubscription "b20a9108-a5ef-474b-a027-4dbf612ca600"
Import-Module Az.Accounts

# Get existing context
$currentAzContext = Get-AzContext

#Variables
$imageResourceGroup = "aibwinsig"
$location = "Westus2"
$imageTemplateName = "testwin10shared2"
$sigGalleryName= "myaibsig01"
$imageDefName ="winSvrimages"
$idenityName="testaibidentity080620"
$imageResourceGroup="aibwinsig"
$location="westus"
$subscriptionID=$currentAzContext.Subscription.Id
$imageName="aibCustomImgWin10"
$imageTemplateName="helloImageTemplateWin02ps"
$runOutputName="winclientR01"


# Create Shared Image Gallery, choose replica region and gallery definition
$sigGalleryName= "myaibsig01"
$imageDefName ="winSvrimages"
$replRegion2="eastus"
New-AzGallery -GalleryName $sigGalleryName -ResourceGroupName $imageResourceGroup  -Location $location
New-AzGalleryImageDefinition -GalleryName $sigGalleryName -ResourceGroupName $imageResourceGroup -Location $location -Name $imageDefName -OsState generalized -OsType Windows -Publisher 'myCo' -Offer 'Windows' -Sku 'Win2019'


# Template URL and path
$templateUrl="https://raw.githubusercontent.com/shaunjacob/AzureImageBuilder/master/AzureImageBuilder-SharedImage.json"
$templateFilePath = "AzureImageBuilder-SharedImage.json"
Invoke-WebRequest -Uri $templateUrl -OutFile $templateFilePath -UseBasicParsing

# Submit template to AIB
New-AzResourceGroupDeployment -ResourceGroupName $imageResourceGroup -TemplateFile $templateFilePath -api-version "2019-05-01-preview" -imageTemplateName $imageTemplateName -svclocation $location


# Run the build
Invoke-AzResourceAction -ResourceName $imageTemplateName -ResourceGroupName $imageResourceGroup -ResourceType Microsoft.VirtualMachineImages/imageTemplates -ApiVersion "2019-05-01-preview" -Action Run -Force

# Get Status
(Get-AzResource -ResourceGroupName $imageResourceGroup -ResourceType Microsoft.VirtualMachineImages/imageTemplates -Name $imageTemplateName).Properties.lastRunStatus | select -ExpandProperty message