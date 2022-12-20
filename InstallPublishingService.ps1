param(
    [switch] $UpdateSchemasOnly,
    [switch] $Uninstall,
    [string] $Prefix = "sc10",
    [string] $Version = "10.2.0"
)
. $PSScriptRoot\parameters.ps1

$ErrorActionPreference = 'Stop'

$ConnectionStringTemplate = "user id=$($SqlServer.SqlAdminUser);password=$($SqlServer.SqlAdminPassword);data source=$($SqlServer.Address);database={0};MultipleActiveResultSets=True;"

Function Extract-PublishingServiceContent {
    Write-Host "Extracting Publishing Package....." -ForegroundColor Green
	
    If (!(Test-Path -Path $PublishingServiceConfig.PackagePath )) {
        throw "The Publishing Service package must be downloaded"
    }
	
    If (!(Test-Path -Path $PublishingServiceConfig.ContentPath)) {
        New-Item -Path $PublishingServiceConfig.ContentPath -ItemType Directory -Force
    }

    Expand-Archive -Path $PublishingServiceConfig.PackagePath -DestinationPath $PublishingServiceConfig.ContentPath
}

Function Get-PublishingHostTool {
    If (!(Test-Path($PublishingServiceConfig.ContentPath))) {
        throw "Could not find the instance of Publishing Service"
    }
    
    Set-Location -Path $PublishingServiceConfig.ContentPath
    return (Get-Command ".\Sitecore.Framework.Publishing.Host.exe")
}

Function Update-ConnectionString ([string] $DatabaseName) {
    Write-Host "Updating connectionstring for $($DatabaseName)" -ForegroundColor Green

    $ActualDatabaseName = "$($Prefix)_$($DatabaseName)"
    $ConnectionStringForDatabase = ($ConnectionStringTemplate -f $ActualDatabaseName)
    & $ExeFile configuration setconnectionstring "$($DatabaseName)" "$($ConnectionStringForDatabase)"
}

Function Update-InstanceName {
    & $ExeFile configuration set Sitecore:Publishing:InstanceName -v $SitecoreContentManagementSitename
}

Function Update-Schemas {
    & $ExeFile schema upgrade --force
}

Function Create-PublishingServiceSite {
    & $ExeFile iis install -s "$($PublishingServiceInstance)" -a "$($PublishingServiceInstance)" -p $PublishingServicePort --force
}

Function Update-HostsFile {
    $HostsFile = "$($env:windir)\system32\Drivers\etc\hosts"
    $Content = Get-Content -Path $HostsFile
    $HostsFileRecord = "127.0.0.1 $($PublishingServiceInstance)"
    If (-not ($Content -contains "$HostsFileRecord")) {
        $HostsFileRecord | Add-Content -PassThru $HostsFile
    }
}

Function Verify-PublishingService {
    $PublishingServiceStatusRequest = [System.Net.WebRequest]::Create($PublishingServiceConfig.CheckStatusUrl)
    $PublishingServiceStatusResponse = $PublishingServiceStatusRequest.GetResponse();

    try {
        if ($PublishingServiceStatusResponse.StatusCode -ne 200) {
            Write-Host "Could not contact Publishing Service on '$($PublishingServiceConfig.CheckStatusUrl)'. Response status was '$PublishingServiceStatusResponse.StatusCode'" -ForegroundColor Red
        }
        else {
            $reqstream = $PublishingServiceStatusResponse.GetResponseStream()
            $sr = new-object System.IO.StreamReader $reqstream
            $result = $sr.ReadToEnd()
            
            If ($result -eq '{"status":0}') {
                Write-Host "Install $($PublishingServiceInstance) successfully" -ForegroundColor Green
            }

        }
    }
    finally {
        $PublishingServiceStatusResponse.Close()
    }
}



function Remove-IISSite($name) {
    # Delete site
    if (Get-Website $name) {
        Remove-Website $name
        Write-Host "IIS site $name is uninstalled" -ForegroundColor Green
    }
    else {
        Write-Host "Could not find IIS site $name" -ForegroundColor Yellow
    }

    # Delete app pool
    if (Get-IISAppPool $name) {
        Remove-WebAppPool $name
        Write-Host "IIS App Pool $name is uninstalled" -ForegroundColor Green
    }
    else {
        Write-Host "Could not find IIS App Pool $name" -ForegroundColor Yellow
    }
}

function Remove-IISFiles($path) {
    # Delete site
    if (Test-Path($path)) {
        Remove-Item $path -Recurse -Force
        Write-Host "Removing files $path" -ForegroundColor Green
    }
    else {
        Write-Host "Could not find files $path" -ForegroundColor Yellow
    }
}

################################### EXECUTION ###############################################################

Push-Location $PSScriptRoot

If (-Not $Uninstall) {
    If ($UpdateSchemasOnly) {
        $ExeFile = Get-PublishingHostTool
        Update-Schemas    
    }
    Else {
        Write-Host "*******************************************************" -ForegroundColor Yellow
        Write-Host " Installing Publishing Service for: $($SitecoreContentManagementSitename)" -ForegroundColor Green
        Write-Host " Instance: $($PublishingServiceInstance):$($PublishingServicePort)" -ForegroundColor Green
        Write-Host "*******************************************************" -ForegroundColor Yellow
        Extract-PublishingServiceContent
        $ExeFile = Get-PublishingHostTool
    
        Update-ConnectionString -DatabaseName "core"
        Update-ConnectionString -DatabaseName "master"
        Update-ConnectionString -DatabaseName "web"
        Update-InstanceName
        Update-Schemas
        Create-PublishingServiceSite
        Update-HostsFile
        Verify-PublishingService
    }
}
Else {
    Write-Host "*******************************************************" -ForegroundColor Yellow
    Write-Host " Uninstalling Publishing Service: $($PublishingServiceInstance):$($PublishingServicePort)" -ForegroundColor Green
    Write-Host "*******************************************************" -ForegroundColor Yellow
    Import-Module WebAdministration
    IISRESET /STOP
    Remove-IISSite $PublishingServiceInstance
    Remove-IISFiles $PublishingServiceConfig.ContentPath
    IISRESET /START
    Start-Sleep 10
}

Pop-Location
