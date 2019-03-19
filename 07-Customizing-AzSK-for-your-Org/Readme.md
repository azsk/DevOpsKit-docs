
> <b>NOTE:</b>
> This article has been updated to use the new Azure PowerShell Az module. To learn more about the new Az module and AzureRM compatibility, see [Introducing the new Azure PowerShell Az module](https://docs.microsoft.com/en-us/powershell/azure/new-azureps-module-az).

# Customizing AzSK for your organization
 
### [Overview](Readme.md#overview-1)
 - [When and why should I set up org policy?](Readme.md#when-and-why-should-i-setup-org-policy)
 - [How does AzSK use online policy?](Readme.md#how-does-azsk-use-online-policy)

### [Setting up org policy](Readme.md#setting-up-org-policy-1)
 - [What happens during org policy setup?](Readme.md#what-happens-during-org-policy-setup)
 - [The org policy setup command: Install-AzSKOrganizationPolicy](Readme.md#the-org-policy-setup-command-install-azskorganizationpolicy)
 - [First-time policy setup - an example](Readme.md#first-time-policy-setup---an-example)
 
### [Modifying and customizing org policy](Readme.md#modifying-and-customizing-org-policy-1)
 - [Common scenarios for org policy customization](Readme.md#common-scenarios-for-org-policy-customization)  
 - [Using CICD Extension with custom org-policy](Readme.md#using-cicd-extension-with-custom-org-policy)
 - [Next Steps](Readme.md#next-steps)


### [Testing and troubleshooting org Policy](Readme.md#testing-and-troubleshooting-org-policy-1)
 - [Testing the overall policy setup](Readme.md#testing-the-overall-policy-setup)
 - [Troubleshooting common issues](Readme.md#troubleshooting-common-issues)
 
### [Create Cloud Security Compliance Report for your org in PowerBI](Readme.md#create-cloud-security-compliance-report-for-your-org-in-powerbi-1)

### [Frequently Asked Questions](Readme.md#frequently-asked-questions)

----------------------------------------------------------------

## Overview

#### When and why should I setup org policy

When you run any scan command from the AzSK, it relies on JSON-based policy files to determine various 
parameters that effect the behavior of the command it is about to run. These policy files are downloaded 'on the fly' from a policy 
server. When you run the public version of the toolkit, the policy files are accessed from a CDN endpoint 
that is managed by the AzSK team. Thus, whenever you run a scan from a vanilla installation, 
AzSK accesses the CDN endpoint to get the latest policy configuration and runs the scan using 
it. 

The JSON inside the policy files dictate the behavior of the security scan. 
This includes things such as:
 - Which set of controls to evaluate?
 - What control set to use as a baseline?
 - What settings/values to use for individual controls? 
 - What messages to display for recommendations? Etc.


Note that the policy files needed for security scans are downloaded into each PS session for **all** 
AzSK scenarios. That is, apart from manually-run scans from your desktop, this same behavior happens 
if you include the AzSK SVTs Release Task in your CICD pipeline or if you setup Continuous Assurance. 
Also, the AzSK policy files on the CDN are based on what we use internally in Core Services Engineering 
(CSE) at Microsoft. We also keep them up to date from one release to next.

<!--![Org Policy - The big picture](../Images/07_OrgPolicy_Big_Picture.PNG)-->

<img src="../Images/07_OrgPolicy_Big_Picture.PNG" width="80%" />


 
 While the out-of-box files on CDN may be good for limited use, in many contexts you may want to "customize" 
the behavior of the security scans for your environment. You may want to do things such as: (a) enable/disable 
some controls, (b) change control settings to better match specific security policies within your org, 
(c) change various messages, (d) add additional filter criteria for certain regulatory requirements that teams 
in your org can leverage, etc. When faced with such a need, you need a way to create and manage 
a dedicated policy endpoint customized to the needs of your environment. The organization policy setup feature 
helps you do that in an automated fashion. 

In this document, we will look at how to setup an organization-specific policy endpoint, how to make changes 
to and manage the policy files and how to accomplish various common org-specific policy/behavior customizations 
for the AzSK.

#### How does AzSK use online policy?

Let us look at how policy files are leveraged in a little more detail. 

When you install AzSK, it downloads the latest AzSK module from the PS Gallery. Along with this module there
is an *offline* set of policy files that go in a sub-folder under the %userprofile%\documents\WindowsPowerShell\Modules\AzSK\<version> folder. 
It also places (or updates) an AzSKSettings.JSON file in your %LocalAppData%\AzSK folder. It is this latter 
file that contains the policy endpoint (or policy server) URL that is used by all local commands. 

Whenever any command is run, AzSK uses the policy server URL to access the policy endpoint. It first downloads 
a 'metadata' file that contains information about what other files are available on the policy server. After 
that, whenever AzSK needs a specific policy file to actually perform a scan, it loads the local copy of 
the policy file into memory and 'overlays' any settings *if* the corresponding file was also found on the 
server-side. 

It then accesses the policy to download a 'metadata' file that helps it determine the actual policy files list 
that is present on the server. Thereafter, the scan runs by overlaying the settings obtained from the server with 
the ones that are available in the local installation module folder. This means that if there hasn't been anything 
overridden for a specific feature (e.g., Storage), then it won't find a policy file for that listed in the server
 metadata file and the local policy file for that feature will get used. 

The image below shows this flow with inline explanations: 

<!--![Effective org Policy Evaluation](../Images/07_OrgPolicy_Online_Policy_Flow.PNG)-->
<img alt="Effective Org Policy Evaluation" src="../Images/07_OrgPolicy_Online_Policy_Flow.PNG" width="60%" />


## Setting up org policy

#### What happens during org policy setup?

At a high level, the org policy setup support for AzSK does the following:
 - Sets up a storage account to hold various policy artifacts in the subscription you want to use for hosting 
your policy endpoint. (This should be a secure, limited-access subscription to be used only for managing your 
org's AzSK policy.)
 - Uploads the minimum set of policy files required to bootstrap your policy server.
 - Sets up an Application Insights telemetry account in the subscription so as to facilitate visibility of control 
scan/telemetry events in your central subscription. (This is where control 'pass/fail' events will get sent when other 
people in the org start using the version of AzSK customized for your org.)
 - Creates a special folder (or uses one specified by you) for storing a local copy of all customizations made to policy.
 - Creates an org-specific (customized) installer that others in your org will use to install and configure the AzSK 
per your org's policy.

Let us now look at the command that will help with the above and a few examples…

#### The org policy setup command (`Install-AzSKOrganizationPolicy`)

This command helps the central security team of an organization to customize the behavior of various functions
and security controls checked by AzSK.  

As discussed in previous sections, AzSK runtime behavior is mainly controlled through JSON-based policy files 
which have a predefined schema. The command helps in creating a policy store and other required components to
host and maintain a custom set of policy files that override the default AzSK behavior. 

| Parameter| Description | Required? | Default Value | Comments |
| ---- | ---- | ---- |----|---- |
| SubscriptionId | Subscription ID of the Azure subscription in which organization policy store will be created. | Yes | None | 
|OrgName | The name of your organization. The value will be used to generate names of Azure resources being created as part of policy setup. This should be alphanumeric. | Yes | None |
| DepartmentName | The name of a department in your organization. If provided, this value is concatenated to the org name parameter. This should be alphanumeric. | No | None |
| PolicyFolderPath | The local folder in which the policy files capturing org-specific changes will be stored for reference. This location can be used to manage policy files. | No | User Desktop |
| ResourceGroupLocation | The location in which the Azure resources for hosting the policy will be created. | No | EastUS2 | To obtain valid locations, use Get-AzLocation cmdlet |
| ResourceGroupName | Resource Group name where policy resources will be created. | No | AzSK-\<OrgName>-\<DepName>-RG | Custom resource group name for storing policy resources. **Note:** ResourceGroupName, StorageAccountName and AppInsightName must be passed together to create custom resources |
| StorageAccountName | Name for policy storage account | No | azsk-\<OrgName>-\<DepName>-sa | |
| AppInsightName | Name for application insight resource where telemetry data will be pushed | No | AzSK-\<OrgName>-<DepName>-AppInsight | Custom resource group name for storing policy resources.  |
| AppInsightLocation | The location in which the AppInsightLocation resource will be created. | No | EastUS |  |
#### First-time policy setup - an example
The following example will set up policies for IT department of Contoso organization. 

You must be an 'Owner' or 'Contributor' for the subscription in which you want to host your org's policy artefacts.
Also, make sure that that the org name and dept name are purely alphanumeric and their combined length is less than 19 characters.

```PowerShell
Install-AzSKOrganizationPolicy -SubscriptionId <SubscriptionId> `
           -OrgName "Contoso" `
           -DepartmentName "IT" `
           -PolicyFolderPath "D:\ContosoPolicies"
```

Note:

For Azure environments other than Azure Cloud, don't forget to provide ResourceGroupLocation as the default value won't work in those environments.

The execution of command will create following resources in the subscription (if they don't already exist): 
1. Resource Group (AzSK-Contoso-IT-RG) - AzSK-\<OrgName>-\<DepartmentName>-RG. 
2. Storage Account (azskcontosoitsa) - azsk\<OrgName>\<DepartmentName>sa.
3. Application Insight (AzSK-Contoso-IT-AppInsight) - AzSK-\<OrgName>-\<DepartmentName>-AppInsight.
4. Monitoring dashboard (DevOpsKitMonitoring (DevOps Kit Monitoring Dashboard [Contoso-IT])) 

> **Note:** You must not have any other resources than created by setup command in Org policy resource group.

It will also create a very basic 'customized' policy involving below files uploaded to the policy storage account.

##### Basic files setup during Policy Setup 
 
| File | Container | Description  
| ---- | ---- | ---- |
| AzSK-EasyInstaller.ps1 | installer | Org-specific installation script. This installer will ensure that anyone who installs AzSK using your 'iwr' command not only gets the core AzSK module but their local installation of AzSK is also configured to use org-specific policy settings (e.g., policy server URL, telemetry key, etc.) |
| AzSK.Pre.json | policies  | This file contains a setting that controls/defines the AzSK version that is 'in effect' at an organization. An org can use this file to specify the specific version of AzSK that will get used in SDL/CICD/CA scenarios at the org for people who have used the org-specific 'iwr' to install and configure AzSK.<br/> <br/>  **Note:** During first time policy setup, this value is set with AzSK version available on the client machine that was used for policy creation. Whenever a new AzSK version is released, the org policy owner should update the AzSK version in this file with the latest released version after performing any compatibility tests in a test setup.<br/> You can get notified of new releases by following the AzSK module in PowerShell Gallery or release notes section [here](https://azsk.azurewebsites.net/ReleaseNotes/RN180814.html).  
| RunbookCoreSetup.ps1 | policies  | Used in Continuous Assurance to setup AzSK module
| RunbookScanAgent.ps1 | policies  | Used in Continuous Assurance to run daily scan 
| AzSk.json | policies | Includes org-specific message, telemetry key, InstallationCommand, CASetupRunbookURL etc.
| ServerConfigMetadata.json | policies | Index file with list of policy files.  


At the end of execution, an 'iwr' command line will be printed to the console. This command leverages the org-specific
 installation script from the storage account for installing AzSK.

```PowerShell
iwr 'https://azskcontosoitsa.blob.core.windows.net/installer/AzSK-EasyInstaller.ps1' -UseBasicParsing | iex 
```


Monitoring dashboard gets created along with policy deployment and it lets you monitor the operations for various DevOps Kit workflows at your org.(e.g., CA issues, anomalous control drifts, evaluation errors, etc.). 

You will be able to see the dashboard at the home page of Azure Portal. If not, you can navigate to below path see the dashboard

Go to Azure Portal --> Select "Browse all dashboards" in dashboard dropdown -->  Select type "Shared Dashboard" --> Select subscription where policy is setup -->Select "DevOps Kit Monitoring Dashboard [OrgName]"

Below is snapshot of the dashboard
<img alt="Effective Org Policy Evaluation" src="../Images/07_OrgPolicy_MonitoringDashboard.png" />


## Modifying and customizing org policy 

All subsequent runs of the (same) command above will pick up the JSON files from local PolicyFolderPath and upload 
to policy store, provided the values for OrgName and DepartmentName remain unchanged. (This is required
because the command internally evaluates the locations of various artifacts based on these values.) To modify policy
or add more policy customizations, we shall be reusing the same command as used for first-time setup or update command (*Update-AzSKOrganizationPolicy*).

> **Note**: ServerConfigMetadata.json and AzSK-EasyInstaller.ps1 will always get overwritten on the subsequent run of the command. 

If you don't have existing configured Org policy, you can download policy to your local machine with below command

```PowerShell
Get-AzSKOrganizationPolicyStatus -SubscriptionId <SubscriptionId> `
           -OrgName "Contoso" `
           -DepartmentName "IT" `
           -DownloadPolicy `
           -PolicyFolderPath "D:\ContosoPolicies"
	   
#If custom resource group is used

Get-AzSKOrganizationPolicyStatus -SubscriptionId <SubscriptionId> `
           -OrgName "Contoso-IT" `
           -ResourceGroupName "ContosoResourceGoupName" `
           -StorageAccountName "contosostorageaccountname" `
           -DownloadPolicy `
           -PolicyFolderPath "D:\ContosoPolicies"

```
	
#### Common scenarios for org policy customization

In this section let us look at typical use cases for org policy customization and how to accomplish them. 
We will cover the following:

a. Changing the default 'Running AzSK using…' message  
b. Changing a global setting for some control
c. Changing/customizing a server baseline policy set
d. Customizing specific controls for a service SVT (e.g., Storage.json)
   1. Turning controls On/Off
   2. Changing Recommendation Text
   3. Changing Severity, etc.
   4. Disable attestation
e. Customizing Severity labels
f. Changing ARM policy/Alerts set (coming soon…)
g. Changing RBAC mandatory/deprecated lists (coming soon…)


> Note: To edit policy JSON files, use a friendly JSON editor such as Visual Studio Code. It will save you lot of
> debugging time by telling you when objects are not well-formed (extra commas, missing curly-braces, etc.)! This
> is key because in a lot of policy customization tasks, you will be taking existing JSON objects and removing
> large parts of them (to only keep the things you want to modify).

The general workflow for all policy changes will be similar and involve the following steps:

 1) Go to the folder you have used (or the org-setup command auto-generated) for your org-customized policies
 2) Make any modifications to existing files (or add additional policy files as required)
 3) Make sure that there's an entry in the ServerConfigMetadata.json file for all the files you have modified
 (Make sure that this entry matches the file names with correct case!)
 4) Run the policy update command to upload all artifacts to the policy server
 5) Test in a fresh PS console that the policy change is in effect. (Policy changes do not require re-installation of AzSK.)

Note that you can upload policy files from any folder (e.g., a clone of the originally used/created one). It just needs to 
have the same folder structure as the default one generated by the first-time policy setup and you must specify
the folder path using the '-PolicyFolderPath' parameter.

Because policy on the server works using the 'overlay' approach, the corresponding file on the server
only needs to have the specific changes that are required (plus some identifying elements in some cases).

Lastly, note that when making modifications we will **never** edit the files that came with the AzSK installation. 
We will create copies of the files we wish to edit, place them in our org-policy folder and make requisite
modifications there.

##### a) Changing the default `'Running AzSK using...'` message
Whenever any user in your org runs an AzSK command after having installed AzSK using your org-specific installer, 
they should see a message such as the following (note the 'Contoso-IT') indicating that AzSK is running using an org-specific policy:

    Running AzSK cmdlet using Contoso-IT policy

Notice that here, the default (first-time) org policy setup injects the 'Contoso-IT' based on the OrgName and
the DeptName that you provided when you setup your org policy server. (When users are running without your 
org policy correctly setup, they will see the 'Running AzSK cmdlet using generic (org-neutral)
policy' message which comes from the AzSK public CDN endpoint.)

This message resides in the AzSk.json policy file on the server and the AzSK *always* displays the text 
from the server version of this file.

You may want to change this message to something more detailed. (Or even use this as a mechanism to notify all users
within the org about something related to AzSK that they need to attend to immediately.) 
In this example let us just make a simple change to this message. We will just add '*' characters on either side 
of the 'Contoso-IT' so it stands out a bit.

###### Steps:

 i) Open the AzSk.json from your local org-policy folder

 ii) Edit the value for "Policy Message" field by adding 3 '*' characters on each side of 'Contoso-IT' as under:
```
    "PolicyMessage" : "Running AzSK cmdlet using *** Contoso-IT *** policy"
```
 iii) Save the file
 
 iv) Run the policy setup command (the same command you ran for the first-time setup)

###### Testing:

The updated policy is now on the policy server. You can ask another person to test this by running any AzSK cmdlet
(e.g., Get-AzSKInfo) in a **fresh** PS console. When the command starts, it will show an updated message as in the 
image below:

![Org Policy - Changed Message](../Images/07_OrgPolicy_Chg_Org_Policy_Msg_PS.PNG) 

This change will be immediately in effect across your organization. Anyone running AzSK commands (in fresh PS sessions)
should see the new message. 

##### b) Changing a control setting for specific controls 
Let us now change some numeric setting for a control. A typical setting you may want to tweak is the count of
maximum owners/admins for your org's subscriptions that is checked in one of the subscription security controls. (The out-of-box default is 5.)

This setting resides in a file called ControlSettings.json. Because the first-time org policy setup does not
customize anything from this, we will first need to copy this file from the local AzSK installation.

The local version of this file should be in the following folder:
```PowerShell
    %userprofile%\Documents\WindowsPowerShell\Modules\AzSK\<version>\Framework\Configurations\SVT
```

   ![Local AzSK Policies](../Images/07_OrgPolicy_Local_Policy_Folder.PNG) 
 
Note that the 'Configurations' folder in the above picture holds all policy files (for all features) of AzSK. We 
will make copies of files we need to change from here and place the changed versions in the org-policy folder. 
Again, you should **never** edit any file directly in the local installation policy folder of AzSK. 
Rather, **always** copy the file to your own org-policy folder and edit it there.

###### Steps:

 i) Copy the ControlSettings.json from the AzSK installation to your org-policy folder
 
 ii) Remove everything except the "NoOfApprovedAdmins" line while keeping the JSON object hierarchy/structure intact
    ![Edit Number of Admins](../Images/07_OrgPolicy_Chg_Admin_Count.PNG) 

 iii) Save the file
 
 iv) Edit the ServerConfigMetadata.json file in the org-policy folder and create an entry for this file (if not already there)

