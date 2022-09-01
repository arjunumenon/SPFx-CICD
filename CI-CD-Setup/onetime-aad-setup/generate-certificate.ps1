# # Generate Certificate Approach
# Doing Dummy update for testing CI/CD
$CertCommonName = "AUM CI-CD Deployment App Certificate"
$CertStartDate = "2022-02-02"
$CertEndDate = "2023-10-02"
$CertificatePassword = "TempP@ssw0rd"

.\Create-SelfSignedCertificate.ps1 -CommonName $CertCommonName -StartDate $CertStartDate  -EndDate $CertEndDate -Password $CertificatePassword