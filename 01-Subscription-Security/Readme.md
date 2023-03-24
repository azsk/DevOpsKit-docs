## IMPORTANT: DevOps Kit (AzSK) is being sunset by end of FY21. More details [here](../ReleaseNotes/AzSKSunsetNotice.md)
----------------------------------------------

> The Secure DevOps Kit for Azure (AzSK) was created by the Core Services Engineering & Operations (CSEO) division at Microsoft, to help accelerate Microsoft IT's adoption of Azure. We have shared AzSK and its documentation with the community to provide guidance for rapidly scanning, deploying and operationalizing cloud resources, across the different stages of DevOps, while maintaining controls on security and governance.
<br>AzSK is not an official Microsoft product – rather an attempt to share Microsoft CSEO's best practices with the community..
# AzSK Subscription Security Package

![Subscription_Security](../Images/Subscription_Security.png)

### Contents:

### [AzSK: Subscription Health Scan](Readme.md#azsk-subscription-health-scan-1)
- [Overview](Readme.md#overview)
- [Scan the security health of your subscription](Readme.md#scan-the-security-health-of-your-subscription)
- [Subscription Health Scan - What is covered?](Readme.md#subscription-health-scan---what-is-covered)
- [Subscription Health Scan - How to fix findings?](Readme.md#subscription-health-scan---how-to-fix-findings)
- [Target specific controls during a subscription health scan](Readme.md#target-specific-controls-during-a-subscription-health-scan)
- [FAQs](Readme.md#faqs)

### [AzSK: Subscription Security Provisioning](Readme.md#azsk-subscription-security-provisioning-1)
- [Overview](Readme.md#overview-1)
- [Provision security for your subscription](Readme.md#provision-security-for-your-subscription)
- [Remove previously provisioned security settings from your subscription](Readme.md#remove-azsk-subscription-security-provisioning-from-your-subscription)
- [FAQs](Readme.md#faqs-1)

### [AzSK: Subscription Access Control Provisioning](Readme.md#azsk-subscription-access-control-provisioning)
- [Overview](Readme.md#overview-2)
- [Setup pre-approved mandatory accounts](Readme.md#setup-pre-approved-mandatory-accounts)
- [Remove pre-approved mandatory accounts](Readme.md#remove-previously-provisioned-accounts)

### [AzSK: Subscription Activity Alerts](Readme.md#azsk-subscription-activity-alerts-1)
- [Overview](Readme.md#overview-3)
- [Configure alerts in your subscription](Readme.md#configure-alerts-for-your-subscription)
- [Remove previously configured alerts from your subscription](Readme.md#remove-previously-configured-alerts-from-your-subscription)
- [Configure alerts scoped to specific resource groups](Readme.md#configure-alerts-scoped-to-specific-resource-groups)
- [FAQs](Readme.md#faqs-2)

### [AzSK: Azure Security Center (ASC) configuration](Readme.md#azsk-azure-security-center-asc-configuration-1)
	
- [Setup Azure Security Center (ASC) on your subscription](Readme.md#setup-azure-security-center-asc-on-your-subscription)


### [AzSK: Subscription Security - ARM Policy](Readme.md#azsk-subscription-security---arm-policy-1)

- [Overview](Readme.md#overview-4)
- [Setup ARM policies for your subscription](Readme.md#setup-arm-policies-on-your-subscription)
- [Remove ARM policies from your subscription](Readme.md#remove-arm-policies-from-your-subscription)
- [FAQs](Readme.md#faqs-3)

### [AzSK: Update subscription security baseline configuration](Readme.md#azsk-update-subscription-security-baseline-configuration-1)
- [Update subscription security baseline configuration](Readme.md#update-subscription-security-baseline-configuration)

### [AzSK support for Azure Government and Azure China](Readme.md#azsk-support-for-azure-government-and-azure-china-1)

- [Spotcheck/Manual Scans](Readme.md#spotcheckmanual-scans)
- [CICD](Readme.md#cicd)
- [CA](Readme.md#ca)
- [Customizing AzSK for your organization](Readme.md#customizing-azsk-for-your-organization)

### [AzSK: Privileged Identity Management (PIM) helper cmdlets](Readme.md#azsk-privileged-identity-management-pim-helper-cmdlets-1)
- [Get-AzSKPIMConfiguration at Subscription scope](Readme.md#use-get-azskpimconfiguration-alias-getpim-for-querying-various-pim-settingsstatus-at-subscription-scope)
- [Set-AzSKPIMConfiguration at Subscription scope](Readme.md#use-set-azskpimconfiguration-alias-setpim-for-configuringchanging-pim-settings-at-subscription-scope)
- [Get-AzSKPIMConfiguration at Management Group scope](Readme.md#use-get-azskpimconfiguration-alias-getpim-for-querying-various-pim-settingsstatus-at-management-group-level)
- [Set-AzSKPIMConfiguration at Management Group scope](Readme.md#use-set-azskpimconfiguration-alias-setpim-for-configuringchanging-pim-settings-at-management-group-level)

----------------------------------------------------------
## AzSK: Subscription Health Scan

### Overview
 
The subscription health check script runs a set of automated scans to examine a subscription and flags 
off conditions that are indications that your subscription may be at a higher risk due to various security 
issues, misconfigurations or obsolete artifacts/settings. 

The following aspects of security are checked:
1. 	 Access control configuration - identity and access management related issues in the subscription
2. 	 Alert configuration - configuration of activity alerts for sensitive actions for the subscription and various cloud resources
3. 	 Azure Security Center configuration - configuration of ASC (security point of contact, various ASC policy settings, etc.)
4. 	 ARM Policy and Resource Locks configuration - presence of desired set of ARM policy rules and resource locks. 

[Back to top…](Readme.md#contents)
### Scan the security health of your subscription 

The subscription health check script can be run using the command below after replacing `<SubscriptionId`> 
 with your subscriptionId
```PowerShell
Get-AzSKSubscriptionSecurityStatus -SubscriptionId <SubscriptionId>
```
The parameters used are:
- SubscriptionId – Subscription ID is the identifier of your Azure subscription 

You need to have at least **Reader** role at the subscription scope to run this command. 
If you also have access to read the Graph in your tenant, the RBAC information and checking will be richer.


> **Note**: The check for presence of Management Certificates cannot be performed just with "Reader" privilege. 
> This check only works if you are running as a Co-Administrator. This is in itself a bad practice. Hence, in most
> situations, the user running the subscription health check will likely not be a co-admin and, because we will not be
> able to actually perform the check, the outcome of this control will be listed as 'Manual'.
>
> In general, in any scenario where the runtime account used to run an AzSK cmdlet does not have enough access to evaluate
> a control, the evaluation status is marked as "Manual" in the report. Basically, for such controls, someone with the
> correct access needs to manually verify the control and record the information through the "Control Attestation" feature.
> A common situation for this is in respect to "Graph Access" which is not available by default to SPNs.


[Back to top…](Readme.md#contents)
### Subscription Health Scan - What is covered?  
 

The various security checks performed by the health check script are listed in the table [here](../02-Secure-Development/ControlCoverage/Feature/SubscriptionCore.md). 

The next section explains how to interpret output in the LOG file and how to address control failures.

[Back to top…](Readme.md#contents)
### Subscription Health Scan - How to fix findings?

All cmdlets in AzSK generate outputs which are organized as under: 
- summary information of the control evaluation (pass/fail) status in a CSV file, 
- detailed control evaluation log in a LOG file and
- a few other ancillary files for additional support

The overall layout and files in the output folder are also described in the README.txt file present in the root output folder.

To address findings, you should do the following:
1. See the summary of control evaluation first in the CSV file. (Open the CSV in XLS. Use "Format as Table", "Hide Columns", "Filter", etc.)
2. Review controls that are marked as "Failed", "Verify" or "Manual"
3. The 'Recommendation' column for each control in the XLS will tell you the command/steps needed to resolve the issue.
4. The LOG file contains details about *why* AzSK has flagged each control as "Failed" or "Verify".
5. Use the following approach based on control status:
    - For "Failed" controls, look at the LOG file and use the Recommendation field to address the issue. (e.g., If the 'external accounts (LiveId)' control
has failed, the list of such external accounts found is displayed in the LOG file. Remove these using
the cmdlet mentioned in the Recommendation field.)
    - For "Verify" controls, look at the LOG file to get the supporting information that should help you to decide whether to consider
the control as "Passed" or not. (e.g., For an RBAC control, you should look at the actual list of users and confirm that it is appropriate. 
Then use the "Control Attestation" feature to record your attestation.)
    - For "Manual" controls, follow the steps using the Recommendation field in the CSV. (There will not be anything in the LOG file for "Manual" controls.) 

For provisioning related failures (e.g., you don't have central accounts correctly configured), you should use the
corresponding provisioning cmdlet as described in respective sections below. (E.g., `Set-AzSKSubscriptionRBAC` for
provisioning mandatory accounts).


[Back to top…](Readme.md#contents)
### Target specific controls during a subscription health scan

The subscription health check supports multiple parameters as specified below:
- SubscriptionId – Subscription ID is the identifier of your Azure subscription 
- FilterTags  - Comma-separated tags to filter the security controls. E.g., RBAC, SOX, AuthN, etc.
- ExcludeTags - Comma-separated tags to exclude the security controls. E.g., RBAC, SOX, AuthN, etc.
- ControlIds  - Comma-separated AzSK control id's to filter security controls. E.g., Azure_Subscription_AuthZ_Limit_Admin_Owner_Count, Azure_Subscription_Config_Azure_Security_Center, etc.
```PowerShell
Get-AzSKSubscriptionSecurityStatus -SubscriptionId <SubscriptionId> [-ControlIds <ControlIds>] [-FilterTags <FilterTags>] [-ExcludeTags <ExcludeTags>]
```
These different parameters would enable you to execute different 'flavors' of subscription health scan. 
For example, they will let you scan only SOX relevant controls or AuthZ related controls or 
exclude best practices or even execute one specific control. 
Here are some examples:

1. Execute only SOX related controls
```PowerShell
Get-AzSKSubscriptionSecurityStatus -SubscriptionId <SubscriptionId> -FilterTags "SOX"
``` 
2. Exclude *Best-Practice* while doing *AuthZ* related subscription health scan
```PowerShell
Get-AzSKSubscriptionSecurityStatus -SubscriptionId <SubscriptionId> -FilterTags "AuthZ" -ExcludeTags "Best Practice"
``` 

3. Execute ASC related security control of subscription health scan 
```PowerShell
Get-AzSKSubscriptionSecurityStatus -SubscriptionId <SubscriptionId> -ControlIds Azure_Subscription_Config_Azure_Security_Center
``` 

|List of Tags|Purpose|
|-------|-------|
|Access|Access activities|
|ACLS|Access control activities|
|AppService|Azure App Services|
|Audit|Audit activities|
|AuthN|Authentication activities|
|AuthZ|Authorization activities|
|Automated|Controls which are automated by AzSK|
|Availability|Availability|
|BCDR|Backup and disaster recovery|
|Best Practice|Controls which should be implemented to ensure your application security|
|Classic|Classic services|
|Config|Configurations|
|Deploy|Deployment activities|
|Diagnostics|Diagnostics activities|
|DP|Data protection|
|FunctionApp|Azure FunctionApp|
|Information|Controls which are default behaviour by Azure but additional check for notification|
|KeyRotation|Key rotation|
|KeySecretPermissions|Controls which can be attested only when the user has access permissions on the concerned keys and secrets|
|Linux|Linux virtual machine|
|Manual|Controls which are not automated and user need to verify it manually|
|NetSec|Network security|
|OwnerAccess|Controls which require owner/co-admin permission to get required output|
|RBAC|Role based access controls|
|SDL|Software development lifecycle |
|SecIntell|Security intellisense |
|SI|System integrity |
|SOX|Controls which are enforced by SOX|
|SqlDatabase|Azure SQL Database|
|TCP|Controls which must be implemented to ensure your application security|
|Windows|Windows virtual machine|


[Back to top…](Readme.md#contents)

-----------------------------------------------------------------------  
## AzSK: Subscription Security Provisioning

### Overview
The Subscription Security Provisioning script is a master script that, in turn, invokes multiple other 
scripts to setup up all of the following in the target subscription:
- A set of mandatory accounts that are required for central scanning/audit/compliance functions.
- A group of subscription and resource activity alerts for activities with significant security implications.
- A baseline set of ARM policies corresponding to certain actions that are considered insecure.
- Default enterprise policy settings for Azure Security Center (ASC).
- Security contact information in ASC.

[Back to top…](Readme.md#contents)
### Provision security for your subscription
The Subscription Security setup script can be run by providing the subscriptionID, security contact 
E-mails (comma separated values) and a contact phone number.
```PowerShell
Set-AzSKSubscriptionSecurity -SubscriptionId <subscriptionId> -SecurityContactEmails <SecurityContactEmails> -SecurityPhoneNumber <SecurityPoCPhoneNumber>
```
|Config Param Name	|Purpose	|
| --------------- | -------- |
|SecurityContactEmails 	|Comma-separated list of emails (e.g., 'abc@microsoft.com, def@microsoft.com')	for contact preference|
|SecurityPhoneNumber 	|Single phone number (e.g., '425-882-8080' or '+91-98765-43210' or '+1-425-882-8080')	for contact preference|

> **Note**: 
>  - This command *overwrites* the contact emails and phone number previously configured in Azure Security Center.
>  - This command also helps you to recover if any of the base resources are accidentally deleted, like AzSK resource group, storage account, attestation container, continuous assurance log container etc.

While running command, you may see message that configuration in your subscription is already up to date. This indicates your subscription already have latest security configurations. If you still see any failures for controls in `Get-AzSKSubscriptionSecurityStatus` command, you can pass `-Force` parameter to the provisioning script and reconfigure AzSK artifacts (
Alerts, RBAC, ARM policies, etc.) in the subscription. 


[Back to top…](Readme.md#contents)
### Remove AzSK subscription security provisioning from your subscription
The subscription setup created by the provisioning command can be removed by running:
```PowerShell
Remove-AzSKSubscriptionSecurity -SubscriptionId <subscriptionId> -Tags <TagNames>
```
This command cleans up various security provisioning that was previously done using the Set-AzSKSubscriptionSecurity 
command such as alerts, access control (RBAC) settings, ARM policies, etc.

This command does not affect the Azure Security Center related settings (whether they were previously configured
by AzSK or directly by the user).

To remove access control related configuration, it is mandatory to use the `-Tags` parameter. If this
parameter is not specified, previously setup RBAC will not be deprovisioned will be done. 
Typically you would want to specify the tags which were used when setting up RBAC. If you did not specify 
any tags during provisioning then, by default, only the accounts marked as 'Mandatory' would get provisioned. Typically, you should not have
to remove those accounts but if you must you can do so using `-Tags "Mandatory"` in the command.


[Back to top…](Readme.md#contents)
### FAQs

#### Is it possible to setup an individual feature (e.g., just alerts or just ARM Policy)?
Yes, each of the components of the overall subscription provisioning setup can be individually 
run/controlled. 
You can run cmdlets in isolation for the following:
1. RBAC roles/permissions - Set-AzSKSubscriptionRBAC
2. Alerts - Set-AzSKAlerts
3. ARM Policy - Set-AzSKARMPolicies
4. Azure Security Center configuration - Set-AzSKAzureSecurityCenterPolicies

#### Set-AzSKSubscriptionSecurity  or Set-AzSKAzureSecurityCenterPolicies returns - InvalidOperation: The remote server returned an error: (500) Internal Server Error

Currently we are seeing an issue with an Azure Security Center API which is causing the error you are seeing. You can follow the steps below until the issue is resolved:

1. Login to your subscription.
2. Go to 'Security Center' > 'Security policy'.
3. Select your subscription and click on 'Edit settings'.
4. Select 'Email notifications'.
5. Update 'Security contact emails' and 'Phone number'.
6. Click on 'Save'.

You can try running the recommendation command again after doing the above change.

[Back to top…](Readme.md#contents)
	
------------------------------------------------------------
## AzSK: Subscription Access Control Provisioning

### Overview
The subscription access control provisioning script will setup certain permissions in the subscription 
that enable central security and compliance teams to perform automated scans and manual review/assessment 
activities in the subscription. This basically involves addition of some common accounts (service principals 
or security groups) to one or more roles in the subscription. The script also supports provisioning of 
some optional accounts based on the scenarios that the subscription is used for. (The specific accounts
and the roles they are deployed into are configurable by the central security team in your organization.) 

[Back to top…](Readme.md#contents)
### Setup pre-approved mandatory accounts
The subscription access control provisioning script can be run using the following command (by specifying 
the subscriptionId for the subscription in which you want to provision the various roles):
```PowerShell
Set-AzSKSubscriptionRBAC -SubscriptionId <subscriptionId> 
```
The subscription access control provisioning script ensures that certain central accounts and roles are 
setup in your subscription.

[Back to top…](Readme.md#contents)
### Remove previously provisioned accounts

The Remove-AzSKSubscriptionRBAC command can be used to remove access control (RBAC) settings that were
previously provisioned using AzSK.

To remove access control related configuration, use the '-Tags' parameter. If this
parameter is not specified, only the deprecated accounts will be deleted from the subscription. Typically you would want to specify
the tags which were used when setting up RBAC. If you did not specify any tags during provisioning then,
by default, only the accounts marked as 'Mandatory' would get provisioned. Typically, you should not have
to remove those accounts but if you must you can do so using '-Tags "Mandatory"' in the command.

Run the below command with the subscriptionId which you want to remove RBAC accounts from:
```PowerShell
Remove-AzSKSubscriptionRBAC -SubscriptionId <subscriptionId> [-Tags <TagName>]
```		
[Back to top…](Readme.md#contents)

----------------------------------------------------------
## AzSK: Subscription Activity Alerts

#### Subscription Activity Alerts (based on Azure Insights)

> **Note**: The alerts setup covered on this page uses the native 'Insights-based' alerts mechanism 
offered by the Azure PG. In the 'Alerting & Monitoring' section, we also cover support for Log Analytics-based 
alerts which enable similar scenarios (and more). We have found that both approaches are in use across 
LoB application teams.

### Overview
This module helps setup and manage subscription and resource activity-based alerts in your Azure subscription. These alerts can be configured against actions that get recorded in Azure Audit Logs. These activity logs are natively generated upon resource activity by various ARM-based log providers (which are typically correspond to the different resource types in Azure). 

It is important to understand the concept of 'control plane' and 'data plane' in order to follow exactly which type of activities get covered by these alerts. In the ARM-model for Azure, everything that you can create from a subscription (at the portal or from PS) is considered a 'resource'. Various activities performed on these resources that you can do using the ARM APIs generate activity logs. For e.g., you can change the replication type of a storage account or you can set the size of an availability set, etc. These activities are usually considered 'control plane' activities. However, there are a set of activities that can happen "inside" the resource. For e.g., if you have a VM, you could log in to it as an Admin and add someone as a Guest user. Or just create a new folder under "C:\windows". These actions are usually considered 'data plane'. Insights-based alerts don't directly support alerting on 'data plane' actions. As is evident, each type of resource (VM, SQL Server, ADLS, etc.) will have their own ways of generating 'data plane' activity so alerting from that layer is usually very specific to each resource type. (Events from the 'data plane' are sometimes called 'Diagnostic Logs' whereas events from the 'control plane' are called 'Activity Logs'.)

In the context of this script, we have triaged the 200 or so activities that generate activity log entries and distilled them down to a subset that can be of interest to security. That subset was further triaged into Critical, High, Medium and Low severity alerts.

The basic script flow configures these alerts after taking an email id as input. After the alerts are setup, whenever a particular activity happens (e.g., adding a new person in the "Owners" group or modifying user defined routes on a virtual network), the configured email ID receives an email notification.  
 
[Back to top…](Readme.md#contents)
### Configure alerts for your subscription
You can setup alerts for a subscription using the following command:
```PowerShell
Set-AzSKAlerts -SubscriptionId <subscriptionid> -SecurityContactEmails <SecurityContactEmails> [-SecurityPhoneNumbers <SecurityPhoneNumbers>]
```
	
As noted above, by default alerts are configured for activities that are deemed to be Critical or High in severity by AzSK.

|Config Param Name	|Purpose	|Comments|
| ----------------  | --------- | ------ |
|SubscriptionId 	|Subscription ID against which the alerts would be setup| |
|SecurityContactEmails	|Email address of Security Point of Contact, can be a mail enabled security group or a distribution list |abc@contoso.com, xyz@contoso.net|
|SecurityPhoneNumbers	|Phone numbers of Security Point of Contact, provide contact no. with country code.|'+91-98765-43210' or '+1-425-882-8080'|

[Back to top…](Readme.md#contents)
### Remove previously configured alerts from your subscription
- Steps to remove all the alerts configured by AzSK:  
Run the below command:
```PowerShell
Remove-AzSKAlerts -SubscriptionId <SubscriptionID> -Tags <TagNames>
```
	
|Config Param Name	|Purpose	|
| ----------------  | --------- | 
|SubscriptionID	|Subscription ID against which these alerts would be setup|
|Tags |Comma-separated alert tag names which needs to be removed, supported tag names "Optional","Mandatory","SMS"|

For e.g., to remove only optional alerts, run following command:
```PowerShell
Remove-AzSKAlerts -SubscriptionId <SubscriptionID> -Tags "Optional"
```

**Note**: This command cleans up all alerts in the resource group 'AzSKRG' with matched tag. This resource group is used internally as a container for AzSK objects. As a result, it is advisable to not add other alerts (or other types of resources) to this RG.

[Back to top…](Readme.md#contents)
### FAQs
#### Can I get the alert emails to go to a distribution group instead of an individual email id?
Yes it is possible. While setting up the alerts you are asked to provide the SecurityContactEmails. It supports individual point of contact or mail enabled security group or a distribution list.  

#### How can I find out more once I receive an alert email?
You should visit portal with the details data provided in the Alert Email. For example, you could visit the resource id and look for the action that has been called out in the email, or to get more details about the alert, visit the Activity Log in the portal and look for this resource type, you should find more details on the action performed.  

**Note:** 
These alerts template and the generation is completely controlled through Azure Application Insights framework. 

#### Is there a record maintained of the alerts that have fired?
You could run the below command to check the alerts raised on the subscription.
```PowerShell
Get-AzLog | where {$_.OperationName -eq "Microsoft.Insights/AlertRules/Activated/Action"}
```  
#### Troubleshooting
|Error Description	|Comments|
| --------------  | ------- |
|Error: Please enter valid subscription id!|	Provided subscription id is incorrect|
|Error Occurred! Try running the command with -Debug option for more details. |Failed to setup the policy. Share the details of the errors to AzSKSup@microsoft.com|

[Back to top…](Readme.md#contents)

----------------------------------------------------------
## AzSK: Azure Security Center (ASC) configuration

### Setup Azure Security Center (ASC) on your subscription

The Set-AzSKAzureSecurityCenterPolicies provisions the following for Azure Security Center (ASC) configuration:
1. Configure Azure Security Center by enabling all the required policies and rules.
2. Configure email address and phone number for contact preferences.
3. Enable automatic provisioning for the subscription.

**Prerequisites:**
1. You need to be owner on the subscription which you want to onboard on to ASC.
2. Ensure you have the latest AzSK modules installed.

**Steps to onboard onto ASC:**
1. Open PowerShell under non admin mode.
2. Login into your Azure Account using Connect-AzAccount.
3. Run the below command with the subscriptionId on which you want to configure Azure Security Center.
```PowerShell
Set-AzSKAzureSecurityCenterPolicies -SubscriptionId <SubscriptionId> `
        -SecurityContactEmails <ContactEmails> `
        -SecurityPhoneNumber <ContactPhone> `
        [-OptionalPolicies] `
        [-SetASCTier]
```
|Config Param Name	|Purpose	|
| --------------- | -------- |
|SubscriptionId 	|Subscription ID against which ASC would be setup	|
|SecurityContactEmails 	|Comma-separated list of emails (e.g., 'abc@microsoft.com, def@microsoft.com')	for contact preference|
|SecurityPhoneNumber 	|Single phone number (e.g., '425-882-8080' or '+91-98765-43210' or '+1-425-882-8080')	for contact preference|
|OptionalPolicies       |Switch to enable policies which are marked as optional|
|SetASCTier |Switch for configuring standard pricing tiers for all the resource types supported in Azure Security Center (ASC) |

This command will *overwrite* the contact emails and contact phone previously set in Azure Security Center. Here is the [list](../01-Subscription-Security/ASCPoliciesCoverage.md) of all the policies (both mandatory & optional) that are enabled via this command.

>**Note:** The Get-AzSKSubscriptionSecurityStatus cmdlet can be used to check Azure Security Center settings (amongst other things). That script checks for the following w.r.t. Azure Security Center: 
>1.  All ASC policies are configured per expectation.
>2. There are no pending ASC tasks.
>3. There are no pending ASC recommendations.  
(Presence of either of Tasks/Recommendations indicates that there are some security issues that need attention.)  

[Back to top…](Readme.md#contents)  

----------------------------------------------------------
## AzSK: Subscription Security - ARM Policy

### Overview
The native ARM Policy feature in Azure can be used control access to resources by explicitly auditing or denying access to certain operations on them. The ARM Policy setup script in the AzSK uses this feature to define and deploy some broadly applicable security policies in the subscription. By using the setup script (either standalone or through the overall Provisioning script), you can be assured that the subscription is compliant with respect to the core set of policies expected to be in place by AzSK.

[Back to top…](Readme.md#contents)
### Setup ARM policies on your subscription
You can install the ARM policies via the Set-AzSKARMPolicies cmdlet as below:
1. Login to your Azure Subscription using below command
	
```PowerShell
Connect-AzAccount
```
	
2. Once you have installed the AzSK, you should be able to run the below command
	
```PowerShell
Set-AzSKARMPolicies -SubscriptionId <subscriptionid>
```
	
|Config Param Name	|Purpose	|
| --------------- | -------- |
|SubscriptionId 	|Subscription ID against which these alerts would be setup	|

[Back to top…](Readme.md#contents)
### Remove ARM policies from your subscription
Use the following command to remove the ARM policies setup via the AzSK 

```PowerShell
Remove-AzSKARMPolicies -subscriptionId <subscriptionId> -Tags <TagNames>
```
You can also use native Azure PS commands to do the same. Refer to this MSDN [article](https://msdn.microsoft.com/en-us/library/mt652489.aspx) for more details.

[Back to top…](Readme.md#contents)
### FAQs
#### What happens if an action in the subscription violates the policy?
Currently "effect" parameter of all the AzSK policies is configured as "audit". So, in the event of policy violation, it would generate an audit log entry. You should watch for these policy violation audit events in the Azure audit log.

#### Which ARM policies are installed by the setup script?
The ARM policy configuration script currently enables the policies (Refer the list [here](../02-Secure-Development/ControlCoverage/Feature/ARMPolicyList.md)) in the subscription. Note that the policy level is currently set to 'Audit'.  

>Policy definitions exist in the JSON file at this location: 
 C:\Users\SampleUser\Documents\WindowsPowerShell\Modules\AzSK\\\<version\>\Framework\Configurations\SubscriptionSecurity\Subscription.ARMPolicies.json

#### How can I check for policy violations? 
You could run the below command to check for the policy violations on the subscription. By default this shows the violations for the last one hour. Other intervals can be specified.
```PowerShell
Get-AzLog | where {$_.OperationName -eq "Microsoft.Authorization/policies/audit/action"} 
```

Refer to this [MSDN article](https://azure.microsoft.com/en-in/documentation/articles/resource-manager-policy/#policy-audit-events) for more details

#### Are there more policies available for use?
We have covered for the below resource types so far:
- Azure SQL DB
- Azure Storage
- Scheduler Service
- Usage of classic (v1/non-ARM) resources
 More policies will be added in upcoming releases.
	
#### Troubleshooting

|Error Description	|Comments|
| ----------------- |--------|
|Error: Please enter valid subscription id! |Provided subscription id is incorrect|
|Error Occurred! Try running the command with -Debug option for more details.	|Failed to setup the policy. Share the details of the errors to AzSKSup@microsoft.com |

Reach out to AzSKSup@microsoft.com for any further help  

[Back to top…](Readme.md#contents)

## AzSK: Update subscription security baseline configuration 

### Update subscription security baseline configuration
AzSK team is constantly improving subscription security capabilities so it is possible that newer AzSK version has enhanced baselines for ASC, Alerts, ARM policies, CA runbook etc. This is where below command can help you to update your baseline configuration for different features (ARM Policies, Alerts, ASC, Access control, Continuous Assurance runbook).  

```PowerShell
Update-AzSKSubscriptionSecurity -SubscriptionId <subscriptionid>
```
|Config Param Name	|Purpose	|
| --------------- | -------- |
|SubscriptionId 	|Subscription for which AzSK subscription security baseline would be upgraded	|

> **Note**: 
>  - This command is useful only for updating AzSK subscription security baseline. If you have never setup baseline, then you can set it up using Set-AzSKSubscriptionSecurity command.
>  - This command also helps you to recover if any of the base resources are accidentally deleted, like AzSK resource group, storage account, attestation container, continuous assurance log container etc.



[Back to top…](Readme.md#contents)

## AzSK support for Azure Government and Azure China

>**Pre-requisites**:
> - AzSK version 3.8.0 or above.

From release 3.8.0, AzSK has started supporting a few core scenarios for Azure Government and Azure China environments. Please follow the steps as under to use AzSK in those environments.

### Spotcheck/Manual Scans:

Follow the steps below to successfully run the local AzSK scans (GRS, GSS and other commands):

1. Follow instructions in our [installation guide](../00a-Setup#installation-guide) to download the latest version of AzSK (3.9.0 or above).

2. Configure AzSK for your Azure environment using the following command:
```PowerShell
Set-AzSKPolicySettings -AzureEnvironment '<your environment name>'
```   
```PowerShell
E.g., Set-AzSKPolicySettings -AzureEnvironment AzureUSGovernment 
```   

Once you have run through the steps above, any AzSK commands you run will start targeting the configured Azure cloud environment. 

Notes:
  * When no specific environment is configured (as in Step-2 above), AzSK assume AzureCloud as the default environment.
  * If you have access to multiple Azure environments and need to switch from one to the other (e.g., AzurePublic to AzureChina) then you can use the  Clear-AzSKSessionState command after running Step-2. This will cause AzSK to reload the newly configured environment.

### CICD:

To use the CICD extension, no special steps are required beyond those outlined in the AzSK CICD extensions [doc](../03-Security-In-CICD#contents).


### CA:

Once you have run through the steps outlined in the 'Spotcheck/Manual' section, You can easily use AzSK Continuous Assurance. Click [here](/04-Continous-Assurance#continuous-assurance-ca) for more details on Continuous Assurance.

Please refer [this](../04-Continous-Assurance/Readme.md#setting-up-continuous-assurance---step-by-step) set up CA. As Azure Government and Azure China are limited to particular location, provide 'AutomationAccountLocation' parameter because the default value is EastUS2.

```PowerShell
E.g., Install-AzSKContinuousAssurance -SubscriptionId <SubscriptionId> `
		    -AutomationAccountLocation "USGov Virginia" `                    (for Azure Government)
	        -ResourceGroupNames <ResourceGroupNames> `
	        -LAWSId <WorkspaceId> `
	        -LAWSSharedKey <SharedKey> 
```

### Customizing AzSK for your organization:

Please refer [this](../07-Customizing-AzSK-for-your-Org#customizing-azsk-for-your-organization) for more details

Note:

As Azure Government and Azure China are limited to particular location, provide 'ResourceGroupLocation' parameter because the default value is EastUS2

```PowerShell
E.g., Install-AzSKOrganizationPolicy -SubscriptionId <SubscriptionId> `
           -OrgName <OrgName> `
           -PolicyFolderPath <PolicyFolderPath> `
           -ResourceGroupLocation "USGov Virginia" `
	   -AppInsightLocation "USGov Virginia"                   (for Azure Government)
```

## AzSK: Privileged Identity Management (PIM) helper cmdlets

AzSK now supports the Privileged Identity Management (PIM) helper cmdlets. This command provides a quicker way to perform Privileged Identity Management (PIM) operations and enables you to manage access to important Azure subscriptions, resource groups and resources.

### Use Get-AzSKPIMConfiguration (alias 'getpim') for querying various PIM settings/status at Subscription scope

  1. <h4> List your PIM-eligible roles (-ListMyEligibleRoles) </h4>

      Use this command to list eligible PIM roles in the selected Azure subscription.

      ```PowerShell
      Get-AzSKPIMConfiguration -ListMyEligibleRoles
      ```

  2. <h4> List permanent assignments (-ListPermanentAssignments) </h4>  

      Use this command to list Azure role with permanent assignments at the specified scope. By default, it lists all role assignments in the selected Azure subscription. Use respective parameters to list assignments for a specific role, or to list assignments on a specific resource group or resource.
      
      ```PowerShell
      Get-AzSKPIMConfiguration -ListPermanentAssignments`
                              -SubscriptionId <SubscriptionId> `
                              [-RoleNames <Comma separated list of roles>] `
                              [-ResourceGroupName <ResourceGroupName>] `
                              [-ResourceName <ResourceName>] `
                              [-DoNotOpenOutputFolder]
      ```

      <b>Example 1:</b> List all permanent assignments at subscription level with 'Contributor' and 'Owner' roles.

       ```PowerShell
      Get-AzSKPIMConfiguration -ListPermanentAssignments `
                               -SubscriptionId "65be5555-34ee-43a0-ddee-23fbbccdee45" `
                               -RoleNames "Contributor,Owner" `
                               -DoNotOpenOutputFolder
      ```

      <b>Example 2: </b> List all permanent assignments at 'DemoRG' resource group level with 'Contributor' role.

      ```PowerShell
      Get-AzSKPIMConfiguration -ListPermanentAssignments `
                               -SubscriptionId "65be5555-34ee-43a0-ddee-23fbbccdee45" `
                               -RoleNames "Contributor" `
                               -ResourceGroupName "DemoRG" `
                               -DoNotOpenOutputFolder
      ```
      <b>Example 3: </b> List all permanent assignments at resource level with 'Contributor' and 'Owner' role.

      ```PowerShell
      Get-AzSKPIMConfiguration -ListPermanentAssignments `
                               -SubscriptionId "65be5555-34ee-43a0-ddee-23fbbccdee45" `
                               -RoleNames "Contributor,Owner" `
                               -ResourceGroupName "DemoRG" `
                               -ResourceName "AppServiceDemo" `
                               -DoNotOpenOutputFolder
      ```

  3. <h4> List PIM assignments (-ListPIMAssignments) </h4>

      Use this command to list Azure role with PIM assignments at the specified scope. By default, it lists all role assignments in the selected Azure subscription. Use respective parameters to list assignments for a specific role, or to list assignments on a specific resource group or resource.

      ```PowerShell
      Get-AzSKPIMConfiguration -ListPIMAssignments `
                              -SubscriptionId <SubscriptionId> `
                              [-RoleNames <Comma separated list of roles>] `
                              [-ResourceGroupName <ResourceGroupName>] `
                              [-ResourceName <ResourceName>] `
                              [-DoNotOpenOutputFolder]
      ```
      <b>Example 1: </b> List 'Contributor' and 'Owner' PIM assignments at subscription level.

       ```PowerShell
      Get-AzSKPIMConfiguration -ListPIMAssignments `
                               -SubscriptionId "65be5555-34ee-43a0-ddee-23fbbccdee45" `
                               -RoleNames "Contributor,Owner" `
                               -DoNotOpenOutputFolder
      ```

      <b>Example 2: </b> List 'Contributor' PIM assignments at 'DemoRG' resource group level.

      ```PowerShell
      Get-AzSKPIMConfiguration -ListPIMAssignments `
                               -SubscriptionId "65be5555-34ee-43a0-ddee-23fbbccdee45" `
                               -RoleNames "Contributor" `
                               -ResourceGroupName "DemoRG" `
                               -DoNotOpenOutputFolder
      ```
      <b>Example 3: </b> List 'Contributor' and 'Owner' PIM assignments at resource level.

      ```PowerShell
      Get-AzSKPIMConfiguration -ListPIMAssignments `
                               -SubscriptionId "65be5555-34ee-43a0-ddee-23fbbccdee45" `
                               -RoleNames "Contributor,Owner" `
                               -ResourceGroupName "DemoRG" `
                               -ResourceName "AppServiceDemo" `
                               -DoNotOpenOutputFolder
      ```
3. <h4> List expiring assignments (-ListSoonToExpireAssignments) </h4>

      Use this command to list Azure role with PIM assignments at the specified scope that are about to expire in given number of days. Use respective parameters to list expiring assignments for a specific role on a subscription or a resource group or a resource.

      ```PowerShell
	  Get-AzSKPIMConfiguration -ListSoonToExpireAssignment  `
                              -SubscriptionId <SubscriptionId> `
                              -RoleNames <Comma separated list of roles> `
                              -ExpiringInDays ` # The number of days you want to query expiring assignments for
                              [-DoNotOpenOutputFolder]
      ```
      <b>Example 1: </b> List 'Owner' PIM assignments at subscription level that will expire in 10 days.

      ```PowerShell
      Get-AzSKPIMConfiguration -ListSoonToExpireAssignment `
                               -SubscriptionId "65be5555-34ee-43a0-ddee-23fbbccdee45" `
                               -RoleNames 'Owner' `
			       -ExpiringInDays 10`
                               -DoNotOpenOutputFolder

4. <h4> List existing role settings (-ListRoleSettings) </h4>

      Use this command to list Azure role with PIM assignments at the specified scope to fetch existing settings of a role for both Eligible and Active role assignments.

      ```PowerShell
	  Get-AzSKPIMConfiguration -ListRoleSettings  `
                              -SubscriptionId <SubscriptionId> `
                              -RoleName "Owner" `
                              [-ResourceGroupName]
                              [-ResourceName]
      ```
      <b>Example 1: </b> List role settings for 'Owner' PIM role at subscription level.

      ```PowerShell
      Get-AzSKPIMConfiguration -ListRoleSettings `
                               -SubscriptionId "65be5555-34ee-43a0-ddee-23fbbccdee45" `
                               -RoleName "Owner" `
      ```
      <b>Example 2: </b> List role settings for 'Contributor' PIM role at resource level.

      ```PowerShell
      Get-AzSKPIMConfiguration -ListRoleSettings `
                               -SubscriptionId "65be5555-34ee-43a0-ddee-23fbbccdee45" `
                               -RoleName "Contributor" `
                               -ResourceGroupName "DemoRG" `
                               -ResourceName "AppServiceDemo" `
      ```

### Use Set-AzSKPIMConfiguration (alias 'setpim') for configuring/changing PIM settings at Subscription scope:

  1. <h4> Assigning users to roles (-AssignRole) </h4>
     
     Use this command to assign PIM role to the specified principal, at the specified scope.      
      > <b>NOTE:</b>
      > a. You must have owner access to run this command.
      > b. Assignment Type 'Eligible' or 'Active' can be provided in -AssignmentType parameter. If parameter is not explicitly used then role is assigned for 'Eligible' assignment type.
      
      ```PowerShell
      Set-AzSKPIMConfiguration -AssignRole `
                              -SubscriptionId <SubscriptionId> `
                              -DurationInDays <Int> `
                              -RoleName <RoleName> `
                              -PrincipalName  <PrincipalName> `
                              [-ResourceGroupName <ResourceGroupName>] `
                              [-ResourceName <ResourceName>] `
                              [-AssignmentType <Eligible | Active>] `
                              [-DoNotOpenOutputFolder]
      ```
      <b>Example 1: </b> Grant PIM Eligible access with 'Contributor' role to a user for 30 days on a subscription.

      ```PowerShell
      Set-AzSKPIMConfiguration -AssignRole `
                               -SubscriptionId "65be5555-34ee-43a0-ddee-23fbbccdee45" `
                               -DurationInDays 30 `
                               -RoleName "Contributor" `
                               -PrincipalName "john.brown@microsoft.com" `
                               -DoNotOpenOutputFolder
      ```
      <b>Example 2: </b> Grant PIM Eligible access with 'Owner' role to a user for 20 days on a resource group 'DemoRG'.

      ```PowerShell
      Set-AzSKPIMConfiguration -AssignRole `
                               -SubscriptionId "65be5555-34ee-43a0-ddee-23fbbccdee45" `
                               -DurationInDays 20 `
                               -ResourceGroupName "DemoRG" `
                               -RoleName "Owner" `
                               -PrincipalName "john.brown@microsoft.com" `
                               -DoNotOpenOutputFolder
      ```

      <b>Example 3: </b> Grant PIM Eligible access with 'Owner' role to a user for 30 days on a resource 'AppServiceDemo'.

      ```PowerShell
      Set-AzSKPIMConfiguration -AssignRole `
                               -SubscriptionId "65be5555-34ee-43a0-ddee-23fbbccdee45" `
                               -DurationInDays 30 `
                               -ResourceGroupName "DemoRG" `
                               -ResourceName "AppServiceDemo" `
                               -RoleName "Owner" `
                               -PrincipalName "john.brown@microsoft.com" `
                               -DoNotOpenOutputFolder
      ```
      <b>Example 4: </b> Grant PIM Active access with 'Reader' role to a user for 30 days on a resource 'AppServiceDemo'.

      ```PowerShell
      Set-AzSKPIMConfiguration -AssignRole `
                               -SubscriptionId "65be5555-34ee-43a0-ddee-23fbbccdee45" `
                               -DurationInDays 30 `
                               -ResourceGroupName "DemoRG" `
                               -ResourceName "AppServiceDemo" `
                               -RoleName "Reader" `
                               -PrincipalName "john.brown@microsoft.com" `
                               -AssignmentType "Active" `
                               -DoNotOpenOutputFolder
      ```

  2. <h4> Activating your roles (-ActivateMyRole) </h4>

      Use this command to activate your PIM access.

      > <b>NOTE:</b>  
      > a. Activation duration should range between 1 to 8 hours.  
      > b. Make sure that the PIM role you are activating is eligible. If your PIM role has expired, contact subscription administrator to renew/re-assign your PIM role.  

      ```PowerShell
      Set-AzSKPIMConfiguration -ActivateMyRole `
                              -SubscriptionId <SubscriptionId> `
                              -RoleName <RoleName> `
                              -DurationInHours <Int> `
                              -Justification <String> `
                              [-ResourceGroupName <ResourceGroupName>] `
                              [-ResourceName <ResourceName>] `
                              [-DoNotOpenOutputFolder]
      ```

      <b>Example 1: </b> Activate your PIM access on a resource group.

      ```PowerShell
      Set-AzSKPIMConfiguration -ActivateMyRole `
                              -SubscriptionId "65be5555-34ee-43a0-ddee-23fbbccdee45" `
                              -RoleName "Owner" `
                              -DurationInHours 8 `
                              -Justification "Add a valid justification for enabling PIM role" `
                              -ResourceGroupName "DemoRG" `
                              -DoNotOpenOutputFolder
      ```

  3. <h4> Deactivating your roles (-DeactivateMyRole) </h4>

      Use this command to deactivate your PIM access.

      ```PowerShell
      Set-AzSKPIMConfiguration -DeactivateMyRole `
                              -SubscriptionId <SubscriptionId> `
                              -RoleName <RoleName> `
                              [-ResourceGroupName <ResourceGroupName>] `
                              [-ResourceName <ResourceName>] `
                              [-DoNotOpenOutputFolder]
      ```
      <b>Example 1: </b> Deactivate your PIM access on a subscription.

      ```PowerShell
      Set-AzSKPIMConfiguration -DeactivateMyRole `
                              -SubscriptionId "65be5555-34ee-43a0-ddee-23fbbccdee45" `
                              -RoleName "Owner" `
                              -DoNotOpenOutputFolder
      ```

  4. <h4> Assign PIM to permanent assignments at subscription/RG scope  (-AssignEligibleforPermanentAssignments) </h4>

      Use this command to change permanent assignments to PIM for specified roles, at the specified scope. 

      > <b>NOTE:</b>  
      > This command will create PIM, but will not remove the permanent assignments. After converting permanent assignments to PIM, you can use *"Set-AzSKPIMConfiguration -RemovePermanentAssignments"* command with *"-RemoveAssignmentFor MatchingEligibleAssignments"* parameter to remove permanent assignment.


      ```PowerShell
      Set-AzSKPIMConfiguration -AssignEligibleforPermanentAssignments `
                              -SubscriptionId <SubscriptionId> `
                              -RoleNames <Comma separated list of roles> `
                              -DurationInDays <Int> `
                              [-ResourceGroupName <ResourceGroupName>] `
                              [-ResourceName <ResourceName>] `
                              [-DoNotOpenOutputFolder]
                              [-Force]
      ```

      <b>Example 1: </b> Convert permanent assignments to PIM for 'Contributor' and 'Owner' roles at subscription level . This command runs in an interactive manner so that you get an opportunity to verify the accounts being converted.

      ```PowerShell
      Set-AzSKPIMConfiguration -AssignEligibleforPermanentAssignments `
                              -SubscriptionId "65be5555-34ee-43a0-ddee-23fbbccdee45" `
                              -RoleNames "Contributor,Owner" `
                              -DurationInDays 30 `
                              -DoNotOpenOutputFolder
      ```
      <b>Example 2: </b> Use *'-Force'* parameter to convert permanent assignments to PIM without giving runtime verification step.

      ```PowerShell
      Set-AzSKPIMConfiguration -AssignEligibleforPermanentAssignments `
                              -SubscriptionId "65be5555-34ee-43a0-ddee-23fbbccdee45" `
                              -RoleNames "Contributor,Owner" `
                              -ResourceGroupName "DemoRG" `
                              -ResourceName "AppServiceDemo"`
                              -DurationInDays 20 `
                              -DoNotOpenOutputFolder
                              -Force
      ```

  5. <h4> Removing permanent assignments altogether (-RemovePermanentAssignments) </h4>

      Use this command to remove permanent assignments of specified roles, at the specified scope.

      There are two options with this command:

        a. *-RemoveAssignmentFor MatchingEligibleAssignments (Default)*: Remove only those permanent roles which have a corresponding eligible PIM role.

        b. *-RemoveAssignmentFor AllExceptMe*: Remove all permanent role except your access.

      > <b>NOTE:</b>
      > This command will *not* remove your permanent assignment if one exists.


      ```PowerShell
      Set-AzSKPIMConfiguration -RemovePermanentAssignments `
                              -SubscriptionId <SubscriptionId> `
                              -RoleNames <Comma separated list of roles> `
                              [-RemoveAssignmentFor MatchingEligibleAssignments] `
                              [-ResourceGroupName <ResourceGroupName>] `
                              [-ResourceName <ResourceName>] `
                              [-DoNotOpenOutputFolder]
                              [-Force]
      ```

      ```PowerShell
      Set-AzSKPIMConfiguration -RemovePermanentAssignments `
                              -SubscriptionId <SubscriptionId> `
                              -RoleNames <Comma separated list of roles> `
                              [-RemoveAssignmentFor AllExceptMe] `
                              [-ResourceGroupName <ResourceGroupName>] `
                              [-ResourceName <ResourceName>] `
                              [-DoNotOpenOutputFolder]
                              [-Force]

      ```

      <b>Example 1: </b> Remove 'Contributor' and 'Owner' roles that have permanent assignment at subscription level. This command runs in an interactive manner so that you get an opportunity to verify the accounts being removed. All the specified role with permanent access will get removed except your access.

      ```PowerShell
      Set-AzSKPIMConfiguration -RemovePermanentAssignments `
                              -SubscriptionId "65be5555-34ee-43a0-ddee-23fbbccdee45" `
                              -RoleNames "Contributor,Owner" `
                              -RemoveAssignmentFor AllExceptMe
                              -DoNotOpenOutputFolder
      ```

      <b>Example 2: </b> Use *'-Force'* parameter to run the command in non-interactive mode. This will remove permanent assignment at resource level without giving runtime verification step. Use *-RoleNames* to filter the roles to be deleted. Here we have used *-RemoveAssignmentFor 'MatchingEligibleAssignments'*. Hence, this command deletes the specified role with permanent access only if there is a corresponding PIM role for the same.

      ```PowerShell
      Set-AzSKPIMConfiguration -RemovePermanentAssignments `
                              -SubscriptionId "65be5555-34ee-43a0-ddee-23fbbccdee45" `
                              -RoleNames "Owner" `
                              -RemoveAssignmentFor MatchingEligibleAssignments
                              -ResourceGroupName "DemoRG" `
                              -ResourceName "AppServiceDemo"`
                              -DoNotOpenOutputFolder
                              -Force
      ```


 6. <h4> Extend PIM assignments for expiring assignments (-ExtendExpiringAssignments) </h4>
	 Use this command to extend PIM eligible assignments that are about to expire in n days

    <b>Example 1: </b>Extend Owner PIM roles that are to be expired in 10 days. This command runs in an interactive manner in order to verify the assignments being extended.

      ```PowerShell
      Set-AzSKPIMConfiguration -ExtendExpiringAssignments `
                              -SubscriptionId "65be5555-34ee-43a0-ddee-23fbbccdee45" `
                              -RoleName "Owner" `
                              -ExpiringInDays 10
			      -DurationInDays 30 # The duration in days for expiration to be extended by
                              -DoNotOpenOutputFolder
      ```
      
      <b>Example 2: </b> Use *'-Force'* parameter to run the command in non-interactive mode. This command will extend expiry of  'Owner' PIM roles that are about to be expired in 10 days by skipping the verification step.

      ```PowerShell
      Set-AzSKPIMConfiguration -ExtendExpiringAssignments `
                              -SubscriptionId "65be5555-34ee-43a0-ddee-23fbbccdee45" `
                              -RoleName "Owner" `
                              -ExpiringInDays 10
			      -DurationInDays 30 # The duration in days for expiration to be extended by
                              -Force
    
     <b>Example 3: </b> Extend Owner PIM roles that are to be expired in 10 days specific to principal names.

      ```PowerShell
      Set-AzSKPIMConfiguration -ExtendExpiringAssignments `
                              -SubscriptionId "65be5555-34ee-43a0-ddee-23fbbccdee45" `
                              -RoleName "Owner" `
                              -ExpiringInDays 10
			                  -PrincipalNames "abc@microsoft.com,def@microsoft.com"  
                             

7. <h4>Configure role settings for role on an Azure resource (-ConfigureRoleSettings)  </h4>
	 Use this command to configure a  PIM role settings like maximum role assignment duration on a resource, mfa requirement upon activation etc.
    
     The command currently supports configuring the following settings:

      a. *For Eligible Assignment Type*: Maximum assignment duration, maximum activation duration, requirement of justification upon activation, requirement of mfa upon activation and applying conditional access policies during activation.

      b. *For Active Assignment Type*: Maximum active assignment duration, requirement of justification on assignment, requirement of mfa on assignment.

     
      <b>Example 1: </b> Configure 'Owner' PIM role on a subscription for Eligible assignment type, to let maximum activation duration be 12 hours.

      ```PowerShell
      Set-AzSKPIMConfiguration  -ConfigureRoleSettings `
                                -SubscriptionId "65be5555-34ee-43a0-ddee-23fbbccdee45" `
                                -RoleNames "Owner" `
                                -MaximumActivationDuration 12`
                                -ExpireEligibleAssignmentsInDays 90 `
                                -RequireJustificationOnActivation $true
                                -RequireMFAOnActivation $true
                                -DoNotOpenOutputFolder`
      ```
      
	 <b>Example 2: </b> Configure 'Owner' PIM role on a subscription for Eligible assignment type, to apply conditional access policy while activation.
	    Note: Currently application of both MFA and conditional policy on the same role is not supported. Either of them should be applied to a given role. 

      ```PowerShell
      Set-AzSKPIMConfiguration  -ConfigureRoleSettings `
                                -SubscriptionId "65be5555-34ee-43a0-ddee-23fbbccdee45" `
                                -RoleNames "Owner" `
                                -ApplyConditionalAccessPolicyForRoleActivation $true
                                -DoNotOpenOutputFolder`
      ```
      
	 <b>Example 3: </b> Configure 'Reader' PIM role on a subscription for Active assignment type, to let maximum assignment duration be 15 days. 

      ```PowerShell
      Set-AzSKPIMConfiguration  -ConfigureRoleSettings `
                                -SubscriptionId "65be5555-34ee-43a0-ddee-23fbbccdee45" `
                                -RoleNames "Reader" `
                                -ExpireActiveAssignmentsInDays 15 `
                                -RequireJustificationOnActiveAssignment $false `
                                -RequireMFAOnActiveAssignment $true `
                                -DoNotOpenOutputFolder
      ```
8. <h4> Remove PIM assignments for a role on an Azure resource (-RemovePIMAssignment) </h4>
     Use this command to remove PIM assignments of specified role, at the specified scope.

    <b>Example 1: </b> Remove 'Contributor' role that have PIM assignment at subscription level. This command runs in an interactive manner so that you get an opportunity to verify the accounts being removed. All the specified principal names with PIM access on the role will get removed.

      ```PowerShell
      Set-AzSKPIMConfiguration  -RemovePIMAssignment `
                                -SubscriptionId "65be5555-34ee-43a0-ddee-23fbbccdee45" `
                                -RoleName "Contributor" `
                                -PrincipalNames "abc@microsoft.com,def@microsoft.com" 
      ```

      <b>Example 2: </b> Use *'-Force'* parameter to run the command in non-interactive mode. This will remove PIM assignment at resource level without giving runtime verification step. 

      ```PowerShell
      Set-AzSKPIMConfiguration  -RemovePIMAssignment `
                                -SubscriptionId "65be5555-34ee-43a0-ddee-23fbbccdee45" `
                                -RoleName "Contributor" `
                                -PrincipalNames "abc@microsoft.com,def@microsoft.com" `
                                -ResourceGroupName "DemoRG" `
                                -ResourceName "AppServiceDemo" `
                                -Force
      ```

### Use Get-AzSKPIMConfiguration (alias 'getpim') for querying various PIM settings/status at Management Group level

  1. <h4> List permanent assignments (-ListPermanentAssignments) </h4>  

      Use this command to list Azure role with permanent assignments at the specified scope. By default, it lists all role assignments in the selected Azure Management Group. Use respective parameters to list assignments for a specific role, or to list assignments on a specific roles.
      
      ```PowerShell
      Get-AzSKPIMConfiguration -ListPermanentAssignments`
                              -ManagementGroupId <ManagementGroupId> `
                              [-RoleNames <Comma separated list of roles>] `
                              [-DoNotOpenOutputFolder]
      ```

      <b>Example 1: </b> List all permanent assignments at Management Group level.

      ```PowerShell
      Get-AzSKPIMConfiguration -ListPermanentAssignments `
                               -ManagementGroupId <ManagementGroupId>
      ```
      <b>Example 2:</b> List all permanent assignments at Management Group level with 'Contributor' and 'Owner' roles.

       ```PowerShell
      Get-AzSKPIMConfiguration -ListPermanentAssignments `
                               -ManagementGroupId <ManagementGroupId> `
                               -RoleNames "Contributor,Owner" `
                               -DoNotOpenOutputFolder
      ```


  2. <h4> List PIM assignments (-ListPIMAssignments) </h4>

      Use this command to list Azure role with PIM assignments at the specified scope. By default, it lists all role assignments in the selected Azure Management Group. Use respective parameters to list assignments for a specific roles.

      ```PowerShell
      Get-AzSKPIMConfiguration -ListPIMAssignments `
                              -ManagementGroupId <ManagementGroupId> `
                              [-RoleNames <Comma separated list of roles>] `
                              [-DoNotOpenOutputFolder]
      ```
      <b>Example 1: </b> List PIM assignments at Management Group level.

      ```PowerShell
      Get-AzSKPIMConfiguration -ListPIMAssignments `
                               -ManagementGroupId <ManagementGroupId>
      ```
      <b>Example 2: </b> List 'Contributor' and 'Owner' PIM assignments at Management Group level.

      ```PowerShell
      Get-AzSKPIMConfiguration -ListPIMAssignments `
                               -ManagementGroupId <ManagementGroupId> `
                               -RoleNames "Contributor,Owner" `
                               -DoNotOpenOutputFolder
      ```
      

  3. <h4> List expiring assignments (-ListSoonToExpireAssignments) </h4>

      Use this command to list Azure role with PIM assignments at the specified scope that are about to expire in given number of days. Use respective parameters to list expiring assignments for a specific role on a Management Group.

      ```PowerShell
	  Get-AzSKPIMConfiguration -ListSoonToExpireAssignment  `
                               -ManagementGroupId <ManagementGroupId> `
                               -RoleNames <Comma separated list of roles> `
                               -ExpiringInDays <int> ` # The number of days you want to query expiring assignments for
                               [-DoNotOpenOutputFolder]
      ```
      <b>Example 1: </b> List 'Owner' PIM assignments at Management Group level that will expire in 10 days.

      ```PowerShell
      Get-AzSKPIMConfiguration -ListSoonToExpireAssignment `
                               -ManagementGroupId <ManagementGroupId> `
                               -RoleNames 'Owner' `
			                   -ExpiringInDays 10`
                               -DoNotOpenOutputFolder
      ```
   4. <h4> List existing role settings (-ListRoleSettings) </h4>

      Use this command to list Azure role with PIM assignments at the specified scope to fetch existing settings of a role for both Eligible and Active role assignments.

      ```PowerShell
	  Get-AzSKPIMConfiguration -ListRoleSettings  `
                              -ManagementGroupId <ManagementGroupId> `
                              -RoleName "Owner" `
      ```
      <b>Example 1: </b> List role settings for 'Owner' PIM role at Management Group level.

      ```PowerShell
      Get-AzSKPIMConfiguration -ListRoleSettings `
                               -ManagementGroupId "65be5555-34ee-43a0-ddee-23fbbccdee45" `
                               -RoleName "Owner" `
      ```

### Use Set-AzSKPIMConfiguration (alias 'setpim') for configuring/changing PIM settings at Management Group level:

  1. <h4> Assigning users to roles (-AssignRole) </h4>
     
     Use this command to assign PIM role to the specified principal, at the specified scope.
      > <b>NOTE:</b>
      > You must have owner access to run this command.
      
      ```PowerShell
      Set-AzSKPIMConfiguration -AssignRole `
                              -ManagementGroupId <ManagementGroupId> `
                              -DurationInDays <Int> `
                              -RoleName <RoleName> `
                              -PrincipalNames  <PrincipalNames> `
                              [-DoNotOpenOutputFolder]
      ```
      <b>Example 1: </b> Grant PIM access with 'Contributor' role to a user for 30 days on a Management Group.

      ```PowerShell
      Set-AzSKPIMConfiguration -AssignRole `
                               -ManagementGroupId <ManagementGroupId> `
                               -DurationInDays 30 `
                               -RoleName "Contributor" `
                               -PrincipalName "john.brown@microsoft.com" `
                               -DoNotOpenOutputFolder
      ```

  2. <h4> Activating your roles (-ActivateMyRole) </h4>

      Use this command to activate your PIM access.

      > <b>NOTE:</b>  
      > a. Activation duration should range between 1 to 8 hours.  
      > b. Make sure that the PIM role you are activating is eligible. If your PIM role has expired, contact subscription administrator to renew/re-assign your PIM role.  

      ```PowerShell
      Set-AzSKPIMConfiguration -ActivateMyRole `
                              -ManagementGroupId <ManagementGroupId> `
                              -RoleName <RoleName> `
                              -DurationInHours <Int> `
                              -Justification <String> `
                              [-DoNotOpenOutputFolder]
      ```

      <b>Example 1: </b> Activate your PIM access on a Management Group.

      ```PowerShell
      Set-AzSKPIMConfiguration -ActivateMyRole `
                              -ManagementGroupId <ManagementGroupId> `
                              -RoleName "Owner" `
                              -DurationInHours 8 `
                              -Justification "Add a valid justification for enabling PIM role" `
                              -DoNotOpenOutputFolder
      ```

  3. <h4> Deactivating your roles (-DeactivateMyRole) </h4>

      Use this command to deactivate your PIM access.

      ```PowerShell
      Set-AzSKPIMConfiguration -DeactivateMyRole `
                              -ManagementGroupId <ManagementGroupId> `
                              -RoleName <RoleName> `
                              [-DoNotOpenOutputFolder]
      ```
      <b>Example 1: </b> Deactivate your PIM access on a subscription.

      ```PowerShell
      Set-AzSKPIMConfiguration -DeactivateMyRole `
                              -ManagementGroupId <ManagementGroupId> `
                              -RoleName "Owner" `
                              -DoNotOpenOutputFolder
      ```

  4. <h4> Assign PIM to permanent assignments at Management Group scope  (-AssignEligibleforPermanentAssignments) </h4>

      Use this command to change permanent assignments to PIM for specified roles, at the specified scope. 

      > <b>NOTE:</b>  
      > This command will create PIM, but will not remove the permanent assignments. After converting permanent assignments to PIM, you can use *"Set-AzSKPIMConfiguration -RemovePermanentAssignments"* command with *"-RemoveAssignmentFor MatchingEligibleAssignments"* parameter to remove permanent assignment.


      ```PowerShell
      Set-AzSKPIMConfiguration -AssignEligibleforPermanentAssignments `
                              –ManagementGroupId <ManagementGroupId> `
                              -RoleNames <Comma separated list of roles> `
                              -DurationInDays <Int> `
                              [-DoNotOpenOutputFolder]
                              [-Force]
      ```

      <b>Example 1: </b> Convert permanent assignments to PIM for 'Contributor' and 'Owner' roles at Management Group level. This command runs in an interactive manner so that you get an opportunity to verify the accounts being converted.

      ```PowerShell
      Set-AzSKPIMConfiguration -AssignEligibleforPermanentAssignments `
                              –ManagementGroupId <ManagementGroupId> `
                              -RoleNames "Contributor,Owner" `
                              -DurationInDays 30 `
                              -DoNotOpenOutputFolder
      ```
      
      <b>Example 2: </b> Use '-Force' parameter to convert permanent assignments to PIM without giving runtime verification step.

      ```PowerShell
      Set-AzSKPIMConfiguration -AssignEligibleforPermanentAssignments `
                              –ManagementGroupId <ManagementGroupId> `
                              -RoleNames "Contributor,Owner" `
                              -DurationInDays 30 `
                              -DoNotOpenOutputFolder `
                              -Force
      ```

  5. <h4> Removing permanent assignments altogether (-RemovePermanentAssignments) </h4>

      Use this command to remove permanent assignments of specified roles, at the specified scope.

      There are two options with this command:

        a. *-RemoveAssignmentFor MatchingEligibleAssignments (Default)*: Remove only those permanent roles which have a corresponding eligible PIM role.

        b. *-RemoveAssignmentFor AllExceptMe*: Remove all permanent role except your access.

      > <b>NOTE:</b>
      > This command will *not* remove your permanent assignment if one exists.


      ```PowerShell
      Set-AzSKPIMConfiguration -RemovePermanentAssignments `
                              -ManagementGroupId <ManagementGroupId> `
                              -RoleNames <Comma separated list of roles> `
                              [-RemoveAssignmentFor MatchingEligibleAssignments] `
                              [-DoNotOpenOutputFolder]
                              [-Force]
      ```

      ```PowerShell
      Set-AzSKPIMConfiguration -RemovePermanentAssignments `
                              -ManagementGroupId <ManagementGroupId> `
                              -RoleNames <Comma separated list of roles> `
                              [-RemoveAssignmentFor AllExceptMe] `
                              [-DoNotOpenOutputFolder]
                              [-Force]

      ```

      <b>Example 1: </b> Remove 'Contributor' and 'Owner' roles that have permanent assignment at Management Group level. This command runs in an interactive manner so that you get an opportunity to verify the accounts being removed. All the specified role with permanent access will get removed except your access.

      ```PowerShell
      Set-AzSKPIMConfiguration -RemovePermanentAssignments `
                              -ManagementGroupId <ManagementGroupId> `
                              -RoleNames "Contributor,Owner" `
                              -RemoveAssignmentFor AllExceptMe
                              -DoNotOpenOutputFolder
      ```


 6. <h4> Extend PIM assignments for expiring assignments (-ExtendExpiringAssignments) </h4>
	 Use this command to extend PIM eligible assignments that are about to expire in n days

    <b>Example 1: </b>Extend Owner PIM roles that are to be expired in 10 days. This command runs in an interactive manner in order to verify the assignments being extended.

      ```PowerShell
      Set-AzSKPIMConfiguration -ExtendExpiringAssignments `
                              -ManagementGroupId <ManagementGroupId> `
                              -RoleName "Owner" `
                              -ExpiringInDays 10
			                  -DurationInDays 30 # The duration in days for expiration to be extended by
                              -DoNotOpenOutputFolder
      ```
      
      <b>Example 2: </b> Use *'-Force'* parameter to run the command in non-interactive mode. This command will extend expiry of  'Owner' PIM roles that are about to be expired in 10 days by skipping the verification step.

      ```PowerShell
      Set-AzSKPIMConfiguration -ExtendExpiringAssignments `
                              -ManagementGroupId <ManagementGroupId> `
                              -RoleName "Owner" `
                              -ExpiringInDays 10
			                  -DurationInDays 30 # The duration in days for expiration to be extended by
                              -Force
      ```

       <b>Example 3: </b> Extend Owner PIM roles that are to be expired in 10 days specific to principal names.

      ```PowerShell
      Set-AzSKPIMConfiguration -ExtendExpiringAssignments `
                              -ManagementGroupId <ManagementGroupId> `
                              -RoleName "Owner" `
                              -ExpiringInDays 10
			                  -PrincipalNames "abc@microsoft.com,def@microsoft.com"  
      ```

7. <h4> Configure role settings for role on an Azure resource (-ConfigureRoleSettings) </h4>
	Use this command to configure a  PIM role settings like maximum role assignment duration on a resource, mfa requirement upon activation etc.
    
     The command currently supports configuring the following settings:

      a. *For Eligible Assignment Type*: Maximum assignment duration, maximum activation duration, requirement of justification upon activation, requirement of mfa upon activation and applying conditional access policies during activation.

      b. *For Active Assignment Type*: Maximum active assignment duration, requirement of justification on assignment, requirement of mfa on assignment.
      
      <b>Example 1: </b> Configure 'Owner' PIM role on a Management Group for Eligible assignment type, to let maximum activation duration be 12 hours.

      ```PowerShell
      Set-AzSKPIMConfiguration  -ConfigureRoleSettings `
                                -ManagementGroupId <ManagementGroupId> `
                                -RoleNames "Owner" `
                                -MaximumActivationDuration 12`
                                -ExpireEligibleAssignmentsInDays 90 `
                                -RequireJustificationOnActivation $true
                                -RequireMFAOnActivation $true
                                -DoNotOpenOutputFolder`
      ```
      
	 <b>Example 2: </b> Configure 'Owner' PIM role on a Management Group for Eligible assignment type, to apply conditional access policy while activation.
	    Note: Currently application of both MFA and conditional policy on the same role is not supported. Either of them should be applied to a given role. 

      ```PowerShell
      Set-AzSKPIMConfiguration  -ConfigureRoleSettings `
                                -ManagementGroupId <ManagementGroupId> `
                                -RoleNames "Owner" `
                                -ApplyConditionalAccessPolicyForRoleActivation $true
                                -DoNotOpenOutputFolder`
      ```
      <b>Example 3: </b> Configure 'Reader' PIM role on a Management Group for Active assignment type, to let maximum assignment duration be 15 days. 

      ```PowerShell
      Set-AzSKPIMConfiguration  -ConfigureRoleSettings `
                                -ManagementGroupId <ManagementGroupId> `
                                -RoleNames "Reader" `
                                -ExpireActiveAssignmentsInDays 15 `
                                -RequireJustificationOnActiveAssignment $false `
                                -RequireMFAOnActiveAssignment $true `
                                -DoNotOpenOutputFolder
      ```

## AzSK: Credential hygiene helper cmdlets

To help avoid availability disruptions due to credential expiry, AzSK has introduced cmdlets that will help you track and get notified about important credentials across your subscription. AzSK now offers a register-and-track solution to help monitor the last update of your credentials. This will help you periodically track the health of your credentials which are nearing expiry/need rotation.

AzSK has also introduced the concept of ‘credential groups’ wherein a set of credentials belonging to a specific application/functionality can be tracked together for expiry notifications.

<b>NOTE:</b>
      Ensure you have atleast 'Contributor' access on the subscription before running the below helper commands. To configure expiry notifications for the tracked credentials, ensure you have 'Owner' access on the subscription.

### Use New-AzSKTrackedCredential to onboard a credential for tracking 

```PowerShell
   New-AzSKTrackedCredential -SubscriptionId '<Subscription Id>' `
                             -CredentialName '<Friendly name of the credential>' `
                             -CredentialLocation '<Custom|AppService|KeyVault>' `
                             -RotationIntervalInDays <Int> `
                             -NextExpiryInDays <Int> `
                             [-CredentialGroup '<Action group name for configuring alerts>'] `
                             -Comment '<Comment to capture the credential info>'    
```
|Param Name|Purpose|Required?|Allowed Values|
|----|----|----|----|
|SubscriptionId|Subscription ID of the Azure subscription in which the to-be-tracked credential resides.|TRUE|None|
|CredentialName|Friendly name for the credential.|TRUE|None|
|CredentialLocation|Host location of the credential.|TRUE|Custom/AppService/KeyVault|
|RotationIntervalInDays|Time in days before which the credential needs an update.|TRUE|Integer|
|NextExpiryInDays|Time in days for the next expiry of the credential.|TRUE|Integer|
|CredentialGroup|(Optional) Name of the action group to be used for expiry notifications|FALSE|Valid action group name.|
|Comment|Comment to capture more information about the credential for the user for future tracking purposes.|TRUE|None|

> <b>NOTE 1:</b>
      > For credential location type 'AppService', you will have to provide app service name, resource group, app config type (app setting/connection string) & app config name. Make sure you have the required access on the resource.

> <b>NOTE 2:</b>
      > For credential location type 'KeyVault', you will have to provide key vault name, credential type (key/secret) & credential name. Make sure you have the required access on the resource.

> <b>NOTE 3:</b>
      > Use credential location type 'Custom', if the credential doesn't belong to an appservice or key vault.

### Use Get-AzSKTrackedCredential to list the onboarded credential(s) 

```PowerShell
   Get-AzSKTrackedCredential -SubscriptionId '<Subscription Id>' [-CredentialName '<Friendly name of the credential>'] [-DetailedView]
```
> <b>NOTE:</b>
      > Not providing credential name will list all the AzSK-tracked credentials in the subscription. Use '-DetailedView' flag to list down detailed metadata about the credentials.

### Use Update-AzSKTrackedCredential to update the credential settings and reset the last updated timestamp

```PowerShell
    Update-AzSKTrackedCredential -SubscriptionId '<Subscription Id>' `
                                 -CredentialName '<Friendly name of the credential>' `
                                 [-RotationIntervalInDays <Int>] `
                                 [-CredentialGroup '<Action group name for configuring alerts>'] `
                                 [-ResetLastUpdate] `
                                 -Comment '<Comment to capture the credential info>'                              
```

> <b>NOTE:</b>
      > Use '-ResetLastUpdate' to reset the last update time to current timestamp. 

### Use Remove-AzSKTrackedCredential to deboard a credential from AzSK tracking 

```PowerShell
   Remove-AzSKTrackedCredential -SubscriptionId '<Subscription Id>' [-CredentialName '<Friendly name of the credential>'] [-Force]
```
### Use New-AzSKTrackedCredentialGroup to configure email alerts to notify users about AzSK-tracked credentials that are about to expire (<= 7 days) or have already expired. 

```PowerShell
   New-AzSKTrackedCredentialGroup -SubscriptionId '<Subscription Id>' -AlertEmail '<Alert email id>'
```
