
This page will notify updates for Org Policy with different AzSK versions


# AzSK v.3.5.0

**Note:** AzSK 3.5.0 has upgraded its dependancy on AzureRM and now requires AzureRM version 6.x. It has breaking changes for RunbookCoreSetup and RunbookScanAgent present on Custom Org Policy. If you are upgrading Org Policy with AzSK version 3.5.0 using configurations(AzSK.Pre.Json), you will need to take latest runbook files with update Org policy command (*Update-AzSKOrganizationPolicy -SubscriptionId -OrgName `<OrgName`> -DepartmentName `<DeptName`> -OverrideBaseConfig CARunbooks*). If you have customized these files for your Org(like adding -UseBaselineControls inside RunbookScanAgent etc.), You will need to re-do changes after running update command.

* Policy owner can now use a local folder to ‘deploy’ policy to significantly improve debugging/troubleshooting experience. (Policy changes can be pre-tested locally and there’s no need to maintain a separate dev-test policy server endpoint.)
* Support for handling expiry of SAS token in the policy URL in an automated manner in local setup and CA. (Only CICD extension scenarios will need explicit updates. We will display warnings when expiry is coming up in the next 30 days.) 
* Support for schema validation of org policy config JSON via the Get-AzSKOrganizationPolicyStatus command. This will reduce chances of errors due to oversight/copy-paste errors, etc.
* Teams that extend the AzSK module can now also add custom listeners to receive scan events.

# AzSK v.3.4.x

*	A new cmdlet (Get-AzSKOrganizationPolicyStatus) to check health/correctness of org policy configuration for a given setup and to also help remediate issues that were found.
* Provided option to download existing policies from the policy server.
*	If an org is using a version of AzSK that is more than 2 releases old (current-2), then we will show a ‘deprecated’ warning to ensure that customers using org policy are staying up to date with the latest security controls.
*	If a subscription is configured with a specific org policy then the scan commands run using some other (or OSS) policy will be disallowed with appropriate warnings.
*	Org policy customers can now generate compliance dashboard based on a Power BI content pack and a CSV mapping subscription to org details.

