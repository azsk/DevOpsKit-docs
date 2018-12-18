## 181217 (AzSK v.3.9.0)

### Feature updates

Security controls for Azure DevOps (VSTS)

* New capability (available as a separate module [AzSK.AzureDevOps]) to perform security control scanning in Azure DevOps (VSTS). This leverages the core DevOps Kit framework to seamlessly extend security scanning to VSTS and covers the following areas/scopes: Organization, Projects, Users, Connections, Pipelines (Build & Release). The overall experience is very similar to other DevOps Kit cmdlets. 
Follow [page](../09-AzureDevOps(VSTS)-Security) for module installation and command execution guide. 

Security Verification Tests (SVTs):
* Completed security controls for the following:
	* Azure Kubernetes Service (AKS)
	* API Management (APIM)
* Ability to scan Databricks using an 'in-cluster' scan agent (Python notebook). Please see below for the steps on how to set this up. We are exploring this as a general approach to expand AzSK scans into the 'data' plane for various cluster technologies.
* Ability to customize naming of severity levels of controls (e.g., instead of High/Medium, etc. one can now have Important/Moderate, etc.) with the changes reflecting in all avenues (manual scan results/CSV, OMS, compliance summaries, dashboards, etc.)
* Org-policy feature updates (non-CSE):
	* The ARM Checker task in AzSK CICD Extension now respects org policy ' this will let org policy owners customize behavior of the task. (Note that this was possible for the SVT task earlier'only the ARM Checker task was missing the capability.)
	* Ability to run CA in sovereign clouds + ability to apply custom org policy for SDL, CICD and CA for such subscriptions. (Please review [GitHub docs](https://github.com/azsk/DevOpsKit-docs/blob/master/01-Subscription-Security/Readme.md#azsk-support-for-azure-government-and-azure-china-1) for the steps needed.)

### Other improvements/bug fixes

Controls: 
* Fixed a bug in the PIM-related ('Azure_Subscription_AuthZ_Dont_Grant_Persistent_Access') control to check for (null) condition where there are no members in permanent role. 
* The DevOps Kit config health control ('Azure_AzSKCfg_Check_Health_of_CA') was unnecessarily enforcing Security Reader permission. It should now work just with 'Reader' permission. 
* Updated recommendations, rationale, etc. for multiple controls in preparation for the CSE compliance drive.

CICD Extension:
* Fixed an issue in ARM Template Checker where exclude files parameter was not honored recursively in a folder hierarchy.
