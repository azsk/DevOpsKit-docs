# Secure Azure DevOps (VSTS) -Preview

AzSK for Azure DevOps performs security scanning for core areas of Azure DevOps/VSTS like Organization, Projects, Users, Connections, Pipelines (Build & Release). 


## Installation Guide

>**Pre-requisites**:
> - PowerShell 5.0 or higher. 

1. First verify that prerequisites are already installed:  
    Ensure that you have PowerShell version 5.0 or higher by typing **$PSVersionTable** in the PowerShell ISE console window and looking at the PSVersion in the output as shown below.) 
 If the PSVersion is older than 5.0, update PowerShell from [here](https://www.microsoft.com/en-us/download/details.aspx?id=54616).  
   ![PowerShell Version](../Images/00_PS_Version.PNG)   

2. Install the Secure DevOps Kit for Azure DevOps (AzSK.AzureDevOps) PS module:  
	  
```PowerShell
  Install-Module AzSK.AzureDevOps -Scope CurrentUser
```

Note: 

You may need to use `-AllowClobber` and `-Force` options with the Install-Module command 
above if you have a different version of same modules installed on your machine.


## Scan your Azure DevOps resources

Run the command below after replacing `<OrganizationName>` with your Azure DevOps Org Name 
and `<PRJ1, PRJ2, ..`> with a comma-separated list of project names where your Azure DevOps resources are hosted.

```PowerShell
Get-AzSKAzureDevOpsSecurityStatus -OrganizationName "<OrganizationName>" -ProjectNames "<PRJ1, PRJ2,...etc.>"
```

Command also supports other parameters of filtering resources.
For instance, you can also make use of the 'BuildNames','ReleaseNames' to filter specific resource

```PowerShell
Get-AzSKAzureDevOpsSecurityStatus -OrganizationName "<OrganizationName>" -ProjectNames "<PRJ1, PRJ2,...etc.>" -BuildNames "<B1, B2,...etc.>" -ReleaseNames "<R1, R2,...etc.>"
```

Similar to Azure AzSK SVT scan, outcome of the analysis is printed on the console during SVT execution and a CSV and LOG files are 
also generated for subsequent use.

The CSV file and LOG file are generated under a Org-specific sub-folder in the folder  
*%LOCALAPPDATA%\Microsoft\AzSK.AzureDevOpsLogs\Org_[yourOrganizationName]*  
E.g.  
C:\Users\UserName\AppData\Local\Microsoft\Azure.DevOpsLogs\Org_[yourOrganizationName]\20181218_103136_GADS

Refer [doc](../02-Secure-Development#understand-the-scan-reports) for understanding the scan report and [link](./ControlCoverage) for current control coverage for Azure DevOps
