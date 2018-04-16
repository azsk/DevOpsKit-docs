# Getting started with the Secure DevOps Kit for Azure!

If you have just installed the Secure DevOps Kit for Azure (a.k.a. AzSK) and are not familiar with 
its functionality, then you can get started with the 2 most basic use cases of AzSK by going through 
the following getting started guides:
- [Scan the security of your subscription](GettingStarted_SubscriptionSecurity.md)
- [Scan the security of your cloud application](GettingStarted_AzureServiceSecurity.md)  

Thereafter, you can explore individual features further using the table of contents below which has 
pointers to full help on individual features by feature area.

> **Note:** If you have not installed the DevOps Kit yet, follow the instructions in the [installation guide](../00a-Setup/Readme.md) and then come back here.

> **PowerShell Tips for AzSK:** 
> If you are new to PowerShell, then you will find several useful tips in our [PowerShell tips for new AzSK Users](GettingStarted_PowerShellTipsAzSK.md) guide 
> handy to accelerate your initial learning curve for PowerShell competencies needed to use AzSK effectively.

The overall set of features in the Secure DevOps Kit for Azure are organized by the 6 areas as shown 
in the table below:  


|Feature Area | Secure DevOps Kit Feature|
|-------------|--------------------------|
[Subscription Security](../01-Subscription-Security/Readme.md) | <ul><li>Subscription Security Health Check</li> <li>Subscription Provisioning<ul><li> Alerts Configuration</li>  </li> <li>ARM Policy Configuration</li> <li>Azure Security Center (ASC) Configuration</li><li>Access control (RBAC) Hygiene</li>  </ul> </li></ul>
[Secure Development](../02-Secure-Development/Readme.md) | <ul><li>Security Verification Tests (SVTs) </li><li>Security IntelliSense VS Editor Extension </li></ul>
[Security in CICD](../03-Security-In-CICD/Readme.md) | <ul><li>AzSK-SVTs VSTS extension for injecting security tests in a CICD pipeline </li></ul>
[Continuous Assurance](../04-Continous-Assurance/Readme.md) | <ul><li>Security scanning of Azure subscription and applications via automation runbooks</li></ul>
[Alerting & Monitoring](../05-Alerting-and-Monitoring/Readme.md) | <ul><li>Leveraging OMS towards:<ul><li>Single pane view of security across dev ops stages</li><li>Security alerts based on various search conditions.</li></ul></li></ul>
[Cloud Risk Governance](../06-Security-Telemetry/Readme.md) | <ul><li>Support for control state attestation and security governance dashboards. </li></ul> 

## List Of AzSK commands

