# FAQs

- ### Setup
  - [Should I run PowerShell ISE as administrator or regular user?](../00a-Setup/Readme.md#should-i-run-powershell-ise-as-administrator-or-regular-user)
  - [Error message: "Running scripts is disabled on this system..."](../00a-Setup/Readme.md#error-message-running-scripts-is-disabled-on-this-system)
  - [Error message: "PackageManagement\Install-Package: cannot process argument transformation on parameter 'InstalledModuleInfo'..."](../00a-Setup/Readme.md#error-message-packagemanagementinstall-package-cannot-process-argument-transformation-on-parameter-installedmoduleinfo)
  - [Error message: "WARNING: The version '3.x.y' of module 'AzureRM.Profile' is currently in use. Retry the operation after closing..."](../00a-Setup/Readme.md#error-message-warning-the-version-3xy-of-module-azurermprofile-is-currently-in-use-retry-the-operation-after-closing)
  - [Error message: "The property 'Id' cannot be found on this object. Verify that the property exists..."](../00a-Setup/Readme.md#error-message-the-property-id-cannot-be-found-on-this-object-verify-that-the-property-exists)
  - [Message: "Warning : Microsoft Azure PowerShell collects data about how users use PowerShell cmdlets..."](../00a-Setup/Readme.md#message-warning--microsoft-azure-powershell-collects-data-about-how-users-use-powershell-cmdlets)
  
- ### Subscription-Security
  - #### AzSK: Subscription Security Provisioning
    - [Is it possible to setup an individual feature (e.g., just alerts or just ARM Policy)?](../01-Subscription-Security/Readme.md#is-it-possible-to-setup-an-individual-feature-eg-just-alerts-or-just-arm-policy)
  - #### AzSK: Subscription Activity Alerts  
    - [Can I get the alert emails to go to a distribution group instead of an individual email id?](../01-Subscription-Security/Readme.md#can-i-get-the-alert-emails-to-go-to-a-distribution-group-instead-of-an-individual-email-id)
    - [How can I find out more once I receive an alert email?](../01-Subscription-Security/Readme.md#how-can-i-find-out-more-once-i-receive-an-alert-email)
    - [Is there a record maintained of the alerts that have fired?](../01-Subscription-Security/Readme.md#is-there-a-record-maintained-of-the-alerts-that-have-fired)
  - #### AzSK: Subscription Security - ARM Policy
    - [What happens if an action in the subscription violates the policy?](../01-Subscription-Security/Readme.md#what-happens-if-an-action-in-the-subscription-violates-the-policy)
    - [Which ARM policies are installed by the setup script?](../01-Subscription-Security/Readme.md#which-arm-policies-are-installed-by-the-setup-script)
    - [How can I check for policy violations?](../01-Subscription-Security/Readme.md#how-can-i-check-for-policy-violations)
    
- ### Secure Development   
  - #### Security Verification Tests (SVT)
    - [What Azure resource types that can be checked?](../02-Secure-Development/Readme.md#what-azure-resource-types-that-can-be-checked)
    - [What do the different columns in the status report mean?](../02-Secure-Development/Readme.md#what-do-the-different-columns-in-the-status-report-mean)
    - [How can I find out what to do for controls that are marked as 'manual'?](../02-Secure-Development/Readme.md#how-can-i-find-out-what-to-do-for-controls-that-are-marked-as-manual)
    - [How can I implement fixes for the failed ones which have no auto-fix available?](../02-Secure-Development/Readme.md#how-can-i-implement-fixes-for-the-failed-ones-which-have-no-auto-fix-available)

- ### Security-In-CICD  
  - #### Security Verification Tests (SVTs) in VSTS pipeline
    - [I have enabled AzSK_SVTs task in my release pipeline. I am getting an error ‘The specified module 'AzSK' was not loaded because no valid module file was found in any module directory’. How do I resolve this issue?](../03-Security-In-CICD/Readme.md#i-have-enabled-AzSK_svts-task-in-my-release-pipeline-i-am-getting-an-error-the-specified-module-AzSK-was-not-loaded-because-no-valid-module-file-was-found-in-any-module-directory-how-do-i-resolve-this-issue)
    - [I have enabled AzSK_SVTs task in my release pipeline. It is taking too much time every time I queue a release, how can I reduce that time?](../03-Security-In-CICD/Readme.md#i-have-enabled-AzSK_svts-task-in-my-release-pipeline-it-is-taking-too-much-time-every-time-i-queue-a-release-how-can-i-reduce-that-time)

- ### Continuous Assurance (CA)  
  - #### Baseline Continuous Assurance
    - [What permission do I need to setup CA?](../04-Continous-Assurance/Readme.md#what-permission-do-i-need-to-setup-ca)
    - [Is it possible to setup CA if there is no OMS workspace?](../04-Continous-Assurance/Readme.md#is-it-possible-to-setup-ca-if-there-is-no-oms-workspace)
    - [Which OMS workspace should I use for my team when setting up CA?](../04-Continous-Assurance/Readme.md#which-oms-workspace-should-i-use-for-my-team-when-setting-up-ca)
    - [Why does CA setup ask for resource groups?](../04-Continous-Assurance/Readme.md#why-does-ca-setup-ask-for-resource-groups)
    - [How can I find out if CA was previously setup in my subscription?](../04-Continous-Assurance/Readme.md#how-can-i-find-out-if-ca-was-previously-setup-in-my-subscription)
    - [How can I tell that my CA setup has worked correctly?](../04-Continous-Assurance/Readme.md#how-can-i-tell-that-my-ca-setup-has-worked-correctly)
    - [Is providing resource groups mandatory?](../04-Continous-Assurance/Readme.md#is-providing-resource-groups-mandatory)
    - [What if I need to change the resource groups after a few weeks?](../04-Continous-Assurance/Readme.md#what-if-i-need-to-change-the-resource-groups-after-a-few-weeks)
    - [Do I need to also setup AzSK OMS solution?](../04-Continous-Assurance/Readme.md#do-i-need-to-also-setup-AzSK-oms-solution)
    - [How much does it cost to setup Continuous Assurance alongwith OMS monitoring solution?](../04-Continous-Assurance/Readme.md#how-much-does-it-cost-to-setup-continuous-assurance-alongwith-oms-monitoring-solution)

    
