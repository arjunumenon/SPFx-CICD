<#
.SYNOPSIS
Adds the App to the SharePoint App Catalog. Script could be used for CI/CD setup in Azure DevOps
.DESCRIPTION
.EXAMPLE
.\m365-spo-login.ps1 -certificateFile "$(caCertificate.secureFilePath)" --password "" --appId "$(AppId)" --tenant "$(TenantId)"
Initiate Login in the Ci-CD Pipeline
.EXAMPLE
.\m365-spo-login.ps1 -certificateFile "C:\Arjun\Codes\m365-devzone\dev-scripts\certificate\AUM Azure DevOps Deployment.pfx" -password "" -appId "ceefb710-f9cf-4618-af60-1a163f5ea74c" -TenantId "095efa67-57fa-40c7-b7cc-e96dc3e5780c"
Initiate Login directly from the machine
#>
Param(

        [Parameter(Mandatory = $true)]
        [string]$certificateFile,
        [Parameter(Mandatory = $false)]
        [string]$password,
        [Parameter(Mandatory = $true)]
        [string]$appId,
        [Parameter(Mandatory=$true)]
        [string]$TenantId
)

function m365loginCertificate{

    m365 login --authType certificate --certificateFile $certificateFile --password $password --appId $appId --tenant $TenantId

    m365 status
}

m365loginCertificate