![Entry in ServerConfigMetadata.json](../Images/07_OrgPolicy_Chg_SCMD_Entry.PNG) 

```JSON
{
    "OnlinePolicyList" : [
        {
            "Name" : "AzSk.json"
        }, 
        {
            "Name" : "ControlSettings.json"
        }
    ]
}
```

 v) Rerun the policy setup command (the same command you ran for the first-time setup)
 
###### Testing: 

Anyone in your org can now start a fresh PS console and the result of the evaluation of the number of owners/admins control in 
the subscription security scan (Get-AzSKSubscriptionSecurityStatus) should reflect that the new setting is in 
effect. (E.g., if you change the max count to 3 and they had 4 owners/admins in their subscription, then the control
result will change from 'Passed' to 'Failed'.)


##### c) Creating a custom control 'baseline' for your org
Note that a powerful capability of AzSK is the ability for an org to define a baseline control set on the policy server
that can be leveraged by all individuals in the org (and in other AzSK scenarios like CICD, CA, etc.) via the "-UseBaselineControls" parameter
during scan commands. 

By default, when someone runs against the CDN endpoint, the "-UseBaselineControls" parameter leverages the set of
controls listed as baseline in the ControlSettings.json file present on CDN. 

However, once you have set up an org policy server for your organization, the CDN endpoint is no more in use. (As a 
side note, you can always 'simulate' CDN-based/org-neutral execution by removing or renaming your 
`%localappdata%\Microsoft\AzSK\AzSKSettings.json` file.) Thus, after org policy is setup, there will 
not be a 'baseline' control set defined for your organization. Indeed, if you run any of the scan commands using the
"-UseBaselineControls" switch, you will see that the switch gets ignored and **all** controls for respective 
resources are evaluated. 

