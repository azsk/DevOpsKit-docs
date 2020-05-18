## 200515 (AzSK v.4.9.0)

### Feature updates

* Privileged Identity Management (PIM):
    *	Earlier, role settings could be configured only for eligible assignments via the setpim cmdlet. We have now expanded support to configure role settings for active assignments at subscription and management group scope by adding new parameters in the setpim cmdlet.
        ```Powershell
        setpim -ConfigureRoleSettings –SubscriptionId $sub -RoleName AcrPull -ExpireActiveAssignmentsInDays 11 -RequireJustificationOnActiveAssignment $true -RequireMFAOnActiveAssignment $true 

        setpim -ConfigureRoleSettings –ManagementGroupId $MGID -RoleName AcrPull -ExpireActiveAssignmentsInDays 11 -RequireJustificationOnActiveAssignment $true -RequireMFAOnActiveAssignment $true
        ```
   

*	AzSK module for Azure DevOps (ADO):
    
    * Introduced custom organization policy feature for central security team of an organization to customize the behavior of various functions and security controls checked by the ADO scanner. This enables project admins to create a policy store and other required components to host and maintain a set of policy files that allow customization of the ADO scanner controls and feature behavior.
    
    * Revamped attestation feature to leverage repos in Azure DevOps for storing control attestation details. 
      * Introduced a new switch -AttestationHostProjectName to specify the project name for storing attestation details for organization-specific controls.
      * Implemented via switch -ControlsToAttest which can be specified in any of the standard security scan cmdlets of the scanner. 
      * Added support for attestation of build, release, service connection and agent pool controls.
      * Organization and project controls can now also be attested via their individual scan cmdlets Get-AzSKAzureDevOpsOrgSecurityStatus and Get-AzSKAzureDevOpsProjectSecurityStatus respectively.
        * Note that attestation for organization and project controls can only be performed with admin privileges on organization and project, respectively
      * Currently, attestation can be performed only via PowerShell session in local machine, but the scan results will be honored in both local as well as extension scan. 
    * Added aliases for individual scan cmdlets for organization, project, build, release, service connection and agent pool.  
     ```Powershell
    gadso -oz "MicrosoftIT" #Organization-specific controls scan

    gadsp -oz "MicrosoftIT" -pn "OneITVSO" #Project-specific controls scan

     ```
    * Updated the resource link for user-specific controls.

    
*	ADO Security Scanner extension::
    
    * Build and release parameters are no more mandatory to run the extension in pipeline.
    * ‘Exception’ status will now be represented in widgets for build, release, service connection and agent pool controls.
    * Note: Security scanner for ADO is also available as a native ADO extension that can be used for Continuous Assurance for ADO security. This also includes widgets to visualize the scan results for various stakeholders (such as org admin, project owners, build/release owners etc.).




* Security Verification Tests (SVTs):
    *	N/A.
* In-cluster security scans for ADB, AKS, HDI Spark:
    * N/A.

* Log Analytics:
    * N/A.

* ARM Template Checker:
    * N/A.

* Org policy/external user updates (for non-CSEO users):
    * N/A.

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
    * Fixed an issue in the Set-AzSKARMPolicies cmdlet which was previously not able to create policy assignment if its definition was already present in the subscription.

* Privileged Identity Management (PIM):
   * N/A.

* SVTs: 
   * Fixed a bug in bulk attestation workflow where previously all the targeted controls were being attested with the same status and justification. Now, -ControlIds parameter is made mandatory and only one control can be bulk attested across resources at a time.
    


* Controls:
    * Resolved an issue in the subscription ARM policy control to emit failed status if the ARM policy assignment is disabled in the subscription.
    * Added a new control Azure_AppService_AuthN_Redirect_To_Login_Page to check whether authentication is configured at root page of an app service.
    * Virtual machine guest policy health control has been updated to check for compliance of guest policies and initiatives as configured via organization policy. Previously, the control used to check compliance for all health policies deployed on the machine.

* ARM Template Checker:
    * N/A.

* CA:
    * N/A.

* In-cluster CA:
    * N/A. 

* Security scanner for Azure DevOps (ADO):

    * Control for installed extensions in an organization will filter out built-in extensions from scans.
    * Project visibility control will now pass when either ‘Private’ or ‘Enterprise’ visibility is enabled for the project.
    * Fixed an issue in the control AzureDevOps_Build_AuthZ_Disable_Inherited_Permissions which was earlier reporting failed state even when the inherited permissions on the pipeline were disabled.
    * Trimmed state data for organization and project baseline controls without impacting its meaning.
    * Fixed a bug where previously attestation drift was not being detected in a scenario in some stateful controls.
    * Rectified tags for organization and project controls.
    * Control settings file has been trimmed to make it relevant only to the ADO scanner (removed Azure-specific residues).
    * Fixed an issue in Get-AzSKAzureDevOpsProjectSecurityStatus cmdlet to make the -ProjectNames parameter mandatory.

* Log Analytics:
    * N/A.

* Known issues:
    * Late in the test pass, we found that below Cosmos DB controls are resulting into error due to recent API changes:
      * Azure_CosmosDB_AuthZ_Enable_Firewall
      * Azure_CosmosDB_AuthZ_Verify_IP_Range
