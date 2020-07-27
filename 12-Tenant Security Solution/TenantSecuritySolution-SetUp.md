# Tenant Security Solution (TSS)

## Tenant Security
### Contents
- [Overview](Readme.md#overview)
- [Why Tenant Security Solution](Readme.md#setting-up-continuous-assurance---step-by-step)
- [Setting up Tenant Security Solution - Step by Step](Readme.md#setting-up-continuous-assurance---step-by-step)
- [Why Tenant Security Solution](Readme.md#setting-up-continuous-assurance---step-by-step)
- [Tenant Security Solution - how it works (under the covers)](Readme.md#continuous-assurance---how-it-works-under-the-covers)
- [Feedback](Readme.md#faq)

-----------------------------------------------------------------
## Overview 
The basic idea behind Tenant Security Solution (TSS) is to provide security for all the resources of any subscription. 

>## How it is different from DevOpsKit ?
TODO

## Setting up Tenant Security Solution - Step by Step
In this section, we will walk through the steps of setting up Tenant Security Solution 

To get started, we need the following:
The user setting up Tenant Security Solution needs to have 'Owner' access on the subscription.

**Prerequisite:**

**1.** We currently support following OS options: 	
- Windows 10
- Windows Server 2016

**Step-1: Setup** 

1. Open the PowerShell ISE and login to your Azure account (using **Connect-AzAccount**).  
2. Run the '**Install-TenantSecuritySolution**' command with required parameters given in below table. 

```PowerShell
	
```     Install-TenantSecuritySolution 
                -SubscriptionId <SubscriptionId> `
                -ScanHostRGName <ResourceGroupName> `
                -ScanIdentityId <ManagedIdentityResourceId> `
                -Location <ResourceLocation> `
                -Verbose ` 
                -EnableScaleOutRule

Here is one basic example of Tenant Security Solution setup command:

```PowerShell
	Install-TenantSecuritySolution -SubscriptionId <SubscriptionId> `
	        -ResourceGroupName ‘rgName1’ ` 
	        -MIResourceId  ‘MIRG1’ `
            -Location "EASTUS2" `
            -Verbose `
            -EnableScaleOutRule
```

>**Note:** Completion of this one-time setup activity can take up to 5 minutes.


**Step-2: Verifying that Tenant Security Solution installation is complete**  

**1:** In the Azure portal, Go to Azure Resource Groups and select the resource group that you have created, you can see multiple resources that has been created.

 ![Resources](../Images/Resource_Group.PNG)

**2:** In the storage resource azsktsstoragexxxxx, Go to queue, a subscription job queue has been created for scheduling the subscriptions. 
	
 ![StorageQueue](../Images/Storage_Queue.PNG)

 **3:** In the resource AzSKTSWorkItemProcessor-xxxxx, Go to webjobs, there are two webjobs created for Inventory and ProcessSubscriptions. 
	
 ![ProcessorWebjobs](../Images/Processor_Webjobs.PNG)

 **4:** In the resource AzSKTSWorkItemScheduler-xxxxx, Go to webjobs, there is one webjob created for JobProcessor. 
	
 ![SchedulerWebjobs](../Images/Scheduler_Webjobs.PNG)


[Back to top…](Readme.md#contents)
## Tenant Security Solution - how it works (under the covers)
The Tenant Security Solution feature is about #TODO

The TSS installation script that sets up Resource Group and the following resources on your subscription:

- Resource group:- 
To scan all the resources from the group

- Storage account  (Name : AzSKTSStorage-xxxxx) :- To store the daily results of resource scans. The storage account is named with few characters from the resource group name with prefix (e.g. AzSKStorage-ocomu)

- Azure App Service :- Creates two App Services to schedule the subscriptions and #TBD Named as AzSKTSWorkItemSchedular-xxxxx and AzSKTSWorkItemHandler-xxxxx

- Azure App Service Plan :- Creates App Service Hosting Plan to #TBD, Named as AzSKTSHostingPlan-xxxxx

- Managed Identity :- Creates App Service Hosting Plan to #TBD, Named as AzSKTSProcessorMI-xxxxx

- LA Workspace :- Log Analytics Workspace to generate logs after scanning resources Named as AzSKTSLAWorkspace-xxxxx



>### Feedback