To support the baseline controls behavior for your org, you will need to define your baseline in the ControlSettings.json
file. Here are the steps...

###### Steps: 

(We will assume you have tried the max owner/admin count steps in (b) above and edit the ControlSettings.json 
file already present in your org policy folder.)

 i) Edit the ControlSettings.json file to add a 'BaselineControls' object as per below:
 
```JSON
{
   "NoOfApprovedAdmins": 1,
   "BaselineControls": {
      "ResourceTypeControlIdMappingList": [
         {
            "ResourceType": "AppService",
            "ControlIds": [
               "Azure_AppService_DP_Dont_Allow_HTTP_Access",
               "Azure_AppService_AuthN_Use_AAD_for_Client_AuthN"
            ]
         },
         {
            "ResourceType": "Storage",
            "ControlIds": [
               "Azure_Storage_AuthN_Dont_Allow_Anonymous",
               "Azure_Storage_DP_Encrypt_In_Transit"
            ]
         }
      ],
      "SubscriptionControlIdList": [
         "Azure_Subscription_AuthZ_Limit_Admin_Owner_Count",
         "Azure_Subscription_AuthZ_Dont_Use_NonAD_Identities",
         "Azure_Subscription_Config_Azure_Security_Center"
      ]
   }
}
```

> Notice how, apart from the couple of extra elements at the end, the baseline set is pretty much a list of 'ResourceType'
and 'ControlIds' for that resource...making it fairly easy to customize/tweak your own org baseline. 
> Here the name and casing of the resource type name must match that of the policy JSON file for the corresponding 
> resource's JSON file in the SVT folder and the control ids must match those included in the JSON file. 

