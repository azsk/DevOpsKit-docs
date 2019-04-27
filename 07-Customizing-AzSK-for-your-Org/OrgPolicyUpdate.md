
> <b>NOTE:</b>
> This article has been updated to use the new Azure PowerShell Az module. To learn more about the new Az module and AzureRM compatibility, see [Introducing the new Azure PowerShell Az module](https://docs.microsoft.com/en-us/powershell/azure/new-azureps-module-az).

# Org Policy Updates

This page will notify updates for Org Policy with different AzSK versions. You need to follow specific instruction/notes before updating Org policy with respective AzSK version. For all updates related to AzSK version, you can refer to [release page](https://azsk.azurewebsites.net/ReleaseNotes/RN180927.html)

To update Org policy with specific AzSK version, you need to run update Org policy command after installing AzSK module (in new PowerShell session). This will update AzSK.Pre.json present on Org policy with respective version. After policy updade, CA will auto-upgrade to latest Org version. If application teams are using older version(or any other version than mentioned in Org Policy), will start getting update warning.    

```PowerShell
# For Basic Setup
Update-AzSKOrganizationPolicy -SubscriptionId <SubscriptionId> `
   -OrgName "Contoso" `
   -DepartmentName "IT" `
   -PolicyFolderPath "D:\ContosoPolicies" -OverrideBaseConfig OrgAzSKVersion

#For custom Resource Group Setup
Update-AzSKOrganizationPolicy -SubscriptionId <SubscriptionId> `
   -OrgName "Contoso-IT" `           
   -ResourceGroupName "Contoso-IT-RG" `
   -StorageAccountName "contosoitsa" `
   -PolicyFolderPath "D:\ContosoPolicies" -OverrideBaseConfig OrgAzSKVersion
```

# AzSK v.3.12.0

*	The big change in this release is the migration of the DevOps Kit from AzureRM to the new Az-* PowerShell libraries
> **Note:** If you are upgrading from version 3.10.0 or below, you need to follow the below steps
> 1. Org-policy owner should download the latest AzSK module using the command: *"Install-Module AzSK -Scope CurrentUser -AllowClobber -Force
"*.
> 2. Import the latest AzSK module in a fresh PowerShell session and update your org-policy using the command: *"Update-AzSKOrganizationPolicy -SubscriptionId `<SubId>` -OrgName `<OrgName>` -DepartmentName `<DepartmentName>` -PolicyFolderPath `<PolicyFolderPath>` -OverrideBaseConfig All"*
> 3. Run the iwr and update the CA by running the *"Update-AzSKContinuousAssurance"* command with the *"-FixModules"* switch.

* Update all the AzureRM and Azure commands in your SVT extensions to its equivalent in the Az-* module.

# AzSK v.3.11.0

*	There is big change from release(3.11.0) related to migration of the DevOps Kit from AzureRM to the new Az-* PowerShell libraries
> **Note:** If you are upgrading from version 3.10.0 or below, you need to follow the below steps
> 1. Org-policy owner should download the latest AzSK module using the command: *"Install-Module AzSK -Scope CurrentUser -AllowClobber -Force
"*.
> 2. Import the latest AzSK module in a fresh PowerShell session and update your org-policy using the command: *"Update-AzSKOrganizationPolicy -SubscriptionId `<SubId>` -OrgName `<OrgName>` -DepartmentName `<DepartmentName>` -PolicyFolderPath `<PolicyFolderPath>` -OverrideBaseConfig All"*
> 3. Run the iwr and update the CA by running the *"Update-AzSKContinuousAssurance"* command with the *"-FixModules"* switch.

* Update all the AzureRM and Azure commands in your SVT extensions to its equivalent in the Az-* module.

# AzSK v.3.9.0

*	The ARM Checker task in AzSK CICD Extension now respects org policy ' this will let org policy owners customize behavior of the task. (Note that this was possible for the SVT task earlier'only the ARM Checker task was missing the capability.)
*	Ability to run CA in sovereign clouds + ability to apply custom org policy for SDL, CICD and CA for such subscriptions. (Please review GitHub docs for the steps needed.)

# AzSK v.3.8.0

*	Ability to run manual and CICD scans on sovereign clouds. Please review GitHub docs for the steps needed.
*	For central mode CA scanning, if central subscription is used for logging, then CA will not write to target subscription storage account any more. (Earlier, it used still use the target subscription storage account for checkpoints and other metadata.) For new setups or new target subscriptions added to the configuration, DevOps Kit will not create resources (or AzSKRG) in the target subscription.

# AzSK v.3.7.0

> **Note:** If you are upgrading from version 3.5.0 or below. you need to follow below steps
> 1. Update runbook files with latest compatible version
*"Update-AzSKOrganizationPolicy -SubscriptionId `<SubId>` -OrgName `<OrgName>` -DepartmentName `<DeptName>` -OverrideBaseConfig CARunbooks"* If you have customized these files for your Org(like adding -UseBaselineControls inside RunbookScanAgent etc.), You will need to re-do changes after running update command.
> 2. If Org policy is customized with SecurityCenter configurations. You have to update policy with latest (SecurityCenter.json) schema from 3.7.0.

No specific updates for Org policy features

# AzSK v.3.6.1

> **Note:** If you are upgrading from version 3.5.0 or below. you need to follow below steps
> 1. Update runbook files with latest compatible version
*"Update-AzSKOrganizationPolicy -SubscriptionId `<SubId>` -OrgName `<OrgName>` -DepartmentName `<DeptName>` -OverrideBaseConfig CARunbooks"* If you have customized these files for your Org(like adding -UseBaselineControls inside RunbookScanAgent etc.), You will need to re-do changes after running update command.
> 2. If Org policy is customized with SecurityCenter configurations. You have to update policy with latest (SecurityCenter.json) schema from 3.6.1.
  

* Fixed issue related to ASC API in GSS command. Any subscription not having security contacts details setup, ASC API was throwing exception and causing issue (InvalidOperation: The remote server returned an error: (404) Not Found.)

* Fixed issue for express route connected VM. (The property 'Tags' cannot be found on this object. Verify that the property exists.)


# AzSK v.3.6.0
>**Note:** AzSK 3.6.0 has upgraded with breaking changes for RunbookCoreSetup present on Custom Org Policy.  You will need to take latest runbook files with update Org policy command (*Update-AzSKOrganizationPolicy -SubscriptionId `<SubId>` -OrgName `<OrgName>` -DepartmentName `<DeptName>` -OverrideBaseConfig CARunbooks*). If you have customized these files for your Org(like adding -UseBaselineControls inside RunbookScanAgent etc.), You will need to re-do changes after running update command.

* Ability to let customers control the default location where AzSK root resources will get created for subscriptions that are onboarded (for manual, CA or CICD scanning).
* Fixed bug for Manual control where its settings not getting respected with Org policy setup.


# AzSK v.3.5.0

>**Note:** AzSK 3.5.0 has upgraded its dependancy on AzureRM and now requires AzureRM version 6.x. It has breaking changes for RunbookCoreSetup and RunbookScanAgent present on Custom Org Policy. If you are upgrading Org Policy with AzSK version 3.5.0 using configurations(AzSK.Pre.Json), you will need to take latest runbook files with update Org policy command (*Update-AzSKOrganizationPolicy -SubscriptionId `<SubId>` -OrgName `<OrgName>` -DepartmentName `<DeptName>` -OverrideBaseConfig CARunbooks*). If you have customized these files for your Org(like adding -UseBaselineControls inside RunbookScanAgent etc.), You will need to re-do changes after running update command.

* Policy owner can now use a local folder to ‘deploy’ policy to significantly improve debugging/troubleshooting experience. (Policy changes can be pre-tested locally and there’s no need to maintain a separate dev-test policy server endpoint.)
* Support for handling expiry of SAS token in the policy URL in an automated manner in local setup and CA. (Only CICD extension scenarios will need explicit updates. We will display warnings when expiry is coming up in the next 30 days.) 
* Support for schema validation of org policy config JSON via the Get-AzSKOrganizationPolicyStatus command. This will reduce chances of errors due to oversight/copy-paste errors, etc.
* Teams that extend the AzSK module can now also add custom listeners to receive scan events.

# AzSK v.3.4.x

*	A new cmdlet (Get-AzSKOrganizationPolicyStatus) to check health/correctness of org policy configuration for a given setup and to also help remediate issues that were found.
* Provided option to download existing policies from the policy server.
*	If an org is using a version of AzSK that is more than 2 releases old (current-2), then we will show a ‘deprecated’ warning to ensure that customers using org policy are staying up to date with the latest security controls.
*	If a subscription is configured with a specific org policy then the scan commands run using some other (or OSS) policy will be disallowed with appropriate warnings.
*	Org policy customers can now generate compliance dashboard based on a Power BI content pack and a CSV mapping subscription to org details.

