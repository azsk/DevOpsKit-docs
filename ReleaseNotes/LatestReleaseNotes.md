## 200114 (AzSK v.4.5.0)

### Feature updates

* Continuous Assurance (CA) – Runbook throttling issues for large subscriptions:
    * For the last few sprints, we had been investigating some recurrent issues which were causing CA runbook scans to abruptly terminate for a few CSEO subscriptions.The CA runbook scan happens inside a container that is deployed with certain memory, CPU, networking thresholds imposed by Azure Automation service runtime. If any of the thresholds are exceeded, Azure Automation terminates the container (and, as a result, the scan remains incomplete).While this was mostly happening in some of the larger subscriptions (several thousand resources), we were also observing the same symptoms in the occasional small subscription.

    * In the current sprint, we were able to identify and address most of the root causes leading to this resource exhaustion during CA scans. The fixes involved performance tuning at various layers (AzSK module code, control status/inventory reporting API, backend stored procedures, etc.). Furthermore, we improved the logic so that if the resource bottleneck was caused by a specific resource (e.g., a vNet with too many NIC configurations), we skip past that after a fixed number of retries. We also put in additional telemetry and diagnostic indications that would help us identify root causes quicker in future investigations.

    * As a result of these changes, more resources will become visible from a compliance standpoint. Additionally, due to optimization in the state saved, attestation for some controls may show a drift. Also, in a few cases, we may skip certain controls in CA if we find that the resources consumed would cause the scan to terminate. (We are looking at a container-based solution that might alleviate this issue.)

    * The following controls (belonging to respective resource types) were modified as part of this optimization effort:
        * Virtual network (vNet,ErVNet)
            * Azure_VNet_NetSec_Justify_PublicIPs
            * Azure_VNet_NetSec_Justify_IPForwarding_for_NICs
            * Azure_ERvNet_NetSec_Dont_Enable_IPForwarding_for_NICs
            * Azure_ERvNet_NetSec_Dont_Use_PublicIPs 

        * SQL Database
            * Azure_SQLDatabase_Audit_Enable_Threat_Detection_Server
            * Azure_SQLDatabase_Audit_Enable_Logging_and_Monitoring_Server

        * API Management
            * Azure_APIManagement_DP_Restrict_CORS_Access
            * Azure_APIManagement_AuthZ_Restrict_Caller_IPs
            * Azure_APIManagement_AuthZ_Enable_Requires_Subscription
            * Azure_APIManagement_DP_Remove_Default_Products
            * Azure_APIManagement_DP_Restrict_Critical_APIs_Access
            * Azure_APIManagement_AuthZ_Validate_JWT
            * Azure_APIManagement_AuthZ_Enable_User_Authorization_For_API

        * Service Bus
            * Azure_ServiceBus_AuthZ_Use_Minimum_Access_Policies
        * SubscriptionCore
            * Azure_Subscription_SI_Lock_Critical_Resources


* Security Verification Tests (SVTs):
    * N/A.

* Privileged Identity Management (PIM):
    * N/A.

* In-cluster security scans for ADB, AKS, HDI Spark:
    * N/A.

* Log Analytics:
    * N/A.

* ARM Template Checker:
    * N/A.

* Org policy/external user updates (for non-CSEO users):
    * N/A.

Note: The next few items mention features from recent releases retained for visibility in case you missed those release announcements:

*	(Preview) AzSK module for Azure DevOps (ADO/VSTS) 
    *	You can try the scan cmdlet using:
    ```Powershell
    #VSTS scan cmdlet is in a separate module called AzSK.AzureDevOps!
    Install-Module AzSK.AzureDevOps -Scope CurrentUser -AllowClobber    
    Get-AzSKAzureDevOpsSecurityStatus -OrganizationName "MicrosoftIT"`
                                        -ProjectNames "OneITVSO"`
                                        -BuildNames "build_name_here"`
                                        -ReleaseNames "release_name_here"  
    ```

*	Credential Hygiene helper cmdlets  
    * ```New-AzSKTrackedCredential``` to onboard a credential for tracking via DevOps Kit. You can set the reminder period (in days) for the credential.
    * ```Get-AzSKTrackedCredential``` to list the onboarded credential(s).
    * ```Update-AzSKTrackedCredential``` to update the credential settings and reset the last updated timestamp.
    * ```Remove-AzSKTrackedCredential``` to deboard a credential from AzSK tracking.

*	Privileged Identity Management (PIM) helper cmdlets (from last sprint)  
    * ```Set-AzSKPIMConfiguration``` (alias ```setpim```) for configuring/changing PIM settings
    * ```Get-AzSKPIMConfiguration``` (alias ```getpim```) for querying various PIM settings/status
    * Activating your PIM role is now as simple as this:
    
    ``` setpim -ActivateMyRole -SubscriptionId $sub -RoleName Owner -DurationInHours 8 -Justification 'ad hoc test'  ```
    * See docs [here](https://github.com/azsk/DevOpsKit-docs/blob/master/01-Subscription-Security/Readme.md#azsk-privileged-identity-management-pim-helper-cmdlets-1) for more.

*	(Preview) Security Scan for Azure Active Directory (AAD)
    *	You can scan security controls for your AAD tenant (as either an admin or even as a regular user) using the DevOps Kit AAD Security Scan module.
    *	Use following steps:
        ```Powershell
        # AAD scan cmdlets are packaged as a separate module (AzSK.AAD)
        Install-Module AzSK.AAD -Scope CurrentUser -AllowClobber
        Import-Module AzSK.AAD
        Get-AzSKAADSecurityStatusTenant    # check the tenant (admin)
        Get-AzSKAADSecurityStatusUser      # check objects you own (user)
        ``` 
    *	Caveats: 
        * Do not run these in the same PS session as AzSK. Start a new PS console.
        * Az- modules require .Net Framework v4.7.2.
        * By default, the current cmdlets will scan just 3 objects of each type (Apps/SPNs/Groups, etc.). This is until we work out how best to group/batch scans when scanning the entire tenant. If you want to scan more objects you can use the '-MaxObj' switch in the cmdlets.



### Other improvements/bug fixes
* Subscription Security:
    * Azure Security Center (ASC) alerts/notifications control will now fail for high severity alerts without any grace period considerations. It will also fail if there are medium severity alerts that have not been addressed for more than 30 days.
    * Added a new control Azure_Subscription_Use_Only_Alt_Credentials to check PIM assignments for non SC-ALT accounts with critical privileges (user access admin, owner & contributor) at subscription scope. This control currently requires graph access on the subscription.


* Privileged Identity Management (PIM):
    * N/A.
    
* SVTs: 
    * N/A.

* Controls:
    * Fixed an issue to better handle BOM/special characters in control/metadata state.
 

* ARM Template Checker:
    * Fixed an issue in checking the .NET framework version for app service ARM template in the control Azure_AppService_Deploy_Use_Latest_Version.


* CA:
    * ``` Get-AzSKContinuousAssurance ``` cmdlet has been improved to check for suspended jobs (in the last 3 days) and automation runbook scan logs in the DevOps Kit storage account in the subscription. 

* In-cluster CA:
    * N/A. 

* Azure DevOps (ADO/VSTS):
    * N/A.

* Log Analytics:
    * N/A.

* Other
    * N/A.
