> The Secure DevOps Kit for Azure (AzSK) was created by the Core Services Engineering & Operations (CSEO) division at Microsoft, to help accelerate Microsoft IT's adoption of Azure. We have shared AzSK and its documentation with the community to provide guidance for rapidly scanning, deploying and operationalizing cloud resources, across the different stages of DevOps, while maintaining controls on security and governance.
<br>AzSK is not an official Microsoft product – rather an attempt to share Microsoft CSEO's best practices with the community..
# FAQs

- ### Setup
  - [Should I run PowerShell ISE as administrator or regular user?](../00a-Setup/Readme.md#should-i-run-powershell-ise-as-administrator-or-regular-user)
  - [Error message: "Running scripts is disabled on this system..."](../00a-Setup/Readme.md#error-message-running-scripts-is-disabled-on-this-system)
  - [Error message: "PackageManagement\Install-Package: cannot process argument transformation on parameter 'InstalledModuleInfo'..."](../00a-Setup/Readme.md#error-message-packagemanagementinstall-package-cannot-process-argument-transformation-on-parameter-installedmoduleinfo)
  - [Error message: "WARNING: The version '1.x.y' of module 'Az.Accounts' is currently in use. Retry the operation after closing..."](../00a-Setup/Readme.md#error-message-warning-the-version-1xy-of-module-azaccounts-is-currently-in-use-retry-the-operation-after-closing)
  - [Error message: "The property 'Id' cannot be found on this object. Verify that the property exists..."](../00a-Setup/Readme.md#error-message-the-property-id-cannot-be-found-on-this-object-verify-that-the-property-exists)
  - [Message: "Warning : Microsoft Azure PowerShell collects data about how users use PowerShell cmdlets..."](../00a-Setup/Readme.md#message-warning--microsoft-azure-powershell-collects-data-about-how-users-use-powershell-cmdlets)
  - [When will AzSK support the newest Az dependencies? Can I run both side by side? In the meantime, what if I need to run both AzSK and the new version of Az modules (for different tasks)?](../00a-Setup/Readme.md#when-will-azsk-support-the-newest-az-dependencies-can-i-run-both-side-by-side-in-the-meantime-what-if-i-need-to-run-both-azsk-and-the-new-version-of-az-modules-for-different-tasks)
  - [How often should I upgrade my installation of AzSK? How long will it take?](../00a-Setup/Readme.md#how-often-should-i-upgrade-my-installation-of-azsk-how-long-will-it-take)
  
- ### Subscription-Security
  - #### AzSK: Subscription Security Provisioning
    - [Is it possible to setup an individual feature (e.g., just alerts or just ARM Policy)?](../01-Subscription-Security/Readme.md#is-it-possible-to-setup-an-individual-feature-eg-just-alerts-or-just-arm-policy)

    - [Set-AzSKSubscriptionSecurity  or Set-AzSKAzureSecurityCenterPolicies returns - InvalidOperation: The remote server returned an error: (500) Internal Server Error?](../01-Subscription-Security/Readme.md#set-azsksubscriptionsecurity--or-set-azskazuresecuritycenterpolicies-returns---invalidoperation-the-remote-server-returned-an-error-500-internal-server-error)


  - #### AzSK: Subscription Activity Alerts  
    - [Can I get the alert emails to go to a distribution group instead of an individual email id?](../01-Subscription-Security/Readme.md#can-i-get-the-alert-emails-to-go-to-a-distribution-group-instead-of-an-individual-email-id)
    - [How can I find out more once I receive an alert email?](../01-Subscription-Security/Readme.md#how-can-i-find-out-more-once-i-receive-an-alert-email)
    - [Is there a record maintained of the alerts that have fired?](../01-Subscription-Security/Readme.md#is-there-a-record-maintained-of-the-alerts-that-have-fired)
  - #### AzSK: Subscription Security - ARM Policy
    - [What happens if an action in the subscription violates the policy?](../01-Subscription-Security/Readme.md#what-happens-if-an-action-in-the-subscription-violates-the-policy)
    - [Which ARM policies are installed by the setup script?](../01-Subscription-Security/Readme.md#which-arm-policies-are-installed-by-the-setup-script)
    - [How can I check for policy violations?](../01-Subscription-Security/Readme.md#how-can-i-check-for-policy-violations)
    - [Are there more policies available for use?](../01-Subscription-Security/Readme.md#are-there-more-policies-available-for-use)
    
- ### Secure Development   
  - #### Security Verification Tests (SVT)
    - [What Azure resource types that can be checked?](../02-Secure-Development/Readme.md#what-azure-resource-types-that-can-be-checked)
    - [What do the different columns in the status report mean?](../02-Secure-Development/Readme.md#what-do-the-different-columns-in-the-status-report-mean)
    - [How can I find out what to do for controls that are marked as 'manual'?](../02-Secure-Development/Readme.md#how-can-i-find-out-what-to-do-for-controls-that-are-marked-as-manual)
    - [How can I implement fixes for the failed ones which have no auto-fix available?](../02-Secure-Development/Readme.md#how-can-i-implement-fixes-for-the-failed-ones-which-have-no-auto-fix-available)
    - [What are Owner access controls? Why can't those be run via CA and need to be run manually? <br><br> (Or) <br><br> I have setup AzSK Continuous Assurance on my subscription. Do I still need to run the scans locally? <br> <br> Description: <br> Running the scan locally for all the resources in the subscription is time consuming. Do I still need to run that even though I have already setup Continuous Assurance on my subscription?](../02-Secure-Development/Readme.md#what-are-owner-access-controls-why-cant-those-be-run-via-ca-and-need-to-be-run-manually---or--i-have-setup-azsk-continuous-assurance-on-my-subscription-do-i-still-need-to-run-the-scans-locally---description--running-the-scan-locally-for-all-the-resources-in-the-subscription-is-time-consuming-do-i-still-need-to-run-that-even-though-i-have-already-setup-continuous-assurance-on-my-subscription)

- ### Security-In-CICD  
  - #### Security Verification Tests (SVTs) in VSTS pipeline
    - [I have enabled AzSK_SVTs task in my release pipeline. I am getting an error ‘The specified module 'AzSK' was not loaded because no valid module file was found in any module directory’. How do I resolve this issue?](../03-Security-In-CICD/Readme.md#i-have-enabled-AzSK_svts-task-in-my-release-pipeline-i-am-getting-an-error-the-specified-module-AzSK-was-not-loaded-because-no-valid-module-file-was-found-in-any-module-directory-how-do-i-resolve-this-issue)
    - [I have enabled AzSK_SVTs task in my release pipeline. It is taking too much time every time I queue a release, how can I reduce that time?](../03-Security-In-CICD/Readme.md#i-have-enabled-AzSK_svts-task-in-my-release-pipeline-it-is-taking-too-much-time-every-time-i-queue-a-release-how-can-i-reduce-that-time)
    - [Why AzSK_SVTs task in my release pipeline has suddenly started failing 'Verify'/'Manual'/'Remediate'/'Exception' controls?](../03-Security-In-CICD/Readme.md#why-azsk_svts-task-in-my-release-pipeline-has-suddenly-started-failing-verifymanualremediateexception-controls)
    - [I want to run AzSK_SVT on non-hosted agent. What are the pre-requisites for running AzSK_SVTs task on non-hosted agent?](../03-Security-In-CICD/Readme.md#i-want-to-run-azsk_svt-on-non-hosted-agent-what-are-the-pre-requisites-for-running-azsk_svts-task-on-non-hosted-agent)
    - [Why attestation is not getting respected in AzSK_SVT task in CICD pipeline?](../03-Security-In-CICD/Readme.md#why-attestation-is-not-getting-respected-in-azsk_svt-task-in-cicd-pipeline)

- ### Continuous Assurance (CA)  
  - #### Baseline Continuous Assurance
    - [What permission do I need to setup CA?](../04-Continous-Assurance/Readme.md#what-permission-do-i-need-to-setup-ca)
    - [Is it possible to setup CA if there is no Log Analytics workspace?](../04-Continous-Assurance/Readme.md#is-it-possible-to-setup-ca-if-there-is-no-log-analytics-workspace)
    - [Which Log Analytics workspace should I use for my team when setting up CA?](../04-Continous-Assurance/Readme.md#which-log-analytics-workspace-should-i-use-for-my-team-when-setting-up-ca)
    - [Why does CA setup ask for resource groups?](../04-Continous-Assurance/Readme.md#why-does-ca-setup-ask-for-resource-groups)
    - [How can I find out if CA was previously setup in my subscription?](../04-Continous-Assurance/Readme.md#how-can-i-find-out-if-ca-was-previously-setup-in-my-subscription)
    - [How can I tell that my CA setup has worked correctly?](../04-Continous-Assurance/Readme.md#how-can-i-tell-that-my-ca-setup-has-worked-correctly)
    - [Is providing resource groups mandatory?](../04-Continous-Assurance/Readme.md#is-providing-resource-groups-mandatory)
    - [What if I need to change the resource groups after a few weeks?](../04-Continous-Assurance/Readme.md#what-if-i-need-to-change-the-resource-groups-after-a-few-weeks)
    - [Do I need to also setup AzSK Monitoring solution?](../04-Continous-Assurance/Readme.md#do-i-need-to-also-setup-azsk-monitoring-solution)
    - [How much does it cost to setup Continuous Assurance along with the monitoring solution?](../04-Continous-Assurance/Readme.md#how-much-does-it-cost-to-setup-continuous-assurance-along-with-the-monitoring-solution)
    - [What are AzSKRG and AzSK_CA_SPN used for?](../04-Continous-Assurance/Readme.md#what-are-azskrg-and-azsk_ca_spn-used-for)
    - [How to fix SPN permissions for my AzSK Continuous Assurance setup?](../04-Continous-Assurance/Readme.md#how-to-fix-spn-permissions-for-my-azsk-continuous-assurance-setup)
    - [How to renew the certificate used for Continuous Assurance?](../04-Continous-Assurance/Readme.md#how-to-renew-the-certificate-used-for-continuous-assurance)
    - [What are some example controls that are not scanned by CA?](../04-Continous-Assurance/Readme.md#what-are-some-example-controls-that-are-not-scanned-by-ca)
    - [Should I manually update modules in the AzSK CA automation account?](../04-Continous-Assurance/Readme.md#should-i-manually-update-modules-in-the-azsk-ca-automation-account)
    - [Difference between scanned controls from CA v. ad hoc scans](../04-Continous-Assurance/Readme.md#difference-between-scanned-controls-from-ca-v-ad-hoc-scans)

- ### Addressing Control Failures
    - [Can fixing an AzSK control impact my application?](../00c-Addressing-Control-Failures/Readme.md#can-fixing-an-azsk-control-impact-my-application)
    - [What permission should I have to perform attestation in AzSK?](../00c-Addressing-Control-Failures/Readme.md#what-permission-should-i-have-to-perform-attestation-in-azsk)
    - [Attestation fails with permission error even though I am Owner.](../00c-Addressing-Control-Failures/Readme.md#attestation-fails-with-permission-error-even-though-i-am-owner)
    - [Why do I have new control failures from AzSK?](../00c-Addressing-Control-Failures/Readme.md#why-do-i-have-new-control-failures-from-azsk)
    - [I am trying to enable diagnostic logs using the recommendation command 'Set-AzDiagnosticSetting' given in the AzSK control. But the command fails with error 'The diagnostic setting 'service' doesn't exist'. How do I resolve this error?](../00c-Addressing-Control-Failures/Readme.md#i-am-trying-to-enable-diagnostic-logs-using-the-recommendation-command-set-azurermdiagnosticsetting-given-in-the-azsk-control-but-the-command-fails-with-error-the-diagnostic-setting-service-doesnt-exist-how-do-i-resolve-this-error)
    - [I wish to deploy virtual networking in a hub and spoke architecture, where ExpressRoute is connected to a Core network, which is then connected via VNET Peering, or VPN to other VNET’s, or other Azure datacentres. But some of the controls regarding ExpressRoute-connected Virtual Networks contradict my requirement. How does AzSK justify the controls like "There should not be another virtual network gateway (GatewayType = Vpn) in an ER-vNet" and "There should not be any virtual network peerings on an ER-vNet"? How should I satisfy them without changing my implementation plans?](../00c-Addressing-Control-Failures#i-wish-to-deploy-virtual-networking-in-a-hub-and-spoke-architecture-where-expressroute-is-connected-to-a-core-network-which-is-then-connected-via-vnet-peering-or-vpn-to-other-vnets-or-other-azure-datacentres-but-some-of-the-controls-regarding-expressroute-connected-virtual-networks-contradict-my-requirement-how-does-azsk-justify-the-controls-like-there-should-not-be-another-virtual-network-gateway-gatewaytype--vpn-in-an-er-vnet-and-there-should-not-be-any-virtual-network-peerings-on-an-er-vnet-how-should-i-satisfy-them-without-changing-my-implementation-plans)
    - [I am unable to scan/attest API connection controls independently. I am getting the error: Could not find any resources to scan under Resource Group. InvalidOperation: Could not find any resources that match the specified criteria. How should I scan and bulk attest API connection controls?](../00c-Addressing-Control-Failures/Readme.md#i-am-unable-to-scanattest-api-connection-controls-independently-i-am-getting-the-error-could-not-find-any-resources-to-scan-under-resource-group-invalidoperation-could-not-find-any-resources-that-match-the-specified-criteria-how-should-i-scan-and-bulk-attest-api-connection-controls)
    - [I cannot find the API connection on portal that is listed in the AzSK CSV scan result. Where can I find these resource on portal?](../00c-Addressing-Control-Failures/Readme.md#i-cannot-find-the-api-connection-on-portal-that-is-listed-in-the-azsk-csv-scan-result-where-can-i-find-these-resource-on-portal)


- ### Org Policy
    - [I am getting exception "DevOps Kit was configured to run with '***' policy for this subscription. However, the current command is using 'org-neutral' (generic) policy....."?](../07-Customizing-AzSK-for-your-Org/Readme.md#i-am-getting-exception-devops-kit-was-configured-to-run-with--policy-for-this-subscription-however-the-current-command-is-using-org-neutral-generic-policy-please-contact-your-organization-policy-owner-microsoftcom-for-correcting-the-policy-setup)
    - [Latest AzSK is available but our Org CA are running with older version?](../07-Customizing-AzSK-for-your-Org/Readme.md#latest-azsk-is-available-but-our-org-ca-are-running-with-older-version)
    - [We have configured baseline controls using ControlSettings.json on Policy Store, But Continuous Assurance (CA) is scanning all SVT controls on subscription?](../07-Customizing-AzSK-for-your-Org/Readme.md#we-have-configured-baseline-controls-using-controlsettingsjson-on-policy-store-but-continuous-assurance-ca-is-scanning-all-svt-controls-on-subscription)
    - [Continuous Assurance (CA) is scanning less number of controls as compared with manual scan?](../07-Customizing-AzSK-for-your-Org/Readme.md#continuous-assurance-ca-is-scanning-less-number-of-controls-as-compared-with-manual-scan)
      
