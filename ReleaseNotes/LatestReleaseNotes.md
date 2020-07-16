## 200715 (AzSK v.4.11.0)

### Feature updates

* Management of DevOps Kit-based AAD applications:
    * Added support for listing all the DevOps Kit-based service principals (used in continuous assurance) that are owned by the user via the Get-AzSKInfo cmd. It will list all such applications that have been actively in use.
    ```Powershell
        Get-AzSKInfo –InfoType SPNInfo
    ```

*	Security scanner for Azure DevOps (ADO)/ADO Security Scanner extension:
    
    * Introduced capability to log bugs in ADO for control failures of your ADO resources.
    * Added a dashboard in Log Analytics to support alerting and monitoring for ADO resources across the organization.
    * Check-pointing behavior has been enhanced to support durable (server-based) checkpoints.
    * Control attestation workflow has been enhanced so that the updated control status reflects immediately on the extension dashboard/log analytics workspace.
    * Added soft protection to restrict users from scanning larger number of resources (>1000) in an organization

* Security Verification Tests (SVTs):
    *	N/A.

* In-cluster security scans for ADB, AKS, HDI Spark:
    * N/A.

* Log Analytics:
    * N/A.

* ARM Template Checker:
    * N/A.

* Org policy/external user updates (for non-CSEO users):
    * Added SVT for ‘public IP address’ as a service to optionally treat each public IP address as an individual resource. To enable this behavior, refer the docs here.
    * Fixed an issue to enable Get-AzSKOrganizationPolicyStatus command to work in Linux-based containers.
    * Key Vault, CDN and Databricks control JSON files have been sanitized to remove hidden BOM/extended characters. Org policy admins should procure a fresh copy of these files from the module and replicate the overridden changes (if any). 

Note: The next few items mention features from recent releases retained for visibility in case you missed those release announcements:

*	Security Scanner for Azure DevOps (ADO) 
    *	You can try the scan cmdlet using:
    ```Powershell
    #ADO scan cmdlet is in a separate module called AzSK.AzureDevOps!
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
    * The subscription controls below will not be evaluated in local scan mode unless the corresponding control ids are specified explicitly in the command. This is done because these controls require substantial amount of time for evaluation.

        * Azure_Subscription_Configure_Conditional_Access_for_PIM_RG
        * Azure_Subscription_AuthZ_Dont_Grant_Persistent_Access_RG
        * Azure_Subscription_Use_Only_Alt_Credentials
        ```Powershell
        gss -s $sub -cid ‘Azure_Subscription_AuthZ_Dont_Grant_Persistent_Access_RG’
        ```
 
    * Results of persistent access (PIM) controls for subscription and resource group scope will not fluctuate in case the underlying API call throws exception.

* Privileged Identity Management (PIM):
   * Fixed an issue regarding activation of PIM role assignments where previously it was leading to an error if the role was assigned for the same scope for both direct and group assignments.

* SVTs: 
   * N/A.
    
* Controls:
    * States for below controls will not fluctuate if they are scanned with insufficient permissions (leading to manual control state):

        * Azure_AppService_DP_Website_Load_Certificates_Not_All
        * Azure_AppService_DP_Restrict_CORS_Access
        * Azure_AppService_AuthN_Use_Managed_Service_Identity
        * Azure_KeyVault_AuthN_Dont_Share_KeyVault_Unless_Trust
        * Azure_KeyVault_AuthN_Use_Cert_Auth_for_Apps

    * Trimmed state data of public IP address control for VMs which was previously causing unwanted state drift due to data fields unrelated to IP address.

    * Spelling errors in two controls below have been fixed:

        * Azure_DataFactory_AuthN_DataLakeStore_LinkedService
        * Azure_DataFactory_BCDR_Multiple_Node_DMG

* ARM Template Checker:
    * N/A.

* CA:
    * Fixed an issue in the CA check-pointing logic in scenarios where previously if a resource type does not have any applicable/enabled controls, CA scans were getting stuck at that resource.

* In-cluster CA:
    * N/A. 

* Log Analytics:
    * N/A.

* Known issues:
    * N/A.