> Note: Here we have used a very simple baseline with just a couple of resource types and a very small control set.
> A more realistic baseline control set will be more expansive. 
> <!-- TODO - add CDN-baseline pointer --> 
    
 ii) Save the ControlSettings.json file
 
 iii) Confirm that an entry for ControlSettings.json is already there in the ServerConfigMetadata.json file. (Else see step-iii in (c) above.)
 
 iv) Run the policy setup command (the same command you ran for the first-time setup)

###### Testing:

To test that the baseline controls set is in effect, anyone in your org can start a fresh PS console and run the subscription
and resources security cmdlets with the `-UseBaselineControls` parameter. You will see that regardless of the actual
types of Azure resources present in their subscriptions, only the ones mentioned in the baseline get evaluated in the scan
and, even for those, only the baseline controls get evaluated.


##### d) Customizing specific controls for a service 

In this example, we will make a slightly more involved change in the context of a specific SVT (Storage). 

Imagine that you want to turn off the evaluation of some control altogether (regardless of whether people use the `-UseBaselineControls` parameter or not).
Also, for another control, you want people to use a recommendation which leverages an internal tool the security team
in your org has developed. Let us do this for the Storage.json file. Specifically, we will:
1. Turn off the evaluation of `Azure_Storage_Audit_Issue_Alert_AuthN_Req` altogether.
2. Modify severity of `Azure_Storage_AuthN_Dont_Allow_Anonymous` to `Critical` for our org (it is `High` by default).
3. Change the recommendation people in our org will follow if they need to address an issue with the `Azure_Storage_DP_Encrypt_In_Transit` control.
4. Disable attestation of `Azure_Storage_DP_Restrict_CORS_Access` by adding 'ValidAttestationStates' object.

###### Steps: 
 
 i) Copy the Storage.json from the AzSK installation to your org-policy folder

 ii) Remove everything except the ControlID, the Id and the specific property we want to modify as discussed above. 

 iii) Make changes to the properties of the respective controls so that the final JSON looks like the below. 

```JSON
{
  "Controls": [
   {
      "ControlID": "Azure_Storage_AuthN_Dont_Allow_Anonymous",
      "Id": "AzureStorage110",
      "ControlSeverity": "Critical"
   },
   {
      "ControlID": "Azure_Storage_Audit_Issue_Alert_AuthN_Req",
      "Id": "AzureStorage120",
      "Enabled": false
   },
   {
      "ControlID": "Azure_Storage_DP_Encrypt_In_Transit",
      "Id": "AzureStorage160",
      "Recommendation": "**Note**: Use our Contoso-IT-EncryptInTransit.ps1 tool for this!"
   },
   {
      "ControlID": "Azure_Storage_DP_Restrict_CORS_Access",
      "ValidAttestationStates" : ["None"]
   }
  ]
}
```
> Note: The 'Id' field is used for identifying the control for policy merging. We are keeping the 'ControlId'
> field only because of the readability.

 iii) Save the file

 iv) Edit the ServerConfigMetadata.json file in the org-policy folder and create an entry for this file (if not already there)

 It should look something like the below:
```JSON
{
    "OnlinePolicyList" : [
        {
            "Name" : "AzSk.json"
        }, 
        {
            "Name" : "ControlSettings.json"
        }, 
        {
            "Name" : "Storage.json"
        }
    ]
}
```  

 v) Rerun the org policy setup command (the same command you ran for the first-time setup)
 
###### Testing: 
Someone in your org can test this change using the `Get-AzSKAzureServicesSecurityStatus` command on a target
resource group which contains a storage account. If run with the `-UseBaselineControls` switch, you will see that
the anonymous access control shows as `Critical` in the output CSV and the GRS control recommendation has changed to
the custom (internal tool) recommendation you wanted people in your org to follow. The image below shows the CSV file
from a baseline scan after this change: 

