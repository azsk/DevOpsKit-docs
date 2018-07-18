# AzSK Custom Org Policy Health Check
 
### [Overview](OrgPolicyHealthCheck.md#overview-1)

### [Run Org Policy Health Check](OrgPolicyHealthCheck.md#run-org-policy-health-check-1)

### [Update Org Policy with help of fix script ](OrgPolicyHealthCheck.md#run-org-policy-fix-script)

### [Frequently Asked Questions] ()

## Overview

#### When and why should I check org policy health 

AzSK keeps on adding and enhancing features with different capabilities to monitor Security compliance for Org subscriptions. During these enhancement in new releases, it may include latest features and also some breaking changes. To provide smoother upgrade and avoid policy break, AzSK provides feature for Org policy to run AzSK components with specific version using configuration(mentioned in AzSK.Pre.json). Currently, we have come up with health and fix script which will validate all mandatory resources and latest configurations are in place. In upcoming release these scripts will be part of AzSK commands. 
It is recommendated to run health scan before and after updating AzSK version for Org. 
Below steps will guide you through steps


## Run Org Policy Health Check

Steps to execute Org policy health scan script

1.	Download OrgPolicyHealthCheck script from [here](https://raw.githubusercontent.com/azsk/DevOpsKit-docs/master/07-Customizing-AzSK-for-your-Org/Scripts/OrgPolicyHealthCheck.txt) and save it with extension ".ps1". 

**Note:** After saving file you may have to unblock the file.(Right click on file --> Click Properties --> Select "Unblock" checkbox --> Click "Apply" and "Ok"



2.	Execute below command in PowerShell

    ```PowerShell
    & "<FolderPath>\OrgPolicyHealthCheck.ps1" -SubscriptionId <SubscriptionId> -PolicyResourceGroupName <PolicyResourceGroupName>
    ```

Script will validate components of Org Policy and reports any missing configurations. If all checks are passing then there is no need to perform any action.


## Run Org Policy Fix Script

Fix script will try to remediate or provide instructions for missing configurations present Org policy. You can follow below stesp to execute fix script


1.	Download Fix script from [here](https://raw.githubusercontent.com/azsk/DevOpsKit-docs/master/07-Customizing-AzSK-for-your-Org/Scripts/OrgPolicyFixScript.txt) and save it with extension ".ps1"




2.	Execute below command in PowerShell

    ```PowerShell
    & "<FolderPath>\OrgPolicyFixScript.ps1" -SubscriptionId <SubscriptionId> -PolicyResourceGroupName <PolicyResourceGroupName>
    ```

After execution of fix script, you may need to validate policy update is successful using steps given at the end script execution. If any of validate steps failing, you can restore policy from backup created during execution of fix script.

```PowerShell
& "<FolderPath>\OrgPolicyFixScript.ps1" -SubscriptionId <SubscriptionId> -PolicyResourceGroupName <PolicyResourceGroupName> -RestoreFromBackup
```


## Frequently Asked Questions

#### I am getting exception "DevOps Kit was configured to run with '***' policy for this subscription. However, the current command is using 'org-neutral' (generic) policy.Please contact your organization policy owner (***@microsoft.com) for correcting the policy setup."

When your subscription is running under Org policy, AzSK marks subscription for that Org. If user is running scan commands on that subscription using Org-neutral policy, it will block those commands as that scan/updates can give invalid results against Org policy. You may face this issue in different environments. Below steps will help you to fix issue

**Local Machine:**

- Run  "**IWR**" installation command shared by Policy Owner. This will ensure latest version installed with Org policy settings

- Run "Clear-AzSKSessionState" followed by any scan command and validate its running with Org policy. It gets dispayed at the start of command execution "Running AzSK cmdlet using  ***** policy"

**Continueous Assurance:**

- Run "Update-AzSKContinuousAssurance" command with Org policy. This will ensure that continueous assurance setup is configured with Org policy settings.

- After above step, you can trigger runbook and ensure that after job completion, scan exported in storage account are with Org policy. You can download logs and validate it in file under path <YYYYMMDD_HHMMSS_GRS>/ETC/PowerShellOutput.LOG. 
Check for message during start of command "Running AzSK cmdlet using  ***** policy"


**CICD:**
- You need to configure policy url in pipeline using step **5** defined [here](https://github.com/azsk/DevOpsKit-docs/tree/master/03-Security-In-CICD#adding-svts-in-the-release-pipeline)

- To validate if pipeline AzSK task is running with Org policy. You can download release logs from pipeline. Expand "AzSK_Logs.zip" -->  Open file under path "<YYYYMMDD_HHMMSS_GRS>/ETC/PowerShellOutput.LOG" --> Check for message at the start of command execution "Running AzSK cmdlet using  ***** policy"


If you want to run commands with Org-neutral policy only, you can delete tag(AzSKOrgName_{OrgName}) present on AzSKRG and run the commands.

If you are maintaining multiple Org policies and you want to switch scan from one policy to other, you can run  Set/Update commands with '-Force' flag using policy you wanted to switch. 


