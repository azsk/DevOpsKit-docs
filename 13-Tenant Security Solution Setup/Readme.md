# Tenant Security Solution (TSS) [In Preview]

## Tenant Security
### Contents
- [Overview](Readme.md#overview)
- [Why Tenant Security Solution?](Readme.md#why-tenant-security-solution)
- [Setting up Tenant Security Solution - Step by Step](Readme.md#setting-up-tenant-security-solution---step-by-step)
- [Tenant Security Solution - how it works (under the covers)](Readme.md#tenant-security-solution---how-it-works-under-the-covers)
- [Create compliance and monitoring solutions](Readme.md#create-security-compliance-monitoring-solutions)
- [Feedback](Readme.md#feedback)

-----------------------------------------------------------------
## Overview 
The Tenant Security Solution (TSS) from the AzSK team can be used to obtain visibility to cloud subscriptions and resource configuration across multiple subscriptions in an enterprise environment. The AzSK TSS is a logical progression of DevOps Kit which helps us move closer to an implementation of cloud security compliance solution using native security capabilities in Azure platform that are available today. Functionally, it is similar to running AzSK Continuous Assurance (CA) in central-scan mode.

## Why Tenant Security Solution?
The Tenant Security Solution was created with the following explicit objectives (some of which were harder to accomplish using the existing Automation-based Continuous Assurance approach):
 * Ability to scan large number of subscriptions in a central scan model in a cost-effective and time-efficient manner
 * Being able to scale scanning capability up or down without externally imposed constraints (e.g., runbook memory, runtime limits)
 * Speeding up our effort to transition to native features (being able to respond to changes in Azure more rapidly and deploy modifications to controls)
 * Enable incremental transition of our controls from custom code to Azure/ASC policy-based approach (using ASC/policy-based controls where available today and continue to migrate as more controls become available)

## Setting up Tenant Security Solution - Step by Step
In this section, we will walk through the steps of setting up Tenant Security Solution 

To get started, we need the following prerequisites:


**Prerequisite:**

**1.** Installation steps are supported using following OS options: 	

- Windows 10
- Windows Server 2016

**2.** PowerShell 5.0 or higher

 Ensure that you are using Windows OS and have PowerShell version 5.0 or higher by typing **$PSVersionTable** in the PowerShell ISE console window and looking at the PSVersion in the output as shown below.) 
 If the PSVersion is older than 5.0, update PowerShell from [here](https://www.microsoft.com/en-us/download/details.aspx?id=54616).  

   ![PowerShell Version](../Images/00_PS_Version.PNG)   

**3.** Install Az and Managed Service Identity Powershell Module using below command. For more details of Az installation refer [link](https://docs.microsoft.com/en-us/powershell/azure/install-az-ps)

``` Powershell
# Install Az Modules
Install-Module -Name Az -AllowClobber -Scope CurrentUser

#Install managed identity service module
Install-Module -Name Az.ManagedServiceIdentity -AllowClobber -Scope CurrentUser
```

**4.**  Create central scanning user identity and provide reader access to subscriptions on which scan needs to be performed.

You can create user identity with below PowerShell command or Portal steps [here](https://docs.microsoft.com/en-us/azure/active-directory/managed-identities-azure-resources/how-to-manage-ua-identity-portal) and assign reader access on subscriptions to be scanned.

``` Powershell

# Step 1: Set context to subscription where central scan identity needs to be created
Set-AzContext -SubscriptionId <MIHostingSubId>

# Step 2: Create User Identity 
$UserAssignedIdentity = New-AzUserAssignedIdentity -ResourceGroupName <MIHostingRG> -Name <USER ASSIGNED IDENTITY NAME>

# Step 3: Keep resource id generated for user identity using below command. This will be used in installation parameter

$UserAssignedIdentity.Id

# Step 4: Assign user identity with reader role on all the subscriptions which needs to be scanned. 
# Below command help to assign access to single subscription. 
# You need to repeat below step for all subscription

New-AzRoleAssignment -ApplicationId $UserAssignedIdentity.ClientId -Scope <SubscriptionScope> -RoleDefinitionName "Reader"


```

**5.** Owner access on hosting subscription

The user setting up Tenant Security Solution needs to have 'Owner' access to the subscription.  

**6.** Download and extract deployment zip content from [here](./TemplateFiles/Deploy.zip) to your local machine.  You may have to unblock the content. Below command will help to unblock files. 

``` PowerShell
Get-ChildItem -Path "<Extracted folder path>" -Recurse |  Unblock-File 
```

[Back to top…](Readme.md#contents)

**Step-1: Setup** 

1. Open the PowerShell ISE and login to your Azure account (using **Connect-AzAccount**) and Set the context to subscription where solution needs to be installed.

``` PowerShell
# Login to Azure 
Connect-AzAccount 

# Set the context to hosting subscription
Set-AzContext -SubscriptionId <SubscriptionId>
```

2. Run installation command with required parameters given. 

``` PowerShell

# Step 1: Point current path to extracted folder location and load setup script from deploy folder 

CD "<LocalExtractedFolderPath>\Deploy"

. ".\AzSKTSSetup.ps1"

# Note: Make sure you copy  '.' present at the start of line.

# Step 2: Run installation command. 

Install-AzSKTenantSecuritySolution `
                -SubscriptionId <SubscriptionId> `
                -ScanHostRGName <ResourceGroupName> `
                -ScanIdentityId <ManagedIdentityResourceId> `
                -Location <ResourceLocation> `
                -Verbose

# For ScanIdentityId parameter, use value created for "$UserAssignedIdentity.Id" from prerequisite section step 4.

# Example:

Install-AzSKTenantSecuritySolution `
                -SubscriptionId bbbe2e73-fc26-492b-9ef4-adec8560c4fe `
                -ScanHostRGName TSSolutionRG `
                -ScanIdentityId '/subscriptions/bbbe2e73-fc26-492b-9ef4-adec8560c4fe/resourceGroups/TenantReaderRG/providers/Microsoft.ManagedIdentity/userAssignedIdentities/TenantReaderUserIdentity' `
                -Location EastUS2 `
                -Verbose
```

**Parameter details:**

|Param Name|Description|Required?
|----|----|----|
|SubscriptionId|Hosting subscription id where Tenant solution will be deployed |TRUE|
|ScanHostRGName| Name of ResourceGroup where setup resources will be created |TRUE|
|ScanIdentityId| Resource id of user managed identity used to scan subscriptions  |TRUE|
|Location|Location where all resources will get created |TRUE|
|Verbose| Switch used to output detailed log |FALSE|
|EnableScaleOutRule| Switch used to deploy auto scaling rule for scanning evironment |FALSE|


>**Note:** Completion of this one-time setup activity can take up to 5 minutes and it will look like below.

  ![Resources](../Images/12_TSS_CommandOutput.png)



**Step-2: Verifying that Tenant Security Solution installation is complete**  

**1:** In the Azure portal, Go to Azure Resource Groups and select the resource group ('TSSolutionRG') that has been created during the setup.

**2:** Verify below resources got created. 

![Resources](../Images/12_TSS_Resource_Group.png)	

**Resources details:**

|Resource Name|Resource Type|Description|
|----|----|----|
|AzSKTSWorkItemProcessor-xxxxx|App Service| Contains inventory and subscription work item processor job. More details [below] |
|AzSKTSWorkItemScheduler-xxxxx|App Service | Contains work item (subscription) scheduler job. More details [below] |
|AzSKTSLAWorkspace-xxxxx|Log Analytics workspace| Used to store scan events, inventory, subscription scan progress details|
|AzSKTSProcessorMI-xxxxx|Managed Identity | Internal MI identity used to access LA workspace and storage for sending scan results|
|AzSKTSServicePlan| App Service Plan| App service plan used for jobs|
|azsktsstoragexxxxx|Storage Account| Used to store the daily results of subscriptions scan|



 **3:** Verify below three jobs got created

**i) InventoryJob:** 

 Responsible to fetch details about all the subscriptions that has been granted access as Reader using central MI. All these subscriptions will be fetched by the job and persisted into LA. These subscriptions are scanned automatically by the consecutive jobs.

 
 To see the job, you can go to resource 'AzSKTSWorkItemProcessor-xxxxx' --> 'Webjobs' Properties --> Verify '0.1.Inventory' <br />By Default this job is scheduled to run once every day.
	
 ![ProcessorWebjobs](../Images/12_TSS_Processor_WebJobs.png)

 **ii) WorkItemSchedulerJob:** 
 
 Responsible to queue up subscriptions as workitems for scanning. It also reconciles the errored subscriptions through retries in the end. By default it would retry to scan for 5 times for each error subscription. IF there are nothing to process for the day, it would simply ignore the run.


 Go to resource 'AzSKTSWorkItemScheduler-xxxxx' --> 'Webjobs' Properties -->Verify '0.2.JobProcessor'. 
 <br/> By default this job is scheduled to run every 30 minutes through out the day.
	
![SchedulerWebjobs](../Images/12_TSS_Scheduler_Webjobs.png)

 **iii) WorkItemProcessorJob:** 
 
 Read subscription list from queue and scan for Azure control plane security controls. 
 
 Go to resource 'AzSKTSWorkItemProcessor-xxxxx' --> 'Webjobs' Properties --> Verify '0.3.WorkItemProcessorJob'
 <br /> By default this job is scheduled to run for two hours to scan subscriptions. (Refer screenshot from Job01)


**Note:** Jobs are scheduled to run from UTC 00:00 time. You can also run the jobs manually by trigger jobs 01, 02 and 03 in sequence with an interval 10 mins in between. After Job 3 completes processing the messages in the queue, you will start seeing scan results in storage account and LA workspace.  


[Back to top…](Readme.md#contents)
## Tenant Security Solution under the covers (how it works)
 Tenant Security Solution is built by extending what the DevOps Kit has been doing and leveraging the best of Azure native features. It is a hybrid model, which leverages the native Azure security capabilities like Azure Security Center (ASC), Azure Policies, etc., to evaluate the security controls and continue to leverage DevOps Kit scanning capabilities in the form of custom code controls to address any coverage gaps.  

It has been desinged to handle huge scales in highly performant and cost efficient manner.

As a central team, you can run the scan at regular intervals and also empower your DevOps engineers to run the module independently to address control failures. 

The diagram below depicts a high level overview of the hybrid solution:

![Internals](../Images/12_TenantSetupInternals.png)

[Back to top…](Readme.md#contents)

# Create security compliance monitoring solutions
Once you have an Tenant Security setup running smoothly with multiple subscriptions across your org, you will need a solution that provides visibility of security compliance for all the subscriptions across your org. This will help you drive compliance/risk governance initiatives for your organization. 

When you setup your Tenant Security endpoint (i.e. policy server), one of the things that happens is creation of an Log Analytics workspace for your setup. After that, whenever someone performs an TSS scan for a subscription that is configured to use your Tenant Security, the scan results are sent (as 'security' telemetry) to your org's Log Analytics workspace. Because this workspace receives scan events from all such subscriptions, it can be leveraged to generate aggregate security compliance views for your cloud-based environments. 

## Create cloud security compliance report for your org using PowerBI
We will look at how a PowerBI-based compliance dashboard can be created and deployed in a matter of minutes starting with a template dashboard that ships with the Tenant Security Solution (TSS). All you need apart from the Log Analytics workspace instance is a CSV file that provides a mapping of your organization hierarchy to subscription ids (so that we know which team/service group owns each subscription).

> Note: This is a one-time activity with tremendous leverage as you can use the resulting dashboard (example below) towards driving security governance activities over an extended period at your organization. 

#### Step 0: Pre-requisites
To create, edit and publish your compliance dashboard, you will need to install the latest version of PowerBI desktop on your local machine. Download it from [here](https://powerbi.microsoft.com/en-us/desktop/).


#### Step 1: Prepare your org-subscription mapping
In this step you will prepare the data file which will be fed to the PowerBI dashboard creation process as the mapping from subscription ids to the org hierarchy within your environment. The file is in a simple CSV form and should appear like the one below. 

> Note: You may want to create a small CSV file with just a few subscriptions for a trial pass and then update it with the full subscription list for your org after getting everything working end-to-end.

A sample template for the CSV file is [here](./TemplateFiles/OrgMapping.csv):

![Org-Sub metadata json](../Images/07_OrgPolicy_PBI_OrgMetadata.PNG) 

The table below describes the different columns in the CSV file and their intent.

| ColumnName  | Description | Required? | Comments |
| ---- | ---- | ---- |---- |
| BGName | Name of business group (e.g., Finance, HR, Marketing, etc.) within your enterprise | Yes |  This you can consider as level 1 hierarchy for your enterprise | 
| ServiceGroupName | Name of Service Line/ Business Unit within an organization | Yes |  This you can consider as level 2 hierarchy for your enterprise | 
| SubscriptionId | Subscription Id belonging to a org/servicegroup | Yes |   | 
| SubscriptionName | Subscription Name | Yes | This should match the actual subscription name. If it does not, then the actual name will be used  | 
| IsActive | Use "Y" for Active Subscription and "N" for Inactive Subscription  | Yes | This will be used to filter active and inactive subscriptions | 
| OwnerDetails | List of subscription owners separated by semi-colons (;)  | Yes | These are people accountable for security of the subscription  | 

> **Note**: Ensure you follow the correct casing for all column names as shown in the table above. The 'out-of-box' PowerBI template is bound to these columns. If you need additional columns to represent your org hierarchy then you may need to modify the template/report as well.


#### Step 2: Upload your mapping to the Log Analytics (LA) workspace

In this step you will import the data above into the LA workspace created during Tenant Security setup. 

 **(a)** Locate the LA resource that was created during Tenant Security setup in your central subscription. This should be present under Tenant Security resource group. After selecting the LA resource, copy the Workspace ID from the portal as shown below:

 ![capture Workspace ID](../Images/13_TSS_LAWS_AgentManagement.png)
 
 **(b)** To push org Mapping details, copy and execute the script available [here](./Scripts/TSSPushOrgMappingEvents.txt) in Powershell.

 > **Note**: Due to limitation of Log Analytics workspace, you will need to repeat this step every 90 days interval. 

#### Step 3: Create a PowerBI report file
In this section we shall create a PowerBI report locally within PowerBI Desktop using the LA workspace from Tenant Security subscription as the datasource. We will start with a default (out-of-box) PowerBI template and configure it with settings specific to your environment. 

> Note: This step assumes you have completed Step-0 above!

**(a)** Get the Workspace ID for your LA workspace from the portal as shown below:

![capture Workspace ID](../Images/13_TSS_LAWS_AgentManagement.png)

**(b)** Download and copy the PowerBI template file from [here](https://github.com/azsk/DevOpsKit-docs/blob/users/TenantSecurityDocument/12-Tenant%20Security%20Solution/TemplateFiles/TenantSecurityReport.pbit) to your local machine.

**(c)** Open the template (.pbit) file using PowerBI Desktop, provide the LA Workspace ID and click on 'Load' as shown below:

![capture loganalytics AppId](../Images/13_TSS_OrgPolicy_PBI_OrgMetadata_LA_1.png)

**(d)** PowerBI will prompt you to login to the Tenant Security subscription at this stage. Authenticate using your user account. (This step basically allows PowerBI to import the data from LA into the PowerBI Desktop workspace.)
![Login to LA](../Images/13_TSS_OrgPolicy_PBI_OrgMetadata_LA_2.png)

Once you have successfully logged in, you will see the Log Analytics data in the PowerBI report along with org mapping as shown below: 

![Compliance summary](../Images/13_TSS_PBIDashboardComplianceSummary.png)

The report contains 3 tabs. There is an overall/summary view of compliance, a detailed view which can be used to see control 'pass/fail' details for individual subscriptions and inventory view which shows distribution of resource types and RBAC role memberships across all Azure subscriptions in the organization. An example of the detailed view and inventory view is shown below:

###### Detailed view:

![Compliance summary](../Images/13_TSS_PBIDashboardComplianceDetails.png) 

###### Inventory view:

![Compliance summary](../Images/13_TSS_PBIDashboardInventoryOverview.png)

> Note: You can consider controlling access to the detailed view by business group.

#### Step 4: Publish the PowerBI report to your enterprise PowerBI workspace

**(a)** Before publishing to the enterprise PowerBI instance, we need to update LA connection string across data tables in the PowerBI report. The steps to do this are as below:

[a1] Click on "Edit Queries" menu option.

![Update LA Connection String](../Images/13_TSS_OrgPolicy_PBI_OrgMetadata_LA_9.png)

[a2] Copy the value of "LogAnalyticsConnectionString"

![Update LA Connection String](../Images/13_TSS_OrgPolicy_PBI_OrgMetadata_LA_3.png)

[a3] Replace the value of "LogAnalyticsConnectionString" with the actual connection string (e.g., LogAnalyticsConnectionString => "https://api.loganalytics.io/v1/workspaces/[LogAnalyticsWorkspaceID]]/query"). You should retain the "" quotes in the connection string.

![Update LA Connection String](../Images/13_TSS_OrgPolicy_PBI_OrgMetadata_LA_4.png)

[a4] Repeat this operation for SubscriptionInvLA, SubscriptionComplianceLast7daysLA, BaselineControlsInvLA, ControlResultsLA, ResourceInvInfoLA, and RBACSummaryLA data tables.

[a5] Click on "Close and Apply".

**(b)** You can now publish your PBIX report to your workspace. The PBIX file gets created locally when you click "Publish".

Click on Publish

![Publish PBIX report](../Images/07_OrgPolicy_PBI_OrgMetadata_AI_18.PNG)

Select destination workspace

![Publish PBIX report](../Images/07_OrgPolicy_PBI_OrgMetadata_AI_19.PNG)

Click on "Open [Report Name] in Power BI" 

![Publish PBIX report](../Images/13_TSS_OrgPolicy_PBI_OrgMetadata_LA_5.png)

**(c)** Now report got published successfully. You can schedule refresh for report with below steps

Go to Workspace --> Datasets --> Click on "Schedule Refresh" icon.

![Publish PBIX report](../Images/13_TSS_OrgPolicy_PBI_OrgMetadata_LA_6.png)

Click on "Edit credentials"

![Publish PBIX report](../Images/13_TSS_OrgPolicy_PBI_OrgMetadata_LA_7.png)

Sign in with account with which policy is created

![Publish PBIX report](../Images/07_OrgPolicy_PBI_OrgMetadata_AI_26.png)

Add refresh scheduling timings and click on "Apply"

> **Note:** You may not see "Schedule refresh" option if step [a3] and [a4] is not completed successfully.

![Publish PBIX report](../Images/13_TSS_OrgPolicy_PBI_OrgMetadata_LA_8.png)

[Back to top…](Readme.md#contents)

## Feedback

For any feedback contact us at: azsksupext@microsoft.com 
