## 190916 (AzSK v.4.1.0)

### Feature updates

* Security Verification Tests (SVTs):
	* New SVTs for two Azure services - Azure Database for MySQL and PostgreSQL.
	* Automated controls include checks for firewall & virtual network rules, SSL connection, backup & disaster recovery, advanced threat protection and diagnostic settings as applicable.


* (Preview) Security IntelliSense (SecIntel) extension for Visual Studio Code: 
  * SecIntel for Visual Studio Code can downloaded from [here](https://marketplace.visualstudio.com/items?itemName=azsdktm.SecurityIntelliSense).
  * This is a VS Code editor extension mainly targeted towards providing quick and inline security suggestions and fixes for Azure related C# source code, web projects and crypto-related code.
*	Privileged Identity Management (PIM):
    * We have added capabilities for admin to configure role settings like maximum activation duration, maximum allowed days for assignment and MFA requirement on activation for a specific role on a resource using the below command
    
      setpim -ConfigureRoleSettings -SubscriptionId $subid -RoleName $roleName -ExpireEligibleAssignmentsInDays 30 

*	(Preview) Credential Hygiene:
    *	We have introduced the concept of 'credential groups' wherein a set of credentials belonging to a specific application/functionality can be tracked together for expiry notifications.
*	ARM Template Checker:
    *	N/A.
    
* CICD:
    * N/A.

*	In-cluster security scans for ADB, AKS, HDI Spark
    * N/A.

*	Log Analytics:
    *	N/A.

*	Org policy/external user updates (for non-CSEO users):
    *	Support for AzSK-based telemetry (Log Analytics and Application Insights) features in Azure US Government and Azure China.
    * Documentation covering end-to-end org policy scenarios with hands-on code examples will be published in the org policy section this week.  
    * Added support for org policy debug mode to extend ARM Checker controls.

Note: The next few items mention features from recent releases retained for visibility in case you missed those release announcements:

*	Credential Hygiene helper cmdlets (from last sprint)  
    * New-AzSKTrackedCredential to onboard a credential for tracking via DevOps Kit. You can set the reminder period (in days) for the credential.
    * Get-AzSKTrackedCredential to list the onboarded credential(s).
    * Update-AzSKTrackedCredential to update the credential settings and reset the last updated timestamp.
    * Remove-AzSKTrackedCredential to deboard a credential from AzSK tracking.

*	Privileged Identity Management (PIM) helper cmdlets (from last sprint)  
    *	Set-AzSKPIMConfiguration for configuring/changing PIM settings
    * Get-AzSKPIMConfiguration for querying various PIM settings/status
    * Activating your PIM role is now as simple as this:
    setpim -ActivateMyRole -SubscriptionId $s5 -DurationInHours 8 -Justification 'ad hoc test' -RoleName Owner
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

### Other improvements/bug fixes
*	Subscription Security:
    *	N/A.
*	SVTs: 
    *	N/A.
*	Controls:
     *	For the justify admins/owners control, the attested data will now show the sign-in names as well.
    * Fixed CORS access and restricted IP callers controls for API Management which were previously throwing error.
*	ARM Template Checker:
    *	Following new controls have been added to ARM Checker:
      *	Azure_AnalysisServices_BCDR_Plan
      *	Azure_AppService_DP_Use_Approved_TLS_Version
      *	Azure_ContainerRegistry_Configure_Webhook_For_Vuln_Scan
      *	Azure_ContainerRegistry_DP_Enable_Content_Trust
      *	Azure_RedisCache_BCDR_Use_RDB_Backup
      *	Azure_Search_AuthN_Use_Managed_Service_Identity
      *	Azure_VNet_NetSec_Configure_NSG
      *	Azure_VNet_NetSec_Justify_Peering

*	CA:
    *	N/A. 

*	Privileged Identity Management (PIM)
    * Fixed an issue where activating PIM role at resource level wasn�t working before. 
    * While extending PIM assignments using the Set-AzSKPIMConfiguration cmdlet, if the provided assignment duration exceeds the maximum allowed days for assignment, the command will assign role only for the maximum allowed days.
    * Assignment state of eligible roles will now be displayed when Get-AzSKPIMConfiguration cmdlet is used with -ListMyEligibleRoles switch.

* Azure DevOps (ADO/VSTS)
   * Configured and released AzSK module for Azure DevOps based on the restructured core framework.

*	Log Analytics
    *	N/A.

* Other
	 * Updated the minimum required version for CA runbook, alerts and ARM policies. This can be verified for your subscription using the command Get-AzSKInfo -SubscriptionInfo.

