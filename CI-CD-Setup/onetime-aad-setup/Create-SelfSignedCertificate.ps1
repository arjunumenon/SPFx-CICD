<#
.SYNOPSIS
Creates a Self Signed Certificate for use in server to server authentication
.DESCRIPTION
.EXAMPLE
.\Create-SelfSignedCertificate.ps1 -CommonName "MyCert" -StartDate 2015-11-21 -EndDate 2017-11-21
This will create a new self signed certificate with the common name "CN=MyCert". During creation you will be asked to provide a password to protect the private key.
.EXAMPLE
.\Create-SelfSignedCertificate.ps1 -CommonName "MyCert" -StartDate 2015-11-21 -EndDate 2017-11-21 -Password "MyPassword"
This will create a new self signed certificate with the common name "CN=MyCert". The password as specified in the Password parameter will be used to protect the private key
#>
Param(

   [Parameter(Mandatory=$true)]
   [string]$CommonName,

   [Parameter(Mandatory=$true)]
   [DateTime]$StartDate,

   [Parameter(Mandatory=$true)]
   [DateTime]$EndDate,

   [Parameter(Mandatory=$true)]
   [string]$Password
)


function CreateSelfSignedCertificate{

    $cert = New-SelfSignedCertificate -Subject "CN=$CommonName" -FriendlyName $CommonName -NotBefore $StartDate -NotAfter $EndDate  -CertStoreLocation "Cert:\CurrentUser\My" -KeyExportPolicy Exportable -KeySpec Signature -KeyLength 2048 -KeyAlgorithm RSA -HashAlgorithm SHA256

    # Export Certificate from Variable to cert file to the location where script is executed
    Export-Certificate -Cert $cert -FilePath ".\$CommonName.cer"

    # Secure the file with password for enhanced security
    $mypwd = ConvertTo-SecureString -String "$Password" -Force -AsPlainText

    # Exporting the file to PFX file with Password
    Export-PfxCertificate -Cert $cert -FilePath ".\$CommonName.pfx" -Password $mypwd
}

CreateSelfSignedCertificate