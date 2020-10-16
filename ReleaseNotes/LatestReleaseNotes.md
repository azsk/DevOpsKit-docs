## 201015 (AzSK v.4.14.0)

### Feature updates

*   CA SPN old credentials cleanup:

    *	In the previous sprint, we had added support for deleting older certificate credentials when renewing the certificate for AzSK CA SPN. To allow users to request just deletion of older credentials (without necessarily renewing the current credential), we have added the -DeleteOldCredentials switch as under:
    
    ```Powershell
        Update-AzSKContinuousAssurance –sid $sub -DeleteOldCredentials
    ```


*	Security scanner for Azure DevOps (ADO)/ADO Security Scanner extension:
    
    *	The key highlights for the Azure DevOps (ADO) security scanner release are support for (a) setting up Azure-hosted continuous assurance scans with Owner access only at the target RG level, (b) scanning all resources associated with a specific service and (c) various admin control improvements. This release has been deployed for CSEO-wide consumption and a dashboard is available at https://aka.ms/adoscanner/dashboard.
    *   [Click here](https://idwebelements/GroupManagement.aspx?Group=azskadop&Operation=join) to subscribe to get detailed feature updates of ADO security scanner.



* Security Verification Tests (SVTs):
    *	N/A.


* Log Analytics:
    * N/A.


* ARM Template Checker:
    * N/A.


* Org policy/external user updates (for non-CSEO users):
    *   Added support to enable/disable anonymous usage telemetry for CA and CICD scans.
    *   For CA, this can be done by using -UsageTelemetryLevel flag as below:  
        
        ```Powershell
        Update-AzSKContinuousAssurance –sid $sub -UsageTelemetryLevel None
        ```

    *	For CICD, a ‘UsageTelemetryLevel’ pipeline variable can be set to ‘None’ in the pipeline         definition.
    *	For either case, the value Anonymous can be used to re-enable usage telemetry.

    *	Note that, in local usage mode, this facility was always available via the command below:
    
        ```Powershell
        Set-AzSKUsageTelemetryLevel -Level None
         ```

Note: The next few items mention features from recent releases retained for visibility in case you missed those release announcements:

*	Management of DevOps Kit-based AAD applications:
    *	You can list all the DevOps Kit-based service principals (used in continuous assurance) that are owned by you via the Get-AzSKInfo cmd marking those that are actively used for CA scans.
    
        ```Powershell
         Get-AzSKInfo –InfoType SPNInfo
          ```

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
    *   NA
    
* SVTs: 
    *	Going forward, control attestation using older modules will be blocked in non-SAW environments.

* Controls:
    *	Fixed an issue in the TLS control for APIM which was earlier reporting incorrect result for resources in consumption tier.
    *   Fixed an issue in Azure_CDN_DP_Enable_HTTPS control which was earlier resulting into error state for ‘Verizon’ and ‘Akamai’ options.

* Privileged Identity Management (PIM):
   *	N/A.
         
*	CICD: 
    *	N/A.

* ARM Template Checker:
    *    N/A.

* CA:
    *	Added support to display the currently in-use service principal name in the output of ```Get-AzSKContinuousAssurance``` command.

* In-cluster CA:
    *    N/A. 

* Log Analytics:
    *   Added support for the -Force switch so that Log Analytics based monitoring solution can be installed using ```Install-AzSKMonitoringSolution``` without user interaction/consent if a view with the same name already exists.

* Others:
    *   Fixed a bug in ```Get-AzSKInfo -InfoType ControlInfo``` when run with -UseBaselineControls/-UsePreviewBaselineControls/-FilterTags flags was previously resulting into error due to internal caching of policy files.
    *   Behavior of ```Get-AzSKInfo -InfoType ControlInfo``` has been rectified to report information of public IP address controls only when an org has enabled their evaluation.
    *   Fixed an issue in credential hygiene cmdlets where alerts for credentials nearing expiry were not triggered due to change in the underlying product API.
    *   ```Get-AzSKExpressRouteNetworkSecurityStatus``` command will not throw exception even if no control ids are specified.

