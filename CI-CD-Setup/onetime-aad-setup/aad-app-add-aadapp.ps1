<#
.SYNOPSIS
Create Azure AD App Registration
.DESCRIPTION
.EXAMPLE
.\aad-app-add-aadapp.ps1 -AppName "AUM CI-CD Deployment App"
Create AAD App without Certificate and Admin Consent
.EXAMPLE
.\aad-app-add-aadapp.ps1 -AppName "AUM CI-CD Deployment App"  -CertificatePath ".\AUM CI-CD Deployment App Certificate.pfx" -CertificatePassword "TempP@ssw0rd" -AutoAdminConsent
Create AAD App WITH Certificate and Admin Consent
#>
Param(
    [Parameter(Mandatory = $true)]
    [string]$AppName,
    [Parameter(Mandatory = $false)]
    [string]$APIPermissionList = "https://microsoft.sharepoint-df.com/Sites.FullControl.All, https://graph.microsoft.com/Sites.Read.All",
    [Parameter(Mandatory = $false)]
    [switch]$AutoAdminConsent = $false,
    [Parameter(Mandatory = $false)]
    [string]$CertificatePath
)


function executeAADAppCreation {

    # Checking Login status and initiate login if not logged
    $LoginStatus = m365 status
    if ($LoginStatus -eq "Logged out") {
        Write-Host "Not logged in. Initiating Login process"
        m365 login
    }

    $AddedApp = $null

    # Get the Certificate String from PFX File
    # It will prompt for the password and you will have to enter the same password which was given while generation
    $EncodedCertificateString = [System.Convert]::ToBase64String((
            Get-PfxCertificate -FilePath $CertificatePath).GetRawCertData())

    if ($AutoAdminConsent) {
        # # Complete Automation Requires Azure CLI to be installed
        # # https://docs.microsoft.com/en-us/cli/azure/install-azure-cli
        # # Consenting the Application using Azure CLI
        # az ad app permission admin-consent --id $($AddedApp.objectId)
        $AddedApp = (m365 aad app add --name $AppName --apisApplication $APIPermissionList  --redirectUris "https://login.microsoftonline.com/common/oauth2/nativeclient" --platform publicClient --certificateBase64Encoded $EncodedCertificateString --grantAdminConsent --output json) | ConvertFrom-Json
        Write-Host "AAD App Created with details. App ID : $($AddedApp.appId). Object ID : $($AddedApp.objectId). Tenant ID : $($AddedApp.tenantId)"
    }
    else {
        $AddedApp = (m365 aad app add --name $AppName --apisApplication $APIPermissionList  --redirectUris "https://login.microsoftonline.com/common/oauth2/nativeclient" --platform publicClient --certificateBase64Encoded $EncodedCertificateString --output json) | ConvertFrom-Json
        Write-Host "AAD App Created with details. App ID : $($AddedApp.appId). Object ID : $($AddedApp.objectId). Tenant ID : $($AddedApp.tenantId)"
        # Manually Opening the URL with the browser
        Write-Host "Open this URL for consenting the permission - https://login.microsoftonline.com/$($AddedApp.tenantId)/v2.0/adminconsent?client_id=$($AddedApp.appId)&scope=.default"
    }

    # # Adding Certificate File to AAD App
    # .\aad-app-certificate-add.ps1 -CertificatePath $CertificatePath -AppId $($AddedApp.objectId)
}

executeAADAppCreation
