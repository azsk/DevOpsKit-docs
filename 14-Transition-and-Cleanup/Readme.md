## IMPORTANT: DevOps Kit (AzSK) is being sunset by end of FY21. More details [here](../ReleaseNotes/AzSKSunsetNotice.md)
----------------------------------------------

> The Secure DevOps Kit for Azure (AzSK) was created by the Core Services Engineering & Operations (CSEO) division at Microsoft, to help accelerate Microsoft IT's adoption of Azure. We have shared AzSK and its documentation with the community to provide guidance for rapidly scanning, deploying and operationalizing cloud resources, across the different stages of DevOps, while maintaining controls on security and governance.
<br>AzSK is not an official Microsoft product – rather an attempt to share Microsoft CSEO's best practices with the community..

# Transition and Cleanup

## Cleanup
 ### Contents
- [Remove AzSK deployed resources](Readme.md#remove-azsk-deployed-resources)
- [FAQ](Readme.md#faq)
-----------------------------------------------------------------
## Remove AzSK deployed resources
"Secure DevOps Kit for Azure (AzSK)" is on the path of sunset, and being transitioned to more robust & scalable solution called Azure Tenant Security scanner (AzTS). If transition from AzSK to AzTS is done for your organization and tenant, you can follow below mentioned steps to clean up AzSK deployed resources in your subscription.

>**Note** Before running command to clean-up AzSK deployed resources, please do have a look on the section below (post the steps to clean resources) which lists all the resources which will be deleted as part of clean-up and points to consider before deletion. 

### Steps to clean AzSK deployed resources:

**Step 1:** Import AzSK module:

``` PowerShell
  Import-Module AzSK 
```
**Step 2:** Run Remove-AzSKContinuousAssurance command with '-CleanUpAllAzSKResources' switch:

``` PowerShell
Remove-AzSKContinuousAssurance -SubscriptionId "<SubscriptionId>" -CleanUpAllAzSKResources
```
### What all resources will be deleted?

The above command will delete following resources under resource group 'AzSKRG' and resource group 'AzSKRG':

|Type|Name|Points to consider?|
|----|----|----|
|Microsoft.Storage/storageAccounts|azsk*|Avoid deleting, if: <br> a) You want to keep previous AzSK CA scan logs <br> b) You want to keep attestation of non-baseline controls <br> c) You are using AzSK Cred Hygiene feature|
|Microsoft.Automation/automationAccounts/runbooks|Continuous_Assurance_Runbook, Alert_Runbook, Continuous_Assurance_ScanOnTrigger_Runbook|NA|
|Microsoft.Automation/automationAccounts|AzSKContinuousAssurance|Avoid deleting, if You have deployed any custom runbook in AzSK Automation account. |
|Microsoft.Insights/activityLogAlerts|AzSK_*|Avoid deleting, if dependent on AzSK alerts for alerting & monitoring.|
|Microsoft.Insights/actionGroups|AzSKAlertActionGroup, AzSKCriticalAlertActionGroup, ResourceDeploymentActionGroup|Avoid deleting, if used same action groups for any non-AzSK deployed alerts.|

Apart from deleting above mentioned resources, command will also remove:
- Role assignments of current SPN (service principal) associated with AzSK Automation account.
  - 'Reader' role at subscrition scope and
  - 'Contributor' at 'AzSKRG' resource group scope
- Azure AD Application (AzSK_CA_SPN_*) and SPN associated with AzSK Automation account. 

>**Note 1:** To clean AAD application you must have "Owner" access to the AAD application and ability to remove AAD application in the tenant. 

>**Note 2:** During AzSK CA set up separate AAD application & SPN gets created. So, it is safe to delete AAD application & SPN associated with the automation account. But if you had manually added same SPN/AAD application to some other application or AzSK CAs then please avoid deleting AAD application.

### FAQ

#### Can I run the command in non interactive manner, so that I don't need to provide any further input/confirmation?
Yes, you can run the command in non interactive mode to perform the clean up without any prompt for confirmation/input. For this please include '-Force' switch while running the command as shown in example below.

``` PowerShell
Remove-AzSKContinuousAssurance -SubscriptionId "<SubscriptionId>" -CleanUpAllAzSKResources -Force
```
Please be careful while using '-Force' switch as this will delete all AzSK deployed resources (including AzSK CA SPN & AAD App) without any further consent from the user.


