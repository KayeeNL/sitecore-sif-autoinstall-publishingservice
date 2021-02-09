$PackagesFolder = Join-Path -Path $PSScriptRoot -ChildPath "SitecorePackages"
$ConfigsRoot = Join-Path $PSScriptRoot Configs

$WebRoot = "c:\inetpub\wwwroot"

$ModulePackages = @{
    "10.0.1" = "Sitecore Publishing Module 10.0.0.0 rev. r00568.2697.zip"
    "10.0.0" = "Sitecore Publishing Module 10.0.0.0 rev. r00568.2697.zip"
    "9.3.0"  = "Sitecore Publishing Module 9.3.0.0 rev. r00546.2197.zip"
    "9.2.0"  = "Sitecore Publishing Module 9.2.0.0 rev. r00526.zip"
    "9.1.1"  = "Sitecore Publishing Module 9.1.1.0 rev. r00554.zip"
    "9.1.0"  = "Sitecore Publishing Module 9.1.0.0 rev. r00554.zip"
}

# The postfix that will be used on the Publishing Service.
$Postfix = "dev.local"
$SiteName = $Prefix + "." + $Postfix

####################### PUBLISHING SERVICE ###################################
$PublishingServiceInstance = "$($Prefix).publishingservice.$($Postfix)"
$PublishingServicePort = 5000
$PublishingUrl = "http://$($PublishingServiceInstance):$($PublishingServicePort)/"
$PublishingServiceConfig = @{
    PackagePath    = Join-Path -Path $PackagesFolder -ChildPath "Sitecore Publishing Service 4.3.0-win-x64.zip"
    ContentPath    = Join-Path -Path $WebRoot -ChildPath $PublishingServiceInstance
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