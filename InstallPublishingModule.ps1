param(
    [string]$Prefix = "sc10",
    [string]$Version = "10.0.1"
)

# Bring parameters into scope
. $PSScriptRoot\parameters.ps1

# Install Publishing Module onto the Sitecore instance
Write-Host "Installing the Publishing Module onto the Sitecore instance at $($sitecoreInstance.SiteName)" -ForegroundColor Green
Install-SitecoreConfiguration @sitecoreInstance