<#
.SYNOPSIS
Adds the App to the SharePoint App Catalog. Script could be used for CI/CD setup in Azure DevOps
.DESCRIPTION
.EXAMPLE
.\m365-spo-login.ps1 -certificateFile "$(caCertificate.secureFilePath)" --password "" --appId "$(AppId)" --tenant "$(TenantId)"
Initiate Login in the Ci-CD Pipeline
.EXAMPLE
.\m365-spo-login.ps1 -certificateFile "C:\Arjun\dev-rnd\SPFx-CI-CD-Setup-GH\CI-CD-Setup\onetime-aad-setup\AUM CI-CD Deployment App Certificate.pfx" -password "TempP@ssw0rd" -appId "7ccd6d8e-a2ff-41ad-a3b2-176047c68ad1" -TenantId "095efa67-57fa-40c7-b7cc-e96dc3e5780c"
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