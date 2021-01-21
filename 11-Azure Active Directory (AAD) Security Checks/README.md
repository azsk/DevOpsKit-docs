> The Secure DevOps Kit for Azure (AzSK) was created by the Core Services Engineering & Operations (CSEO) division at Microsoft, to help accelerate Microsoft IT's adoption of Azure. We have shared AzSK and its documentation with the community to provide guidance for rapidly scanning, deploying and operationalizing cloud resources, across the different stages of DevOps, while maintaining controls on security and governance.
<br>AzSK is not an official Microsoft product – rather an attempt to share Microsoft CSEO's best practices with the community..
# (Preview) Security Scan of Azure Active Directory (AAD) 

A new module called AzSK.AAD is available in preview to facilitate checking  security configuration and best practices for Azure Active Directory (AAD). It provides the ability to scan the entire tenant (a feature that AAD admins can use) or scan objects of various types (apps, groups, devices, etc.) owned by a specific user (a feature that an individual user in the tenant can use). 


## Installation

> **Pre-requisites**:
> - PowerShell 5.0 or higher. 
> - .Net Framework 4.7.2 or higher.

1. Verify that prerequisites are installed:  
    Ensure that you have PowerShell version 5.0 or higher by typing **$PSVersionTable** in the PowerShell ISE console window and looking at the PSVersion in the output as shown below.) 
 If the PSVersion is older than 5.0, update PowerShell from [here](https://www.microsoft.com/en-us/download/details.aspx?id=54616).  
   ![PowerShell Version](../Images/00_PS_Version.PNG)   

2. Install the AzSK.AAD PowerShell module:  
	  
```PowerShell
  Install-Module AzSK.AAD -Scope CurrentUser
```

Note: 

  - You may need to use `-AllowClobber` and/or `-Force` options with the `Install-Module` command above if you already have a prior version of the module installed on your machine.
  - The `AzSK.AAD` module depends on `AzureAD` and `Az.Accounts` modules. 
  - The Az.Accounts module requires .Net Framework 4.7.2. If your machine does not have .Net Framework 4.7.2, you may need to independently install it.


## Scan your AAD resources

Use the commands below based on if you wish to scan the entire tenant or as an end user. Even if you do not have admin permissions to the tenant, you can _still_ use the tenant version of the command. In such a case, the command will scan the controls that it can based on your permissions. 

When using the 'tenant' cmdlet, all tenant-level controls are always scanned. Apart from those, a desired number of objects of chosen types (or 'all' types) are also scanned. 

When using the 'user' cmdlet, tenant controls are not scanned and only objects of chosen (or all) types that are owned by the current user are scanned for security issues and best practices.

At present (for this preview release), 'MaxObj' defaults to 3 if not specified. You may be choose a higher value if you are scanning the entire tenant. Also, the default value of 'ObjectType' is 'All'.

### Scanning tenant-wide:
```PowerShell
Get-AzSKAADSecurityStatusTenant

Get-AzSKAADSecurityStatusTenant -TenantId <tid>

Get-AzSKAADSecurityStatusTenant -TenantId <tid> -ObjectType [User|Application|ServicePrincipal|Group|Device|All] -MaxObj 2 
```

### Scanning at a 'user' scope:
```PowerShell
Get-AzSKAADSecurityStatusUser

Get-AzSKAADSecurityStatusUser -TenantId <tid>

Get-AzSKSecurityStatusUser -TenantId <tid> -ObjectType [User|Application|ServicePrincipal|Group|Device|All] -MaxObj 2 
```

Note: You can get your AAD tenantId by running the following in PS after installing the `AzSK.AAD` module: <br>`$tenantId = (Get-AzureADTenantDetail).ObjectId`

Similar to the Azure AzSK scan commands, outcome of the analysis is printed on the console during SVT execution and a CSV and LOG files are 
also generated for subsequent use.

The CSV file and LOG file are generated under a Org-specific sub-folder in the folder  
*%LOCALAPPDATA%\Microsoft\AzSK.AADLogs\Org_[yourOrganizationName]*  
E.g.  
C:\Users\UserName\AppData\Local\Microsoft\AzSK.AADLogs\Org_[yourOrganizationName]\20181218_103136_GADS

Refer [doc](../02-Secure-Development#understand-the-scan-reports) for understanding the scan report and [link](./ControlCoverage) for current control coverage for AAD. (#TODO)