![Changed Storage controls - Baseline Scan](../Images/07_OrgPolicy_Chg_SVT_JSON.PNG) 

Likewise, if you run without the `-UseBaselineControls` parameter, you will see that the anon-alert control does not get evaluated and does not
appear in the resulting CSV file. 

##### e) Customizing Severity labels 
Ability to customize naming of severity levels of controls (e.g., instead of High/Medium, etc. one can now have Important/Moderate, etc.) with the changes reflecting in all avenues (manual scan results/CSV, Log Analytics workspace, compliance summaries, dashboards, etc.)

###### Steps: 

(We will assume you have tried the max owner/admin count steps in (b) above and edit the ControlSettings.json 
file already present in your org policy folder.)

 i) Edit the ControlSettings.json file to add a 'ControlSeverity' object as per below:
 
```JSON
{
   "ControlSeverity": {
    "Critical": "Critical",
    "High": "Important",
    "Medium": "Moderate",
    "Low": "Low"
  }
}
```
 ii) Save the file
 
 iii) Run the policy setup command (the same command you ran for the first-time setup)

 ###### Testing: 

Someone in your org can test this change using the `Get-AzSKAzureServicesSecurityStatus`. You will see that
the controls severity shows as `Important` instead of `High` and `Moderate` instead of `Medium` in the output CSV.


## Using CICD Extension with custom org-policy

