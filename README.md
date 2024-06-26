# SIF scripts for Sitecore to autoinstall the Sitecore Publishing Service (SPS) and the corresponding Publishing Module.

The Publishing Service allows for high-performance publishing in large scale Sitecore setups.

This project **contains 2 Powershell scripts** that both use the Sitecore Install Framework (SIF) to **auto install the Publishing Service** &amp; **auto install the Publishing Module** on top of the ContentManagement instance or StandAlone instance through the use of Powershell.

# Prerequisites

**=== Read the readme.txt file in the SitecorePackages directory! ===** 

Copy over the Publishing Service Sitecore package *(4.3.0, 5.0.0, 6.0.0, 7.0.20)* and the specific Publishing Service module package *(for your Sitecore version)* to the **SitecorePackages folder**. 

See https://kb.sitecore.net/articles/761308 for the Sitecore Publishing Service compatibility table.

**UPDATE:** From SPS version 6.0.0 *(for 10.2)* on you need a valid Sitecore license when using the Publishing Service. **Copy over a valid Sitecore license to the SitecorePackage folder** and the script will take care of the correct install.

## Adjust necessary parameters

Open up the **parameters.ps1** file and adjust the necessary ***Webroot***, ***Postfix*** & ***SqlServer*** variable values if necessary!

# How to install?

## Installing the Publishing Service

Open up a Windows Powershell window in admin mode and run the following:

```powershell
.\InstallPublishingService.ps1 -Version "10.4.0" -Prefix "sc10_4"
```

This will install a new Sitecore Publishing Service instance. A new site will be created called: **sc10_4.publishingservice.dev.local**. It will be running on port 5000.

Once the service is installed you can verify that it is working by hitting the publishing api using:

    http://sc10_4.publishingservice.dev.local:5000/api/publishing/operations/status

A response of ***{"status":0}*** indicates the service is working as expected and ready for connections.

In case you want to do an **uninstall of the Publishing Service instance**, you can run the ***-Uninstall*** option.

```powershell
.\InstallPublishingService.ps1 -Uninstall -Version "10.4.0" -Prefix "sc10_4"
```

## Installing the Publishing Service Module on the Sitecore instance

Now that we have the Publishing Service installed, the Publishing Module now needs installed in the Sitecore instance. To help with that we've also automated this through the Sitecore Install Framework (SIF).

Open up a Powershell prompt in admin mode and run the following:

```Powershell
.\InstallPublishingModule.ps1 -Version "10.4.0" -Prefix "sc10_4"
```

To verify everything is working correctly, from the Sitecore launchpad on your CM instance, select the **'Publishing'** application. The dashboard will display an error if Sitecore is not able to connect to the publishing service. If no errors are displayed, publishing can be initiated from the dashboard, or via the other standard publishing methods within Sitecore.

# Supported Sitecore versions

The following Sitecore Experience Platform versions are supported with these scripts (see also https://kb.sitecore.net/articles/761308):

### Sitecore 10

- **Sitecore Experience Platform 10.4.0 (April 2024)** - _Uses SPS 7.0.20 & Module 10.4.0_
- **Sitecore Experience Platform 10.3.0 (December 2022)** - _Uses SPS 7.0.20 & Module 10.3.0_
- **Sitecore Experience Platform 10.2.0 (November 2021)** - _Uses SPS 6.0.0 & Module 10.2.0_
- **Sitecore Experience Platform 10.1.0 (February 2021)** - _Uses SPS 5.0.0 & Module 10.1.0_
- **Sitecore Experience Platform 10.0.1 (December 2020)** - _Uses SPS 4.3.0 & Module 10.0.0.0_
- **Sitecore Experience Platform 10.0.0 (August 2020)** - _Uses SPS 4.3.0 & Module 10.0.0.0_

### Sitecore 9.3

- **Sitecore Experience Platform 9.3 Initial Release (November 2019)** - _Uses SPS 4.3.0 & Module 9.3.0.0_

### Sitecore 9.2

- **Sitecore Experience Platform 9.2 Initial Release (July 2019)** - _Uses SPS 4.3.0 & Module 9.2.0.0_

### Sitecore 9.1

- **Sitecore Experience Platform 9.1.1 Initial Release (April 2019)** - _Uses SPS 4.3.0 & Module 9.1.1.0_
- **Sitecore Experience Platform 9.1.0 Initial Release (November 2018)** - _Uses SPS 4.3.0 & Module 9.1.0.0_

# Contributors

Robbert Hock - 15x Sitecore MVP (2010-2024)

- Twitter: [@kayeeNL](https://twitter.com/kayeenl)
- GitHub: https://github.com/KayeeNL

_Based upon idea's and partial code by Thomas Eldblom (https://github.com/Eldblom)_
