
> The Secure DevOps Kit for Azure (AzSK) was created by the Core Services Engineering & Operations (CSEO) division at Microsoft, to help accelerate Microsoft IT's adoption of Azure. We have shared AzSK and its documentation with the community to provide guidance for rapidly scanning, deploying and operationalizing cloud resources, across the different stages of DevOps, while maintaining controls on security and governance.
<br>AzSK is not an official Microsoft product – rather an attempt to share Microsoft CSEO's best practices with the community..
# Azure DevOps (ADO) Security Scanner -Preview

### [Overview](Readme.md#Overview)
 - [Installation Guide](Readme.md#installation-guide)

### [Scan your Azure DevOps resources](Readme.md#scan-your-azure-devops-resources-1)
 
### [Continuous Assurance](Readme.md#continuous-assurance-1)
  - [Setting up Continuous Assurance - Step by Step](Readme.md#setting-up-continuous-assurance---step-by-step)
  - [Visualize security scan results](Readme.md#visualize-security-scan-results)

### [Control Attestation](Readme.md#control-attestation-1)
- [Overview](Readme.md#Overview-1)
- [Starting attestation](Readme.md#starting-attestation)  
- [How toolkit determines the effective control result](Readme.md#how-toolkit-determines-the-effective-control-result)  
- [Permissions required for attesting controls](Readme.md#permissions-required-for-attesting-controls) 
- [Attestation expiry](Readme.md#attestation-expiry)  

Security Scanner for Azure DevOps (ADO) performs security scanning for core areas of Azure DevOps like Organization, Projects, Users, Connections, Pipelines (Build & Release). 


## Installation Guide

>**Pre-requisites**:
> - PowerShell 5.0 or higher. 

1. First verify that prerequisites are already installed:  
    Ensure that you have PowerShell version 5.0 or higher by typing **$PSVersionTable** in the PowerShell ISE console window and looking at the PSVersion in the output as shown below.) 
 If the PSVersion is older than 5.0, update PowerShell from [here](https://www.microsoft.com/en-us/download/details.aspx?id=54616).  
   ![PowerShell Version](../Images/00_PS_Version.PNG)   

2. Install the Security Scanner for Azure DevOps (AzSK.AzureDevOps) PS module:  
	  
```PowerShell
  Install-Module AzSK.AzureDevOps -Scope CurrentUser -AllowClobber -Force
```

## Scan your Azure DevOps resources

Run the command below after replacing `<OrganizationName>` with your Azure DevOps org Name 
and `<PRJ1, PRJ2, ..`> with a comma-separated list of project names where your Azure DevOps resources are hosted.
You will get Organization name from vsts url e.g. http://samplevstsorg.visualstudio.com. In this 'samplevstsorg' is org name.

```PowerShell
Get-AzSKAzureDevOpsSecurityStatus -OrganizationName "<OrganizationName>" -ProjectNames "<PRJ1, PRJ2,...etc.>"
```

Command also supports other parameters of filtering resources.
For instance, you can also make use of the 'BuildNames','ReleaseNames' to filter specific resource

```PowerShell

#Scan organization
Get-AzSKAzureDevOpsSecurityStatus -OrganizationName "<OrganizationName>"

#Scan organization and Project
Get-AzSKAzureDevOpsSecurityStatus -OrganizationName "<OrganizationName>" -ProjectNames "<PRJ1,PRJ2,etc>" 

#Scan organization, project and builds
Get-AzSKAzureDevOpsSecurityStatus -OrganizationName "<OrganizationName>" -ProjectNames "PRJ1" -BuildNames "<BLD1, BLD2,...etc.>" 

#Scan organization, project and releases
Get-AzSKAzureDevOpsSecurityStatus -OrganizationName "<OrganizationName>" -ProjectNames "PRJ1" -ReleaseNames "<RLS1, RLS2,...etc.>" 

#Scan organization, project, all builds and releases
Get-AzSKAzureDevOpsSecurityStatus -OrganizationName "<OrganizationName>" -ProjectNames "PRJ1" -BuildNames "*" -ReleaseNames "*" 

#Scan organization, project and service connections
Get-AzSKAzureDevOpsSecurityStatus -OrganizationName "<OrganizationName>" -ProjectNames "PRJ1" -ServiceConnectionNames "<SER1, SER2,...ect.>"

#Scan organization, project and agent pools
Get-AzSKAzureDevOpsSecurityStatus -OrganizationName "<OrganizationName>" -ProjectNames "PRJ1" -AgentPoolNames "<AGP1, AGP2,...etc.>"

#Scan organization, project, all builds, releases, service connectiopns and agent pools
Get-AzSKAzureDevOpsSecurityStatus -OrganizationName "<OrganizationName>" -ProjectNames "PRJ1" -BuildNames "*" -ReleaseNames "*" -ServiceConnectionNames "*" -AgentPoolNames "*"

#Scan all supported artifacts
Get-AzSKAzureDevOpsSecurityStatus -OrganizationName "<OrganizationName>" -ScanAllArtifacts

#Scan projects 
Get-AzSKAzureDevOpsSecurityStatus -OrganizationName "<OrganizationName>" -ProjectNames "<PRJ1,PRJ2,etc>" -ResourceTypeName Project

#Scan builds 
Get-AzSKAzureDevOpsSecurityStatus -OrganizationName "<OrganizationName>" -ProjectNames "PRJ1" -BuildNames "*" -ResourceTypeName Build

#Scan releases 
Get-AzSKAzureDevOpsSecurityStatus -OrganizationName "<OrganizationName>" -ProjectNames "PRJ1" -ReleaseNames "*" -ResourceTypeName Release

#Scan service connections 
Get-AzSKAzureDevOpsSecurityStatus -OrganizationName "<OrganizationName>" -ProjectNames "PRJ1" -ServiceConnectionNames "*" -ResourceTypeName ServiceConnection

#Scan agent pools 
Get-AzSKAzureDevOpsSecurityStatus -OrganizationName "<OrganizationName>" -ProjectNames "PRJ1" -AgentPoolNames "*" -ResourceTypeName AgentPool

#Scan resources for baseline controls only
Get-AzSKAzureDevOpsSecurityStatus -OrganizationName "<OrganizationName>" -ProjectNames "<PRJ1,PRJ2,etc>" -ubc

#Scan resources with severity
Get-AzSKAzureDevOpsSecurityStatus -OrganizationName "<OrganizationName>" -ProjectNames "<PRJ1,PRJ2,etc>" -Severity "High/Medium/Low"
```
AzSK.AzureDevOps also supports individual scan cmdlets for organization, project, build and release.

```PowerShell

#Scan organization
Get-AzSKAzureDevOpsOrgSecurityStatus -OrganizationName "<OrganizationName>"

#Scan projects
Get-AzSKAzureDevOpsProjectSecurityStatus -OrganizationName "<OrganizationName>" -ProjectNames "<PRJ1,PRJ2,etc>"

#Scan builds
Get-AzSKAzureDevOpsBuildSecurityStatus -OrganizationName "<OrganizationName>" -ProjectNames "<PRJ1,PRJ2,etc>" -BuildNames "*"

#Scan releases
Get-AzSKAzureDevOpsReleaseSecurityStatus -OrganizationName "<OrganizationName>" -ProjectNames "<PRJ1,PRJ2,etc>" -ReleaseNames "*"
```

Similar to Azure AzSK SVT scan, outcome of the analysis is printed on the console during SVT execution and a CSV and LOG files are 
also generated for subsequent use.

The CSV file and LOG file are generated under a org-specific sub-folder in the folder  
*%LOCALAPPDATA%\Microsoft\AzSK.AzureDevOpsLogs\Org_[yourOrganizationName]*  
E.g.  
C:\Users\UserName\AppData\Local\Microsoft\Azure.DevOpsLogs\Org_[yourOrganizationName]\20181218_103136_GADS

Refer [doc](../02-Secure-Development#understand-the-scan-reports) for understanding the scan report and [link](./ControlCoverage) for current control coverage for Azure DevOps


## Continuous Assurance

The basic idea behind Continuous Assurance (CA) is to setup periodic security scan and if new, more secure options become available for a feature, it should be possible to detect so that an application or solution can benefit from them and notify/alert the owners concerned.

Scan is performed via security scanner task in the pipeline and results can be visualized via dashboard by adding ADO security scanner widgets into the Azure DevOps project’s dashboard. Pipeline can be setup with the trigger to run periodically and provide continuous assurance.

### Setting up Continuous Assurance - Step by Step

In this section, we will walk through the steps of setting up a DevOps pipeline for ADO Continuous Assurance coverage.
To get started, we need the following 

__Prerequisite:__

- DevOps organization and project 
- "Project Collection Administrator" or "Owner" permission to perform below task:

    •	Install "ADO Security Scanner" extension

    •	Setup pipeline with scanner task.
    
    •	Create dashboard to visualize scan results



#### Install “ADO Security Scanner” extension for your Azure DevOps Organization


Extension has been published to the visual studio marketplace gallery under “Azure DevOps > Azure Pipeline” category. You can now install this extension from the Marketplace directly (https://marketplace.visualstudio.com/items?itemName=azsdktm.ADOSecurityScanner).

Refer doc [here](https://docs.microsoft.com/en-us/azure/devops/marketplace/install-extension?view=azure-devops&tabs=browser) for more about installing extensions for org

  ![Extension Details](../Images/09_ADO_ExtensionDetails.png) 


#### Adding ADO Security Scanner in the pipeline

This part assumes that you are familiar with Azure DevOps build tasks and pipelines at a basic level. Our goal is to show how ADO Security Scanner can be added into the build/release workflow.

__Step-1__: Create a build pipeline or open an existing one.

__Step-2__: Add “ADO Security Scanner” task to the pipeline

Click on "Add Tasks" and select "Azure DevOps (ADO) Security Verification".

![Add scanner task](../Images/09_ADO_AddADOScannerTask.png)

__Step-3__: Specify the input parameters for the task.
The "ADO Security Scanner" task starts showing in the "Run on Agent" list and displays some configuration inputs that are required for the task to run. These are none other than the familiar options we have been specifying while running the ADO scan manually - you can choose to specify the target org, projects, builds and releases based on how your org resources are organized.

![Add task inputs](../Images/09_ADO_AddTaskDetails.png)

> **Note:** This task also requires Azure DevOps connection containing org details and PAT token to scan the required resources. Refer doc [here](https://docs.microsoft.com/en-us/azure/devops/organizations/accounts/use-personal-access-tokens-to-authenticate?view=azure-devops&tabs=preview-page) to create token and provide it as part of connection

> Refer the list [here](./PATPrivileges) for customizing the PAT required for Azure DevOps Connection with minimum required privileges.

![Add Service connection](../Images/09_ADO_AddServiceConnection.png)


__! Important__ : Make sure you **DO NOT** select  checkbox for "Grant access permission to all pipelines" before saving service connection. 

> **Note**: ADO Security Scanner extension enables you to leverage some of the advanced capabilities of scanner while running in adhoc mode. You could scan for only preview baseline controls in your build pipeline, or you could just scan for controls with specific severity etc. These advanced features are available to customers through ADO variables. For example, use *ExtendedCommand* variable in the pipeline with its value as *-Severity 'High'* to scan controls with high severity.


__Step-4__: Click “Save & queue”

![Add Service connection](../Images/09_ADO_TriggerPipeline.png)

Task will install latest AzureDevOps scanner module and start scanning based on input parameters. 

![Scan Image](../Images/09_ADO_ScanImage-1.png)

At the end, it will show the summary of scan and store the result in extension storage.

![Scan Image](../Images/09_ADO_ScanImage-2.png)

__Step-4__: Setup scheduled trigger for pipeline

Once you are able to successfully run the ADO scan using ADO pipeline, you can configure scheduled trigger to get latest visibility of security on resources

![Schedule Trigger](../Images/09_ADO_ScheduleTrigger.png)


### Visualize security scan results 

Once scan is completed as part of pipeline, results can be visualized with the help of project dashboard.

Extension mainly provides two widgets that can be added as part of dashboard

__•	Org Level Security Scan Summary__: Displays org level security control evaluation summary. This dashboard helps org owners to take action based on control failures.

__•	Project Component Security Scan Summary__: Displays project components (Build/Release/Connections) security control evaluation summary.

__Steps__:

1. Go to project dashboard under your organization and create new dashboard for org level summary

    ![Create Dashboard](../Images/09_ADO_AddDashboard.png)

2. Click edit or add widget > Search for “__Org Level Security Scan Summary__” > Click ‘Add’ followed by “Done Editing”

    ![Configure Widget](../Images/09_ADO_AddOrgSummaryWidget.png)

3. Dashboard will start displaying scanned results 

    ![org Level Summary](../Images/09_ADO_OrgLevelDashboard.png)

Step 1,2 & 3 needs to be repeated to add “__Project Component Security Scan Summary__”

![Schedule Trigger](../Images/09_ADO_ProjectComponentLevl.png)


> **Note:**  Dashboard created will be visible to all users which are part of project.
> **Note:**  Dashboard reflects updates only upon pipeline execution. Local scan results don't reflect automatically. If you have remediated a control, make sure you run the pipeline to reflect the updated control results on dashboard.

# Control Attestation

> **Note**: Please use utmost discretion when attesting controls. In particular, when choosing to not fix a failing control, you are taking accountability that nothing will go wrong even though security is not correctly/fully configured. 
> </br>Also, please ensure that you provide an apt justification for each attested control to capture the rationale behind your decision.  

### Overview

The attestation feature empowers users to support scenarios where human input is required to augment or override the default control 
evaluation status from AzSK.AzureDevOps. These may be situations such as:

- The toolkit has generated the list of 'Administrators' for a project but someone needs to have a look at the list and ratify that 
these are indeed the correct people, or
- The toolkit has marked a control as failed. However, given the additional contextual knowledge, the application owner wants to ignore the control failure.

In all such situations, there is usually a control result that is based on the technical evaluation (e.g., Verify, Failed, etc.) that has to 
be combined with the user's input in order to determine the overall or effective control result. The user is said to have 'attested' such controls 
and, after the process is performed once, AzSK.AzureDevOps remembers it and generates an effective control result for subsequent control scans _until_ there 
is a state change.

The attestation feature is implemented via a new switch called *ControlsToAttest* which can be specified in any of the standard security scan cmdlets
of AzSK.AzureDevOps. When this switch is specified, the toolkit first performs a scan of the target resource(s) like it is business as usual and, once
the scan is complete, it enters a special interactive 'attest mode' where it walks through each resource and relevant attestable controls
and captures inputs from the user and records them (along with details about the person who attested, the time, etc.). 
After this, for all future scans on the resource(s), AzSK.AzureDevOps will show the effective control evaluation results. Various options are provided to support
different attestation scenarios (e.g., expiry of attestations, edit/change/delete previous attestations, attest only a subset of controls, etc.). 
These are described below. Also, for 'stateful' controls (e.g., "are these the right service accounts with access to project collection?"), the attestation
state is auto-reset if there is any change in 'state' (e.g., someone adds a new service account to the list).

Lastly, due to the governance implications, the ability to attest controls is available to a subset of users. This is described in
the permissions required section below.  


[Back to top...](Readme.md#contents)
### Starting attestation
      
The AzSK.AzureDevOps scan cmdlets now support a new switch called *ControlsToAttest*. When this switch is specified, 
AzSK.AzureDevOps enters the attestation workflow immediately after a scan is completed. This ensures that attestation is done on the basis of the most current
control status.

All controls that have a technical evaluation status of anything other than 'Passed' (i.e., 'Verify' or 'Failed' or 'Manual' or 'Error') are considered 
valid targets for attestation.

> **Note**: Some controls are very crucial from security stand point and hence AzSK.AzureDevOps does not support attesting them.

To manage attestation flow effectively, 4 options are provided for the *ControlsToAttest* switch to specify which subset of controls to target for attestation. These are described below:

|Attestation Option|Description|
|------------------|-----------|
|NotAttested|Attest only those controls which have not been attested yet.|
|AlreadyAttested|Attest those controls which have past attestations. To re-attest or clear attestation.|
|All|Attest all controls which can be attested (including those that have past attestations).|
|None|N/A.|

For example, to attest organization controls, run the command below:
```PowerShell  
$orgName = '<Organization name>'
Get-AzSKAzureDevOpsSecurityStatus -OrganizationName $orgName -ControlsToAttest NotAttested -ResourceTypeName Organization  
```

For example, to attest project controls, run the command below:
```PowerShell  
$orgName = '<Organization name>'
$prjName = '<Project name>'
Get-AzSKAzureDevOpsSecurityStatus -OrganizationName $orgName -ProjectNames $prjName -ControlsToAttest NotAttested -ResourceTypeName Project  
```

As shown in the images, the command enters 'attest' mode after completing a scan and does the following:

1. For each resource that was scanned, if a control is a target for attestation, control details (such as description, severity, etc.) and the current evaluation result are displayed (to help the user)
2. The user gets to choose whether they want to attest the control
3. If the user chooses to attest, attestation details (attest status, justification, etc.) are captured
4. This is repeated for all attestable controls and each resource.

 Sample attestation workflow in progress:
 ![09_SVT_Attest_1](../Images/09_SVT_Attest_1.png) 
 
 Sample summary of attestation after workflow is completed:
 ![09_SVT_Attest_2](../Images/09_SVT_Attest_2.png) 

Attestation details corresponding to each control (e.g., justification, user name, etc.) are also captured in the CSV file as shown below:
 ![09_SVT_Attest_3](../Images/09_SVT_Attest_3.png) 

If you wish to revisit previous attestations, it can be done by using 'AlreadyAttested' flag in the command above.  

[Back to top...](Readme.md#contents)
### How toolkit determines the effective control result

During the attestation workflow, the user gets to provide attestation status for each control attested. This basically represents the user's attestation preference w.r.t.
a specific control (i.e., whether the user wants to override/augment the toolkit status and treat the control as passed or whether the user agrees with the toolkit status but wants to defer fixing the issue for the time being):

|Attestation Status | Description|
|---|---|
|None | There is no attestation done for a given control. User can select this option during the workflow to skip the attestation|
|NotAnIssue | User has verified the control data and attesting it as not an issue with proper justification to represent situations where the control is implemented in another way, so the finding does not apply. |
|WillNotFix | User has verified the control data and attesting it as not fixed with proper justification|

The following table shows the complete 'state machine' that is used by AzSK.AzureDevOps to support control attestation. 
The columns are described as under:
- 'Control Scan Result' represents the technical evaluation result 
- 'Attestation Status' represents the user choice from an attestation standpoint
- 'Effective Status' reflects the effective control status (combination of technical status and user input)
- 'Requires Justification' indicates whether the corresponding row requires a justification comment
- 'Comments' outlines an example scenario that would map to the row

|Control Scan Result  |Attestation Status |Effective Status|Requires Justification | ExpiryInDays| Comments |
|---|---|---|---|---|---|
|Passed |None |Passed |No | -NA- |No need for attestation. Control has passed outright!|
|Verify |None |Verify |No | -NA- |User has to ratify based on manual examination of AzSK.AzureDevOps evaluation log. E.g., Project Collection Service Account list.|
|Verify |NotAnIssue |Passed |Yes | 90 |User has to ratify based manual examination that finding does not apply as the control has been implemented in another way.|
|Verify |WillNotFix |Exception |Yes | Based on the control severity table below|Valid security issue but a fix cannot be implemented immediately.|
|Failed |None |Failed |No | -NA- | Control has failed but has not been attested. Perhaps a fix is in the works...|	 
|Failed |NotAnIssue |Passed |Yes | 90 |Control has failed. However, the finding does not apply as the control has been implemented in another way.|
|Failed |WillNotFix |Exception |Yes | Based on the control severity table below| Control has failed. The issue is not benign, but the user has some other constraint and cannot fix it.|
|Error |None |Error |No | -NA- | There was an error during evaluation. Manual verification is needed and is still pending.|
|Error |NotAnIssue |Passed |Yes | 90| There was an error during evaluation. Manual verification by user indicates that the finding does not apply as the control has been implemented in another way.|
|Error |WillNotFix |Exception |Yes | Based on the control severity table below| There was an error during evaluation. Manually verification by the user indicates a valid security issue.|
|Manual |None |Manual |No | -NA-| The control is not automated and has to be manually verified. Verification is still pending.| 
|Manual |NotAnIssue |Passed |Yes | 90| The control is not automated and has to be manually verified. User has reviewed the security concern and implemented the fix in another way.|
|Manual |WillNotFix |Exception |Yes | Based on the control severity table below| The control is not automated and has to be manually verified. User has reviewed and found a security issue to be fixed.|

-NA- => Not Applicable

Control Severity Table:

|ControlSeverity| ExpiryInDays|
|----|---|
|Critical| 7|
|High   | 30|
|Medium| 60|
|Low| 90|
 
  
<br>
The following table describes the possible effective control evaluation results (taking attestation into consideration).

|Control Scan Result| Description|
|---|---|
|Passed |Fully automated control. Azure DevOps artifact configuration meeting the control requirement|
|Verify |Semi-automated control. It would emit the required data in the log files which can be validated by the user/auditor.|
|Failed |Fully automated control. Azure DevOps artifact configuration not meeting the control requirement|
|Error |Automated control. Currently failing due to some exception. User needs to validate manually|
|Manual |No automation as of now. User needs to validate manually|
|Exception |Risk acknowledged. The 'WillNotFix' option was chosen as attestation choice/status. |

[Back to top...](Readme.md#contents)
### Permissions required for attesting controls:
Attestation is currently supported only for organization and project controls with admin privileges on organization and project, respectively.

Currently, attestation can be performed only via PowerShell session in local machine, but the scan results will be honored in both local as well as extension scan.

> **Note**:   
>* In order to attest organization control, user needs to be a member of the group 'Project Collection Administrators'.
>* In order to attest project control, user needs to be a member of the group 'Project Administrators' of that particular project.
[Back to top...](Readme.md#contents)

### Attestation expiry:
All the control attestations done through AzSK.AzureDevOps is set with a default expiry. This would force teams to revisit the control attestation at regular intervals. 
Expiry of an attestation is determined through different parameters like control severity, attestation status etc. 
There are two simple rules for determining the attestation expiry. Those are:

Any control with evaluation result as not passed and, 
 1. attested as 'NotAnIssue', such controls would expire in 90 days.
 2. attested as 'WillFixLater', such controls would expire based on the control severity table below.

|ControlSeverity| ExpiryInDays|
|----|---|
|Critical| 7|
|High   | 30|
|Medium| 60|
|Low| 90|

> **Note**:
>* Attestation may also expire before actual expiry in cases when the attested state for the control doesn't match with current control state.
[Back to top...](Readme.md#contents)






