
> <b>NOTE:</b>
> This article has been updated to use the new Azure PowerShell Az module. To learn more about the new Az module and AzureRM compatibility, see [Introducing the new Azure PowerShell Az module](https://docs.microsoft.com/en-us/powershell/azure/new-azureps-module-az).

# AzSK setup across multiple tenants

There are scenarios where teams have multiple Azure subscriptions spread across multiple tenants. Typically they can deploy one 'Continuous Assurance' setup per tenant (in central scan mode) and push the AzSK scan results from all of them into a single central Log Analytics workspace. 

The above solution can be simplified using the following steps, albeit with some limitations listed in the end. 

## <b>How to setup cross tenant Continuous Assurance (CA)?</b>

By now you would be aware that when you install CA in your Azure subscription, it adds a service principal runtime account as a 'reader' on that subscription. So when you want to setup CA on subscriptions that are spread across multiple tenants, it would be required that this service principal runtime account has 'reader' access on all those subscriptions.

You can achieve it by using Azure delegated resource management. 
Azure delegated resource management enables logical projection of resources from one tenant onto another tenant.

### <b>Prerequisites</b>:
1. You need to have 'Owner' permissions on all the subscriptions i.e. on which you want to setup CA and the ones which you want to be scanned by CA.
2. You need to know the tenant id of the central subscription i.e. the subscription where the CA automation account and other related components will be installed.
3. You need to know the tenant id(s) of the target subscriptions i.e. subscriptions which your central CA  is supposed to scan.
4. You need to know the subscription ids of the target subscriptions.

### <b>Steps to follow: </b>
1. Install CA in the central subscription using steps [here](https://github.com/azsk/DevOpsKit-docs/tree/master/04-Continous-Assurance#setting-up-continuous-assurance---step-by-step
).
2. Open Azure portal and go to the 'AzSKContinuousAssurance' automation account in 'AzSKRG' resource group in the central subscription.
3. Go to 'Shared Resources > Connections'
4. Click on the 'AzureRunAsConnection' of type 'AzureServicePrincipal' and copy the 'ApplicationId'. This is the application id of the service principal running the CA automation account.
5. Now open 'App registrations' on the Azure portal and search the above 'ApplicationId' under 'All Applications'. You'll find the service principal, click on it, it would show the service principal details. Note down the 'Object Id'.
6. Update the [CrossTenantParams.json](./CrossTenantParams.json) file with the collected prerequisites. 
7. Deploy the [delegatedResourceManagement.json](./delegatedResourceManagement.json) and [CrossTenantParams.json](./CrossTenantParams.json) using the commands below:

    ```PowerShell
    # Log in first with Connect-AzAccount

    # Deploy Azure Resource Manager template using template and parameter file locally
    New-AzDeployment -Name <deploymentName> `
                    -Location <AzureRegion> `
                    -TemplateFile <local path To delegatedReourceManagement.json> `
                    -TemplateParameterFile <local path To CrossTenantParams.json> `
                    -Verbose

    ```
8. You can confirm successful onboarding of the target subscription by going to 'Service Providers' page in target subscription.
9. Once you confirm successful onboarding, you need to update CA in the central subscription by adding new target subsscription id.
10. You need to follow this process for all the target subs that you want to onboard to CA.

## <b>Known limitations</b>
* Currently, you can’t onboard a subscription (or resource group within a subscription) for Azure delegated resource management if the subscription uses Azure Databricks. Similarly, if a subscription has been registered for onboarding with the Microsoft.ManagedServices resource provider, you won’t be able to create a Databricks workspace for that subscription at this time.

* While you can onboard subscriptions and resource groups for Azure delegated resource management which have resource locks, those locks will not prevent actions from being performed by users in the managing tenant. Deny assignments that protect system-managed resources, such as those created by Azure managed applications or Azure Blueprints (system-assigned deny assignments), do prevent users in the managing tenant from acting on those resources; however, at this time users in the customer tenant can’t create their own deny assignments (user-assigned deny assignments).


## <b>References</b>
1. [Azure delegated resource management](https://docs.microsoft.com/en-us/azure/lighthouse/concepts/azure-delegated-resource-management)
