# AzSK Custom Org Policy Health Check
 
### [Overview](OrgPolicyHealthCheck.md#overview-1)

### [Run Org Policy Health Check](OrgPolicyHealthCheck.md#run-org-policy-health-check-1)

### [Update Org Policy with help of fix script ](OrgPolicyHealthCheck.md#run-org-policy-fix-script)



## Overview

#### When and why should I check org policy health 

AzSK keeps on adding and enhancing features with different capabilities to monitor Security compliance for Org subscriptions. During these enhancement in new releases, it may include latest features and also some breaking changes. To provide smoother upgrade and avoid policy break, AzSK provides feature for Org policy to run AzSK components with specific version using configuration(mentioned in AzSK.Pre.json). Currently, we have come up with health and fix script which will validate all mandatory resources and latest configurations are in place. In upcoming release these scripts will be part of AzSK commands. 
It is recommendated to run health scan before and after updating AzSK version for Org. 
Below steps will guide you through steps


## Run Org Policy Health Check

Steps to execute Org policy health scan script

1.	Download OrgPolicyHealthCheck script from [here] (https://raw.githubusercontent.com/azsk/DevOpsKit-docs/master/07-Customizing-AzSK-for-your-Org/Scripts/OrgPolicyFixScript.txt) and save it with extension ".ps1" 



2.	Execute below command in PowerShell

    ```PowerShell
    & "<FolderPath>\OrgPolicyHealthCheck.ps1" -SubscriptionId <SubscriptionId> -PolicyResourceGroupName <PolicyResourceGroupName>
    ```

Script will validate components of Org Policy and reports any missing configurations. If all checks are passing then there is no need to perform any action.


## Run Org Policy Fix Script

Fix script will try to remediate or provide instructions for missing configurations present Org policy. You can follow below stesp to execute fix script


1.	Download Fix script from [here](https://raw.githubusercontent.com/azsk/DevOpsKit-docs/master/ContosoDocUpdate/07-Customizing-AzSK-for-your-Org/Scripts/OrgPolicyFixScript.txt) and save it with extension ".ps1"




2.	Execute below command in PowerShell

    ```PowerShell
    & "<FolderPath>\OrgPolicyFixScript.ps1" -SubscriptionId <SubscriptionId> -PolicyResourceGroupName <PolicyResourceGroupName>
    ```

After execution of fix script, you may need to validate policy update is successful using steps given at the end script execution. If any of validate steps failing, you can restore policy from backup created during execution of fix script.

```PowerShell
& "<FolderPath>\OrgPolicyFixScript.ps1" -SubscriptionId <SubscriptionId> -PolicyResourceGroupName <PolicyResourceGroupName> -RestoreFromBackup
```


