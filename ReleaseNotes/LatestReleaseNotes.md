## 200415 (AzSK v.4.8.0)

### Feature updates

* Privileged Identity Management (PIM):
    *	Added a new switch -ConfigureRoleSettings in the setpim cmdlet to configure role settings at management group scope.
        ```Powershell
        setpim -ConfigureRoleSettings –ManagementGroupId $MGID -RoleName Reader -MaximumActivationDuration 7 -ExpireEligibleAssignmentsInDays 11 -RequireJustificationOnActivation $true -RequireMFAOnActivation $true
        ```
    *	Added a new switch -ListRoleSettings in the getpim cmdlet to list role settings in a subscription.
        ```Powershell
        getpim –ListRoleSettings -SubscriptionId $sub -RoleName Owner
        ```
        *	Added support in the setpim cmdlet to assign active roles to users.
        ```Powershell 
        setpim -AssignRole – SubscriptionId $sub -RoleName Owner -DurationInDays 10 -PrincipalNames ‘abc@microsoft.com’ -AssignmentType Active
        ```



*	AzSK module for Azure DevOps (ADO):
    *	Introduced attestation feature that empowers users to support scenarios where human input is required to augment or override the default control evaluation status from the toolkit.
        *	Implemented via a new switch -ControlsToAttest which can be specified in any of the standard security scan cmdlets of the toolkit. 
        *	Attestation is currently supported only for organization and project controls with admin privileges on organization and project, respectively.
        *	Currently, attestation can be performed only via PowerShell session in local machine, but the scan results will be honored in both local as well as extension scan.
    *	Added widget to visualize scan results of agent pools in a project.
    *	Scan reports are now segregated by individual projects and results for every build can be viewed individually in the extension dashboard.
    *	Scan reports can now also be downloaded from the build pipeline logs.
    *	Service connection parameter is no more mandatory to run the extension in pipeline.
    *	Enhanced a project control to evaluate different project visibility options.
    *	Fixed an issue in the control AzureDevOps_Organization_Review_Project_Collection_Accounts which was earlier reporting manual state for passed scenario.
    *	Fixed a bug with -UsePreviewBaselineControls switch which when used was scanning all the controls earlier.
    *	Baseline information of controls will now be displayed in scan reports. 
    *	Note: The DevOps Kit scanner for ADO is also available as a native ADO extension that can be used for Continuous Assurance for ADO security. This also includes widgets to visualize the scan results for various stakeholders (such as org admin, project owners, build/release owners etc.).


* Security Verification Tests (SVTs):
    *	We have reviewed all AzSK controls and marked those that touch on network security (firewall, ports, etc.) with the 'NetSec' tag. You can target these controls using the -FilterTags 'NetSec' parameter.
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
    * Fixed an issue in the Set-AzSKAzureSecurityCenterPolicies cmdlet which was previously resulting into error for policy assignments explicitly set from the portal.

* Privileged Identity Management (PIM):
   * Switched to a different PIM API to address a timeout issue in the cmdlets.

* SVTs: 
   * Fixed an issue with the behavior of -FilterTags switch which was not working as expected when used in conjugation with -UseBaselineControls switch.
   * You can now combine the -UseBaselineControls and -FilterTags like below to scan just the controls that CA does not check: 
        ```Powershell
        grs -s $subId -ubc -FilterTags OwnerAccess
        ```


* Controls:
    * N/A

* Privileged Identity Management (PIM):
    * N/A


* ARM Template Checker:
    * N/A.

* CA:
    * N/A.

* In-cluster CA:
    * N/A. 

* Azure DevOps (ADO/VSTS):
    * N/A.

* Log Analytics:
    * N/A.

* Other
    * N/A.
