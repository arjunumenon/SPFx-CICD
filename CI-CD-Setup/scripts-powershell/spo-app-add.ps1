<#
.SYNOPSIS
Adds the App to the SharePoint App Catalog
.DESCRIPTION
.EXAMPLE
.\spo-app-add.ps1 -PackageFolder "$(System.DefaultWorkingDirectory)/$(ProjectFolder)/drop/$(SolutionPackageLocation)/" -packageName "$(PackageName)" -URL "$(SiteCollection)"
Installing the App command from CI-CD Pipeline
.EXAMPLE
.\spo-app-add.ps1 -PackageFolder "C:\Arjun\Codes\m365-ci-cd-solution\SPFx-CI-CD-Setup\SPFx-CICD-1\sharepoint\solution\" -packageName "sp-fx-cicd-1.sppkg" -URL "https://aum365.sharepoint.com/sites/M365CLI"
Installing the app from base machine
#>
Param(

        [Parameter(Mandatory = $true)]
        [string]$PackageFolder,
        [Parameter(Mandatory = $true)]
        [string]$packageName,
        [Parameter(Mandatory = $true)]
        [string]$URL,
        [Parameter(Mandatory=$false)]
        [boolean]$IsAdd = $true,
        [Parameter(Mandatory=$false)]
        [boolean]$IsDeploy = $true,
        [Parameter(Mandatory=$false)]
        [boolean]$IsInstall = $true
)


function addCustomApp{

    $CompletePath = "$PackageFolder/$packageName"

    #Check if App is already installed
    $IsDeployed = checkIfAppIsInstalled -packageName $packageName -URL $URL

    if($IsAdd)
    {
        Write-Host "Adding App Catalog : $packageName"
        $AppId = m365 spo app add --filePath $CompletePath --scope sitecollection --appCatalogUrl $URL --overwrite
    }

    if($IsDeploy)
    {
        #Deploy the app
        deployCustomApp -URL $URL -AppId $AppId
    }

    if($IsInstall)
    {
        #Install Custom App
        if($IsDeployed)
        {
            Write-Host "App is already deployed. Hence skipping installation"
        }
        else
        {
            Write-Host "App with name $packageName is not deployed. Installing it now"
            installCustomApp -URL $URL -AppId $AppId
        }
    }
}

function deployCustomApp{
    param (
        [Parameter(Mandatory = $true)]
        [string]$AppId,
        [Parameter(Mandatory = $true)]
        [string]$URL
    )

    Write-Host "Deploying App with ID : $AppId"
    m365 spo app deploy --id $AppId --scope sitecollection --appCatalogUrl $URL
}

function installCustomApp{
    param (
        [Parameter(Mandatory = $true)]
        [string]$AppId,
        [Parameter(Mandatory = $true)]
        [string]$URL
    )

    Write-Host "Installing App with ID : $AppId"
    m365 spo app install --id $AppId --siteUrl $URL --scope sitecollection
}

function checkIfAppIsInstalled{
    param (
        [Parameter(Mandatory = $true)]
        [string]$packageName,
        [Parameter(Mandatory = $true)]
        [string]$URL
    )

    $IsDeployed = (m365 spo app get --name $packageName --scope sitecollection --appCatalogUrl $URL --output json --query "{Deployed: Deployed}") | ConvertFrom-Json

    return $IsDeployed.Deployed
}

addCustomApp