To set up CICD when using custom org-policy, please follow below steps:
1. Add Security Verification Tests (SVTs) in VSTS pipeline by following the main steps [here](../03-Security-In-CICD#adding-svts-in-the-release-pipeline).
2. Obtain the policy store URl by:
	1. Download the installer file (ps1) from Org specific iwr command. To download file, just open the URL from iwr command.
	```	
	E.g.: iwr 'https://azskxxx.blob.core.windows.net/installer/AzSK-EasyInstaller.ps1' -UseBasicParsing | iex
	```
	2.  Open the downloaded file, find the following variable and copy the URL as below. 
	```	
	[string] $OnlinePolicyStoreUrl = "https://azskxxx.blob.core.windows.net/policies/`$(`$Version)/`$(`$FileName)?sv=2016-05-		31&sr=c&sig=xxx&spr=https&st=2018-01-02T11%3A18%3A37Z&se=2018-07-03T11%3A18%3A37Z&sp=rl" , 
	```
3. Remove the 4 backtick (\`) characters from URL.
```
E.g. https://azskxxx.blob.core.windows.net/policies/$($Version)/$($FileName)?sv=2016-05-31&sr=c&sig=xxx&spr=https&st=2018-01-02T11%3A18%3A37Z&se=2018-07-03T11%3A18%3A37Z&sp=rl
```
4. Add following variables in the release definition in which ‘AzSK Security Verification Tests’ task is added. 
	1. AzSKServerURL = <Modified URL from step 4>.
	2. EnableServerAuth = false 
	
Having set the policy URL along with AzSK_SVTs Task, you can verify if your CICD task has been properly setup by following steps [here](../03-Security-In-CICD#verifying-that-the-svts-have-been-added-and-configured-correctly).


## Next Steps:

Once your org policy is setup, all scenarios/use cases of AzSK should work seamlessly with your org policy server
as the policy endpoint for your org (instead of the default CDN endpoint). Basically, you should be able to do one 
or more of the following using AzSK:

 - People will be able to install AzSK using your special org-specific installer (the 'iwr' install command)
 - Developers will be able to run manual scans for security of their subscriptions and resources (GRS, GSS commands)
 - Teams will be able to configure the AzSK SVT release task in their CICD pipelines
 - Subscription owners will be able to setup Continuous Assurance (CA) from their local machines (**after** they've installed
 AzSK using your org-specific 'iwr' installer locally)
 - Monitoring teams will be able to setup AzSK Log Analytics view and see scan results from CA (and also manual scans and CICD if configured) 
 - You will be able to do central governance for your org by leveraging telemetry events that will collect in the master subscription
 from all the AzSK activity across your org. 

## Testing and troubleshooting org policy

#### Testing the overall policy setup
The policy setup command is fairly lightweight - both in terms of effort/time and in terms of costs incurred. You can test policy using below options

**Option 1:**
    
Validate configuration changes by running AzSK commands using local policy folder.

Step 1: Point AzSK settings to local Org policy folder("D:\ContosoPolicies\"). 
    
```PowerShell
Set-AzSKPolicySettings -LocalOrgPolicyFolderPath "D:\ContosoPolicies\"
```
Step 2: Clear session state and run scan commands (Get-AzSKAzureServicesSecurityStatus and Get-AzSKSubscriptionSecurityStatus) with respective parameters sets like UseBaselineControls,ResourceGroupNames etc.

```PowerShell
Clear-AzSKSessionState
Get-AzSKSubscriptionSecurityStatus -SubscriptionId <SubscriptionId>

Get-AzSKAzureServicesSecurityStatus -SubscriptionId <SubscriptionId> -UseBaselineControls
```    

Step 3: If scan commands are running fine, you can update policy based on parameter set used during installations. If you see some issue in scan commands, you can fix configurations and repeat step 2. 

```PowerShell
Update-AzSKOrganizationPolicy -SubscriptionId <SubscriptionId> `
   -OrgName "Contoso" `
   -DepartmentName "IT" `
   -PolicyFolderPath "D:\ContosoPolicies"
```

```PowerShell
Update-AzSKOrganizationPolicy -SubscriptionId <SubscriptionId> `
   -OrgName "Contoso-IT" `           
   -ResourceGroupName "Contoso-IT-RG" `
   -StorageAccountName "contosoitsa" `
   -AppInsightName "ContosoITAppInsight" `
   -PolicyFolderPath "D:\ContosoPolicies"
```

Step 4: Validate if policy is correctly uploaded and there is no missing mandatory policies using policy health check command

```PowerShell
Get-AzSKOrganizationPolicyStatus -SubscriptionId <SubscriptionId> `
   -OrgName "Contoso" `
   -DepartmentName "IT"
```

Step 5: If all above steps works fine. You can point your AzSK setting to online policy server by running "IWR" command generated at the end of *Update-AzSKOrganizationPolicy*


**Option 2:**

you set up a 'Staging' environment where you can do all pre-testing of policy setup, policy changes, etc. A limited number of 
people could be engaged for testing the actual end user effects of changes before deploying them broadly. 
Also, you can choose to retain the staging setup or just re-create a fresh one for each major policy change.


**Note:**
It is always recommendated to validate health of Org policy for mandatory configurations and policy schema syntax issues using below command. You can review the failed checks and follow the remedy suggested.

```PowerShell
Get-AzSKOrganizationPolicyStatus -SubscriptionId <SubscriptionId> `
           -OrgName "Contoso" `
           -DepartmentName "IT"
```

If you have used customized resource names, you can use below parameter sets to run health check

```PowerShell
Get-AzSKOrganizationPolicyStatus -SubscriptionId <SubscriptionId> `
           -OrgName "Contoso-IT" `
           -ResourceGroupName "RGName" `
           -StorageAccountName "PolicyStorageAccountName" 
```

For your actual (production) policies, we recommend that you check them into source control and use the local close of *that* folder as the location
for the AzSK org policy setup command when uploading to the policy server. In fact, setting things up so that any policy
modifications are pushed to the policy server via a CICD pipeline would be ideal. (That is how we do it at CSE.)

	
#### Troubleshooting common issues 
Here are a few common things that may cause glitches and you should be careful about:

- Make sure you use exact case for file names for various policy files (and the names must match case-and-all
with the entries in the ServerConfigMetadata.json file)
- Make sure that no special/BOM characters get introduced into the policy file text. (The policy upload code does scrub for
a few known cases, but we may have missed the odd one.)
- Don't forget to make entries in ServerConfigMetadata.json for all files you have changed.
- Note that the policy upload command always generates a fresh installer.ps1 file for upload. If you want to make changes to 
that, you may have to keep a separate copy and upload it. (We will revisit this in future sprints.)

## Create Cloud Security Compliance Report for your org in PowerBI
Once you have an org policy setup and running smoothly with multiple subscriptions across your org being scanned using your policy, you will need a solution that provides visibility to security compliance for all the subscriptions across your org. This will help you drive compliance/risk governance initiatives for your organization. 

When you setup your org policy endpoint, one of the things that happens is creation of an Application Insights workspace for your setup. After that, whenever someone performs an AzSK scan for a subscription that is configured to use your org policy, the scan results are sent (as 'security' telemetry) to your org's Application Insights workspace. Because this workspace receives scan events from all such subscriptions, it can leveraged to generate aggregate security compliance views for your cloud-based environments. In the steps below, we will look at how a PowerBI-based compliance dashboard can be created and deployed in a matter of minutes starting with a template dashboard that ships with the AzSK. All you need apart from the Application Insights instance is a CSV file that provides a mapping of your organization hierarchy to subscription ids (so that we know which team/service group owns each subscription).

> Note: This is a one-time activity with tremendous leverage as you can use the resulting dashboard (example below) towards driving security governance activities over an extended period at your organization. 

#### Step 0: Pre-requisites
To create, edit and publish your compliance dashboard, you will need to install the latest version of PowerBI desktop on your local machine. Download it from [here](https://powerbi.microsoft.com/en-us/desktop/).


#### Step 1: Prepare your Org-Subscription Mapping
In this step we will prepare the data file which will be fed to the PowerBI dashboard creation process as the mapping from subscription ids to the org hierarchy within your environment. The file is in a simple CSV form and should appear like the one below. 

> Note: You may want to create a small CSV file with just a few subscriptions for a trial pass and then update it with the full subscription list for your org after getting everything working end-to-end.

A sample template for the CSV file is [here](./TemplateFiles/OrgMapping.csv):

![Org-Sub metadata json](../Images/07_OrgPolicy_PBI_OrgMetadata.PNG) 

The table below describes the different columns in the CSV file and their intent.

| ColumnName  | Description | Required? | Comments |
| ---- | ---- | ---- |---- |
| BGName | Name of business group (e.g., Finance, HR, Marketing, etc.) within your enterprise | Yes |  This you can consider as level 1 hierarchy for your enterprise | 
| ServiceGroupName | Name of Service Line/ Business Unit within an organization | Yes |  This you can consider as level 2 hierarchy for your enterprise | 
| SubscriptionId | Subscription Id belonging to a org/servicegroup | Yes |   | 
| SubscriptionName | Subscription Name | Yes | This should match the actual subscription name. If it does not, then the actual name will be used.  | 
| IsActive | Use "Y" for Active Subscription and "N" for Inactive Subscription  | Yes | This will be used to filter active and inactive subscriptions .| 
| OwnerDetails | List of subscription owners separated by semi-colons (;)  | Yes | These are people accountable for security of the subscription.  | 

> **Note**: Ensure you follow the correct casing for all column names as shown in the table above. The 'out-of-box' PowerBI template is bound to these columns. If you need additional columns to represent your org hierarchy then you may need to modify the template/report as well.


#### Step 2: Upload your mapping to the Application Insights (AI) workspace

In this step we will import the data above into the AI workspace created during org policy setup. 

 **(a)** Locate the AI resource that was created during org policy setup in your central subscription. This should be present under Org Policy resource group. After selecting the AI resource, copy the Instrumentation Key.
 
 **(b)** To push Org Mapping details, copy and execute the script available [here](./Scripts/OrgPolicyPushOrgMappingEvents.txt).

#### Step 3: Create a PowerBI report file
In this section we shall create a PowerBI report locally within PowerBI Desktop using the AI workspace from org policy subscription as the datasource. We will start with a default (out-of-box) PowerBI template and configure it with settings specific to your environment. 

> Note: This step assumes you have completed Step-0 above!

**(a)** Get the ApplicationId for your AI workspace from the portal as shown below:

![capture applicationInsights AppId](../Images/07_OrgPolicy_PBI_OrgMetadata_AI_10.PNG)

**(b)** Download and copy the PowerBI template file from [here](./TemplateFiles/AzSKComplianceReport.pbit) to your local machine.

**(c)** Open the template (.pbit) file using PowerBI Desktop, provide the AI ApplicationId and click on 'Load' as shown below:

![capture applicationInsights AppId](../Images/07_OrgPolicy_PBI_OrgMetadata_AI_11.PNG)

**(d)** PowerBI will prompt you to login to the org policy subscription at this stage. Authenticate using your user account. (This step basically allows PowerBI to import the data from AI into the PowerBI Desktop workspace.)
![Login to AI](../Images/07_OrgPolicy_PBI_OrgMetadata_AI_12.PNG)

Once you have successfully logged in, you will see the AI data in the PowerBI report along with org mapping as shown below: 

![Compliance summary](../Images/07_OrgPolicy_PBI_OrgMetadata_AI_13.PNG)

The report contains 2 tabs. There is an overall/summary view of compliance and a detailed view which can be used to see control 'pass/fail' details for individual subscriptions. An example of the second view is shown below:

![Compliance summary](../Images/07_OrgPolicy_PBI_OrgMetadata_AI_14.PNG)

> TBD: Need to add steps to control access to the detailed view by business group. (Dashboard RBAC.) 

#### Step 4: Publish the PowerBI report to your enterprise PowerBI workspace

**(a)** Before publishing to the enterprise PowerBI instance, we need to update AI connection string across data tables in the PowerBI report. The steps to do this are as below:

[a1] Click on "Edit Queries" menu option.

![Update AI Connection String](../Images/07_OrgPolicy_PBI_OrgMetadata_AI_15.PNG)

[a2] Copy the value of "AzSKAIConnectionString"

![Update AI Connection String](../Images/07_OrgPolicy_PBI_OrgMetadata_AI_16.PNG)

[a3] Replace the value of "AzSKAIConnectionString" with the actual connection string (e.g., AzSKAIConnectionString => "https://api.applicationinsights.io/v1/apps/[AIAppID]/query"). You should retain the "" quotes in the connection string.

![Update AI Connection String](../Images/07_OrgPolicy_PBI_OrgMetadata_AI_17.PNG)

[a4] Repeat this operation for ControlResults_AI, Subscriptions_AI, and ResourceInventory_AI data tables.

[a5] Click on "Close and Apply".

**(b)** You can now publish your PBIX report to your workspace. The PBIX file gets created locally when you click "Publish".

Click on Publish

![Publish PBIX report](../Images/07_OrgPolicy_PBI_OrgMetadata_AI_18.PNG)

Select destination workspace

![Publish PBIX report](../Images/07_OrgPolicy_PBI_OrgMetadata_AI_19.PNG)

Click on "Open [Report Name] in Power BI" 

![Publish PBIX report](../Images/07_OrgPolicy_PBI_OrgMetadata_AI_21.png)

**(c)** Now report got published successfully. You can schedule refresh for report with below steps

Go to Workspace --> Datasets --> Click on "..." --> Click on "Schedule Refresh"

![Publish PBIX report](../Images/07_OrgPolicy_PBI_OrgMetadata_AI_22.png)

Add refresh scheduling timings and click on "Apply"

**Note:** You may not see "Schedule refresh" option if step [a3] and [a4] is not completed successfully.

![Publish PBIX report](../Images/07_OrgPolicy_PBI_OrgMetadata_AI_24.png)


## Frequently Asked Questions

#### I am getting exception "The current subscription has been configured with DevOps kit policy for the '***' Org, However the DevOps kit command is running with a different ('org-neutral') Org policy....."?

When your subscription is running under Org policy, AzSK marks subscription for that Org. If user is running scan commands on that subscription using Org-neutral policy, it will block those commands as that scan/updates can give invalid results against Org policy. You may face this issue in different environments. Below steps will help you to fix issue

**Local Machine:**

- Run “**IWR**" installation command shared by Policy Owner. This will ensure latest version installed with Org policy settings.(**Note:** If you are from CSE, please install the AzSK via instructions at https://aka.ms/devopskit/onboarding so that CSE-specific policies are configured for your installation.)

- Run "*Clear-AzSKSessionState*" followed by any scan command and validate its running with Org policy. It gets dispayed at the start of command execution "Running AzSK cmdlet using ***** policy"

**Continuous Assurance:**

- Run "*Update-AzSKContinuousAssurance*" command with Org policy. This will ensure that continuous assurance setup is configured with Org policy settings.

- After above step, you can trigger runbook and ensure that after job completion, scan exported in storage account are with Org policy. You can download logs and validate it in file under path <YYYYMMDD_HHMMSS_GRS>/ETC/PowerShellOutput.LOG. 
Check for message during start of command "Running AzSK cmdlet using ***** policy"


**CICD:**
- You need to configure policy url in pipeline using step **5** defined [here](https://github.com/azsk/DevOpsKit-docs/tree/master/03-Security-In-CICD#adding-svts-in-the-release-pipeline)

- Make sure that the variables you have configured have correct names and values. You may refer [this table.](https://github.com/azsk/DevOpsKit-docs/blob/master/03-Security-In-CICD/Readme.md#advanced-cicd-scanning-capabilities)

- To validate if pipeline AzSK task is running with Org policy. You can download release logs from pipeline. Expand "AzSK_Logs.zip" --> Open file under path "<YYYYMMDD_HHMMSS_GRS>/ETC/PowerShellOutput.LOG" --> Check for message at the start of command execution "Running AzSK cmdlet using ***** policy"


If you want to run commands with Org-neutral policy only, you can delete tag (AzSKOrgName_{OrgName}) present on AzSKRG and run the commands.

If you are maintaining multiple Org policies and you want to switch scan from one policy to other, you can run Set/Update commands with '-Force' flag using policy you wanted to switch. 

#### Latest AzSK is available but our Org CA are running with older version?

AzSK keeps on adding and enhancing features with different capabilities to monitor Security compliance for Org subscriptions. During these enhancement in new releases, it may include latest features and some breaking changes. To provide smoother upgrade and avoid policy breaks, AzSK provides feature for Org policy to run AzSK with specific version by using configuration present in AzSK.Pre.json. This configuration is referred in multiple places for installing Org supported AzSK version in different environments like Installer (IWR) (Installs AzSK in local machine), RunbookCoreSetup (Install AzSK in CA). You need to update property "CurrentVersionForOrg" in AzSK.Pre.json to latest available version after validating if Org policy is compatible with latest AzSK version.


#### We have configured baseline controls using ControlSettings.json on Policy Store, But Continuous Assurance (CA) is scanning all SVT controls on subscription?

Continuous Assurance (CA) is configured to scan all the controls. We have kept this as a default behavior since Org users often tend to miss out on configuring baseline controls. This behavior is controlled from Org policy. If you observed, there are two files present in policy store, RunbookCoreSetup.ps1 (Responsible to install AzSK) and RunbookScanAgent.ps1 (Performs CA scans and export results to storage account). You can update RunbookScanAgent to make only baseline scan. (By passing -UseBaselineControls parameter to Get-AzSKAzureServicesSecurityStatus and Get-AzSKSubscriptionSecurityStatus commands present in RunbookScanAgent.ps1 file). 

#### Continuous Assurance (CA) is scanning less number of controls as compared with manual scan?
 CA automation account runs with minimum privileges i.e. 'Reader' RBAC permission and cannot scan some controls that require more access.
 Here are a few examples of controls that CA cannot fully scan or can only 'partially' infer compliance for:

Azure_Subscription_AuthZ_Dont_Use_NonAD_Identities - requires Graph API access to determine if an AAD object is an 'external' identity

Azure_Subscription_AuthZ_Remove_Management_Certs - querying for management certs requires Co-Admin permission

Azure_AppService_AuthN_Use_AAD_for_Client_AuthN - often this is implemented in code, so an app owner has to attest this control. Also, any 'security-related' config info is not accessible to the 'Reader' RBAC role.

Azure_CloudService_SI_Enable_AntiMalware - needs co-admin access

Azure_CloudService_AuthN_Use_AAD_for_Client_AuthN - no API available to check this (has to be manually attested)

Azure_Storage_AuthN_Dont_Allow_Anonymous - needs 'data plane' access to storage account (CA SPN being a 'Reader' cannot do 'ListKeys' to access actual data).

In general, we make practice to individual teams to perform scan with high privileged role on regular basis to validate Owner access controls results. If you wanted to scan all controls using continuous assurance, you have to 

- Provide CA SPN's as [Owner/Co-Admin RBAC role](https://docs.microsoft.com/en-us/azure/role-based-access-control/role-assignments-portal#grant-access) at subscription scope and [graph API read permissions](https://docs.microsoft.com/en-us/azure/active-directory/develop/active-directory-integrating-applications#updating-an-application).

- Remove *-ExcludeTags "OwnerAccess"* parameter against scan commands (*Get-AzSKAzureServicesSecurityStatus* and *Get-AzSKSubscriptionSecurityStatus*) present in RunbookScanAgent.ps1 file on policy store. 

#### Is it possible to control default resource group name (AzSKRG) and location (EastUS2) created for AzSK components?
Yes. You can control default resource group name and location using AzSK config present in Org policy. Follow below steps to override default behaviour.

**Steps:**

i) Open the AzSK.json from your local org-policy folder

ii) Add the properties for  as under:

    "AzSKRGName" : "<ResourceGroupName>",
    "AzSKLocation" : "<Location>"

iii) Save the file

iv) Run the policy setup command (the same command you ran for the first-time setup) or update command.


##### Testing:

Run "IWR" in new session (you can ask any other user to run this IWR) to setup policy setting in local. If you have already installed policy using IWR, just run CSS (Clear-AzSKSessionState) followed by command *Set-AzSKSubscriptionSecurity* with required parameters as per [doc](../01-Subscription-Security/Readme.md#azsk-subscription-security-provisioning-1). This will provision AzSK components(Alerts/Storage etc) under new resource group and location.

**Note:** For contineous assurance setup, you need to follow two extra steps.

i) Pass location parameter "AutomationAccountLocation" explicitly during execution of installation command (Install-AzSKContinuousAssurance). 

ii) Update $StorageAccountRG variable ( In RunbookScanAgent.ps1 file present in policy store) value  to AzSKRGName value.


#### How should I protect Org policy with AAD based auth?

Currently basic Org policy setup uses read only SAS token to fetch policy files. You will be able to protect policy based on AAD auth using below steps

1. Setup AAD based API: 

	Create API Service with [AAD auth](https://docs.microsoft.com/en-us/azure/app-service/app-service-mobile-how-to-configure-active-directory-authentication) which will point to and return files from Policy container present under Org policy Store. API URL looks like below

    ```
	https://<APIName>.azurewebsites.net/api/files?version=$Version&fileName=$FileName
    ```

**Note:** Here version and file name are dynamic and passed during execution of AzSK commands. 

2. Update Installer(IWR) with latest policy store url:

	Go to IWR file location(present in policy store --> installer
	--> AzSK-EasyInstaller.ps1) 

	a. Update OnlinePolicyStoreUrl with AD based auth API URL from step 1. (**Note:** Keep tilt(\`) escape character as is)

		https://<APIName>.azurewebsites.net/api/files?version=`$Version&fileName=`$FileName

	b. Search for command "Set-AzSKPolicySettings" in IWR and add parameter "-EnableAADAuthForOnlinePolicyStore"

3. Update local settings to point to latest API:
	
	Run IWR command in local machine PowerShell. This will point your local machine to latest policy store URL and AzSK commands will start using AAD based auth.  
	
4. Update existing CA to point to latest API:

	If CA is already installed on subscriptions. You can just run Update-CA command. This will update runbook to use latest policy store URL.
	
5. Update CICD task to point to latest API:
	
	Refer [step 5](https://github.com/azsk/DevOpsKit-docs/tree/master/03-Security-In-CICD#adding-svts-in-the-release-pipeline) from SVT Task documentation to update policy url in pipeline. Make sure you set EnableServerAuth variable to true. 

**Note:** We are already exploring on latest AAD based auth feature available on Storage to protect policy. Above steps will be updated in future once AzSK is compatible with latest features.

#### Can I completely override policy. I do not want policy to be run in Overlay method?

Yes. You can completely override policy configuration with the help index file. 

**Steps:**

i) Copy local version of configuration file to policy folder. Here we will copy complete AppService.json. 

Source location: "%userprofile%\Documents\WindowsPowerShell\Modules\AzSK\<version>\Framework\Configurations\SVT"

Destination location:
 "D:\ContosoPolicies"
![Copy Configurations](../Images/07_OrgPolicy_CopyConfiguration.png)


ii) Update configurations for all required controls in AppService.json

iii) Add entry for configuration in index file(ServerConfigMetadata.json) with OverrideOffline property 

![Overide Configurations](../Images/07_OrgPolicy_ServerConfigOverride.png)

iv) Run update/install Org policy command with required parameters. 

### Control is getting scanned even though it has been removed from my custom org-policy.

If you want only the controls which are present on your custom org-policy to be scanned, set the  OverrideOffline flag to true in the ServerConfigMetadata.json file.

Example: If you want to scan only the ARMControls present in your org-policy, then set the OverrideOffline flag to true as shown below.

![ARM Controls override](../Images/07_Custom_Policy_ARMControls.png)


##### Testing:

Run clear session state command(Clear-AzSKSessionState) followed by services scan (Get-AzSKAzureServicesSecurityStatus). Scan should reflect configuration changes done.
