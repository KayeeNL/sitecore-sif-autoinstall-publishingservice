$PackagesFolder = Join-Path -Path $PSScriptRoot -ChildPath "SitecorePackages"
$ConfigsRoot = Join-Path $PSScriptRoot Configs

$WebRoot = "c:\inetpub\wwwroot"

$ModulePackages = @{
    "10.4.0" = "Sitecore Publishing Module 10.4.0 rev. 00689.zip"
    "10.3.0" = "Sitecore Publishing Module 10.3.0 rev. 00663.zip"
    "10.2.0" = "Sitecore Publishing Module 10.2.0 rev. 00631.zip"
    "10.1.0" = "Sitecore Publishing Module 10.1.0 rev. 00585.zip"
    "10.0.1" = "Sitecore Publishing Module 10.0.0.0 rev. r00568.2697.zip"
    "10.0.0" = "Sitecore Publishing Module 10.0.0.0 rev. r00568.2697.zip"
    "9.3.0"  = "Sitecore Publishing Module 9.3.0.0 rev. r00546.2197.zip"
    "9.2.0"  = "Sitecore Publishing Module 9.2.0.0 rev. r00526.zip"
    "9.1.1"  = "Sitecore Publishing Module 9.1.1.0 rev. r00554.zip"
    "9.1.0"  = "Sitecore Publishing Module 9.1.0.0 rev. r00554.zip"
}

$ServicePackages = @{
    "10.4.0" = "Sitecore Publishing Service 7.0.20 rev. 0020-net6.0.zip"
    "10.3.0" = "Sitecore Publishing Service 7.0.20 rev. 0020-net6.0.zip"
    "10.2.0" = "Sitecore Publishing Service 6.0.0-netcoreapp3.1.zip"
    "10.1.0" = "Sitecore Publishing Service 5.0.0-win-x64.zip"
    "10.0.1" = "Sitecore Publishing Service 4.3.0-win-x64.zip"
    "10.0.0" = "Sitecore Publishing Service 4.3.0-win-x64.zip"
    "9.3.0"  = "Sitecore Publishing Service 4.3.0-win-x64.zip"
    "9.2.0"  = "Sitecore Publishing Service 4.3.0-win-x64.zip"
    "9.1.1"  = "Sitecore Publishing Service 4.3.0-win-x64.zip"
    "9.1.0"  = "Sitecore Publishing Service 4.3.0-win-x64.zip"
}

# The postfix that will be used on the Publishing Service.
$Postfix = "dev.local"
$SiteName = $Prefix + "." + $Postfix

####################### PUBLISHING SERVICE ###################################
$PublishingServiceInstance = "$($Prefix).publishingservice.$($Postfix)"
$PublishingServicePort = 5000
$PublishingUrl = "http://$($PublishingServiceInstance):$($PublishingServicePort)/"
$PublishingServiceConfig = @{
    PackagePath    = Join-Path -Path $PackagesFolder -ChildPath $ServicePackages[$Version]
    ContentPath    = Join-Path -Path $WebRoot -ChildPath $PublishingServiceInstance
    SitecoreLicensePath = Join-Path -Path $PackagesFolder -ChildPath "license.xml"
    CheckStatusUrl = "$($PublishingUrl)api/publishing/operations/status"
}

####################### SQL SERVER ###################################
$SqlServer = @{
    Address          = "localhost"           # The DNS name or IP of the SQL Instance.
    SqlAdminUser     = "sitecore_admin"      # A SQL user with sysadmin privileges.
    SqlAdminPassword = 'P@ssw0rd'            # The password for $SQLAdminUser.
}

####################### CONFIGURE SITECORE WITH THE PUBLISHING MODULE ###################################
$sitecoreInstance = @{
    Path          = Join-Path $ConfigsRoot sitecore.json
    Package       = Join-Path $PackagesFolder $ModulePackages[$Version]
    SiteName      = $SiteName
    PublishingUrl = $PublishingUrl
}