|Command|What it does|	Role/Permission|
|----|----|-----|
|Get-AzSKAzureServicesSecurityStatus (GRS)|Scans a set of RGs (or the entire subscription)|Reader on subscription or respective RGs|
|Get-AzSKContinuousAssurance (GCA)|Validates the status of Continuous Assurance automation account including the condition of various artifacts such as storage account, schedules, runbooks, SPN/connection, required modules, etc.|Reader on subscription.|
|Get-AzSKControlsStatus (GCS)|Single cmdlet that combines Get-AzSKSubscriptionSecurityStatus, Get-AzSKAzureServicesSecurityStatus|Union of permissions.|
|Get-AzSKExpressRouteNetworkSecurityStatus (GES)|Validate secure configuration of ER-connected vNets. Also validates custom/supporting protections |Reader on ERNetwork, Reader on sub.|
|Get-AzSKSubscriptionSecurityStatus (GSS)|Scans an Azure subscription for security best practices and configuration baselines for things such as alerts, ARM policy, RBAC, ASC, etc.|Reader on subscription|
|Get-AzSKSupportedResourceTypes|Lists the currently supported Azure service types in AzSK. Basically, all resources in this list have SVTs available and these SVTs will be invoked whenever Get-AzSKAzureServicesSecurityStatus is run.|NA.|
|Get-AzSKInfo|This command would help users to get details of various components of AzSK. |Reader on subscription, Contributor on AzSKRG|
|Install-AzSKContinuousAssurance (ICA)|Sets up continuous assurance for a subscription. This creates various artifacts such as resource group, storage account and automation account| Owner on subscription.|
|Install-AzSKOMSSolution (IOM)|Creates and deploys an OMS view in a subscription that has an OMS workspace. The OMS view provides visibility to application state across dev ops stages. It also creates alerts, common search queries, etc.	|Reader on subscription.|
|Remove-AzSKAlerts (RAL)|Removes the alerts configured by AzSK.|Owner on subscription.|
|Remove-AzSKARMPolicies (RAP)|Removes the ARM policy configured by AzSK.|Owner on subscription.|
|Remove-AzSKContinuousAssurance (RCA)|Removes the AzSK CA setup (including, optionally, the container being used for storing reports).|Reader on subscription.|
|Remove-AzSKSubscriptionRBAC (RRB)|Removes the RBAC setup by AzSK. By default "mandatory" central accounts are not removed and "deprecated" accounts are always removed.|Owner on subscription.|
|Remove-AzSKSubscriptionSecurity (RSS)|Removes the configuration done via Set-AzSKSubscriptionSecurity. It invokes the individual remove commands for RBAC, ARM policy, Alerts and ASC.|Owner on subscription.|
|Repair-AzSKAzureServicesSecurity (FRS)|Fixes the security controls for various Azure resources using the automated fixing scripts generated by running the AzSK scan command "Get-AzSKAzureServicesSecurityStatus" with the '-GenerateFixScript' flag.|Contributor on subscription or respective RGs |
|Repair-AzSKSubscriptionSecurity (FSS)|Fixes the subscription security related controls using the automated fixing scripts generated by running the AzSK scan command "Get-AzSKSubscriptionSecurityStatus" with the '-GenerateFixScript' flag.|Contributor on subscription|
|Set-AzSKAlerts (SAL)|Sets up activity alerts for the subscription. Includes alerts for subscription and resource specific activities. Alerts can be scopes to subscription or RGs.<br>This is internally called by Set-AzSKSubscriptionSecurity.|Owner on subscription.
|Set-AzSKARMPolicies (SAP)|Sets up a core set of ARM policies in a subscription.<br>This is internally called by Set-AzSKSubscriptionSecurity.|Owner on subscription.|
|Set-AzSKAzureSecurityCenterPolicies (SSC)|Sets up ASC policies and security points of contact. <br>This is internally called by Set-AzSKSubscriptionSecurity.|Reader on subscription.|
|Set-AzSKEventHubSettings |Configures AzSK to send scan results to the provided EventHub. Currently available only in 'ad hoc' or 'SDL' mode.|NA|	
|Set-AzSKLocalControlTelemetrySettings|The command configures the AzSK toolkit to send data to the given Applications Insights account from user's machine.|NA|
|Set-AzSKOMSSettings|Configures AzSK to send scan results to the provided OMS workspace. Events can be sent to OMS from 'ad hoc'/SDL mode (via this configuration) or from CICD by specifying OMS settings in a variable or from CA by specifying OMS settings in the CA installation command.|Reader on subscription.|
|Set-AzSKPolicySettings|Configures the server URL that is used by AzSK to download controls and config JSON. If this is not called, AzSK runs in an 'org-neutral' mode using a generic policy. Once this command is called, AzSK gets provisioned with the URL of a server/CDN where it can download control/config JSON from.|Reader on subscription.|
|Set-AzSKSubscriptionRBAC (SRB)|Sets up RBAC for a subscription. Configures "mandatory" accounts by default and function/scenario specific accounts if additional "tags" are provided.|Owner on subscription.|
|Set-AzSKSubscriptionSecurity (SSS)|Master command that takes combined inputs and invokes the individual setup commands for RBAC, ARM policy, Alerts and ASC.|Owner on subscription.|
|Set-AzSKUsageTelemetryLevel|Command to switch the default TM level for AzSK. The generic version of AzSK comes with 'Anonymous' level telemetry. The other levels supported is 'None'. |NA|	
|Set-AzSKLocalAIOrgTelemetrySettings|Command to set local control telemetry settings. |NA|	
|Set-AzSKWebhookSettings|Configures AzSK to send scan results to the provided webhook. Currently available only in 'ad hoc' or 'SDL' mode.<br>This capability can be used to receive AzSK scan results in arbitrary downstream systems. (E.g., Splunk)|NA|
|Set-AzSKUserPreference|This command can be used to set user preferences (e.g.: output folder path) for AzSK commands.|NA|
|Install-AzSKOrganizationPolicy|This command is intended to be used by central Organization team to setup Organization specific policies. |Contributor on subscription|
|Update-AzSKContinuousAssurance (UCA)|Updates various parameters that were used when CA was originally setup. This command can be used to change things like target resource groups that were scanned, OMS workspaceID and sharedKey, run as account used by CA for scanning, update/renew certificate credential as run as account. | Owner on subscription.|
|Update-AzSKSubscriptionSecurity (USS)|This command can be used to update various security baseline elements and bring your subscription up to speed from a baseline policy compliance of subscription security controls. It updates one or more of the following elements after checking the ones that are out of date - alerts, Security Center, ARM policy, RBAC (mandatory accounts and deprecated accounts), continuous assurance runbook, etc.|Owner on subscription.|
|Update-AzSKOrganizationPolicy|This command is intended to be used by central Organization team to update Organization specific policies. |Contributor on subscription|


