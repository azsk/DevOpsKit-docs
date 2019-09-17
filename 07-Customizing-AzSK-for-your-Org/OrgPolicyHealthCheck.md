
> <b>NOTE:</b>
> The Secure DevOps Kit for Azure (AzSK) was created by the Core Services Engineering & Operations (CSEO) division at Microsoft, to help accelerate Microsoft IT's adoption of Azure. We have shared AzSK and its documentation with the community to provide guidance for rapidly scanning, deploying and operationalizing cloud resources, across the different stages of DevOps, while maintaining controls on security and governance.
<br>AzSK is not an official Microsoft product – rather an attempt to share Microsoft CSEO's best practices with the community..

# AzSK Custom Org Policy Health Check
 
### [Overview](OrgPolicyHealthCheck.md#overview-1)

### [Run Org Policy Health Check](OrgPolicyHealthCheck.md#run-org-policy-health-check-1)

## Overview

#### When and why should I check org policy health 

AzSK keeps on adding and enhancing features with different capabilities to monitor Security compliance for Org subscriptions. During these enhancement in new releases, it may include latest features and also some breaking changes. To provide smoother upgrade and avoid policy break, AzSK provides feature for Org policy to run AzSK components with specific version using configuration(mentioned in AzSK.Pre.json). Currently, we have come up with health and fix script which will validate all mandatory resources and latest configurations are in place. 
It is recommendated to run health scan before and after updating AzSK version for Org. 
Below steps will guide you through steps


## Run Org Policy Health Check

 Validate health of Org policy for mandatory configurations and policy schema syntax issues using below command. You can review the failed checks and follow the remedy suggested.

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
Review failed check and follow remedy suggested to fix issues.

