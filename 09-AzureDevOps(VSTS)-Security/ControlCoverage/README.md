## Security controls covered by the Security Scanner for Azure DevOps (ADO)

This page displays security controls that are automated via ADO security scanner and also controls that have to manually verified. Controls have a 'Severity' field to help distinguish issues by degree of risk. Apart from that the automated flag indicates whether a particular control is automated and 'Fix Script' provides the availability of  a 'control fix' script that the user can review and run to apply the fixes. 

### Azure DevOps Services supported by AzSK

Below resource types can be checked for validating the security controls. 

|FeatureName|
|---|
|[Organization](#Organization)|
|[Project](#Project)|
|[Build](#Build)|
|[Release](#Release)|
|[ServiceConnection](#Service-Connection)|
|[Agent Pool](#Agent-Pool)|
|[User](#User)|


### Organization

<html>
<head>

</head><body>
<table><tr><th>Description & Rationale</th><th>ControlSeverity</th><th>Automated</th><th>Fix Script</th></tr>
<tr><td><b>Organization must be configured to authenticate users using Azure Active Directory backed credentials.</b><br/>Using the native enterprise directory for authentication ensures that there is a built-in high level of assurance in the user identity established for subsequent access control.All Enterprise subscriptions are automatically associated with their enterprise directory (xxx.onmicrosoft.com) and users in the native directory are trusted for authentication to enterprise subscriptions.</td><td>High</td><td>Yes</td><td>No</td></tr>

<tr><td><b>Do not grant access to external users (users with accounts outside your native directory) to your organization.</b>
<br/>
Non-AD accounts (such as xyz@hotmail.com, pqr@outlook.com, etc.) present at any scope within a organization subject your assets to undue risk. These accounts are not managed to the same standards as enterprise tenant identities. They don't have multi-factor authentication enabled.
</td><td>High</td><td>Yes</td><td>No</td></tr>

<tr><td><b>Public projects must be turned off for Organization</b>
<br/>
Data/content in projects that have anonymous access can be downloaded by anyone on the internet without authentication. This can lead to a compromise of corporate data.
</td><td>High</td><td>Yes</td><td>No</td></tr>

<tr><td><b>Justify all guest identities that have been granted access to your organization </b>
<br/>
Non-AD accounts (such as xyz@hotmail.com, pqr@outlook.com, etc.) present at any scope within an Organization subject your cloud assets to undue risk. These accounts are not managed to the same standards as enterprise tenant identities. They don't have multi-factor authentication enabled. Etc.
</td><td>High</td><td>Yes</td><td>No</td></tr>

<tr><td><b>Ensure that extensions enabled for your organization are trustworthy.</b>
<br/>
Running extensions from untrusted source can lead to all type of attacks and loss of sensitive enterprise data.
</td><td>High</td><td>Yes</td><td>No</td></tr>

<tr><td><b>Exercise due care when installing (private) shared extensions for your organization.</b>
<br/>
Running extensions from untrusted source can lead to all type of attacks and loss of sensitive enterprise data.
</td><td>High</td><td>Yes</td><td>No</td></tr>

<tr><td><b>Review the list of users who have permission to manage extensions</b>
<br/>
Accounts with extension manager access can install/manage extensions for Organization. Members with this access without a legitimate business reason increase the risk for Organization. By carefully reviewing and removing accounts that shouldn't be there in the first place, you can avoid attacks if those accounts are compromised.
</td><td>High</td><td>Yes</td><td>No</td></tr>

<tr><td><b>Consider revoking access for inactive users</b>
<br/>
Each additional person having access at Organization level increases the attack surface for the entire resources. To minimize this risk ensure that critical resources present in Organization are accessed only by the legitimate users when required.
</td><td>Medium</td><td>Yes</td><td>No</td></tr>

<tr><td><b>Remove access entries for users whose accounts have been deleted/disconnecte from Azure Active Directory.</b>
<br/>
AD disconnected accounts present at any scope within a Organization are unknown guid access.
</td><td>Medium</td><td>Yes</td><td>No</td></tr>

<tr><td><b>All teams/groups must be granted minimum required permissions on Organization</b>
<br/>
Granting minimum access by leveraging RBAC feature ensures that users are granted just enough permissions to perform their tasks. This minimizes exposure of the resources in case of user/service account compromise.
</td><td>High</td><td>No</td><td>No</td></tr>


<tr><td><b> Justify all identities that are granted with member access on groups and teams.</b>
<br/>
Accounts that are a member of these groups without a legitimate business reason increase the risk for your Organization. By carefully reviewing and removing accounts that shouldn't be there in the first place, you can avoid attacks if those accounts are compromised.
</td><td>High</td><td>No</td><td>No</td></tr>

<tr><td><b>Alerts must be configured for critical actions on Organization</b>
<br/>
Alerts notify the configured security point of contact about various sensitive activities on the Organization and its resources (for instance, external Extensions have been installed/modified etc.)
</td><td>Medium</td><td>No</td><td>No</td></tr>

<tr><td><b>Service accounts cannot support MFA and should not be used for Org activity</b>
<br/>
Service accounts are typically not multi-factor authentication capable. Quite often, teams who own these accounts don't exercise due care (e.g., someone may login interactively on servers using a service account exposing their credentials to attacks such as pass-the-hash, phishing, etc.) As a result, using service accounts in any privileged role in a AzureDevOps exposes the Organization data to 'credential theft'-related attack vectors. (In effect, the Organization data becomes accessible after just one factor (password) is compromised...this defeats the whole purpose of imposing the MFA requirement for Organizations.)
</td><td>High</td><td>No</td><td>No</td></tr>

<tr><td><b>Smart Card Alt(SC-ALT) accounts must be used on Secure Admin Workstation(SAW) for privileged roles used for Org activity</b>
<br/>
</td><td>High</td><td>No</td><td>No</td></tr>

<tr><td><b>Minimize and reviews service accounts that are members of the Project Collection Service Accounts group.</b>
<br/>
ADO has a misleading group called Project Collection Service Accounts. By inheritance, Project Collection Service Accounts are also Project Collection Administrators. It is found that multiple build agent user accounts across Microsoft were members of Project Collection Service Accounts. An adversary that executes code in a pipeline assigned to one of these build agents can take over the entire ADO organization
</td><td>High</td><td>Yes</td><td>No</td></tr>

<tr><td><b>Set of auto-injected pipeline tasks should be carefully scrutinized.</b>
<br/>
Auto-injected pipeline tasks will run in every pipeline. If an attacker can change/influence the task logic/code, it can have catastrophic consequences for the entire organization.
</td><td>Medium</td><td>Yes</td><td>No</td></tr>

<tr><td><b>Enterprise access to projects should be verified.</b>
<br/>
</td><td>Medium</td><td>Yes</td><td>No</td></tr>

<tr><td><b>AAD Conditional Access Policy should be enabled.</b>
<br/>
</td><td>Medium</td><td>Yes</td><td>No</td></tr>

<tr><td><b>Anonymous access to status badge API for parallel pipelines should be disabled.</b>
<br/>
</td><td>Medium</td><td>Yes</td><td>No</td></tr>

<tr><td><b>Do not permit all pipeline variables to be settable by default.</b>
<br/>
</td><td>Medium</td><td>Yes</td><td>No</td></tr>

<tr><td><b>Scope of access of all pipelines should be restricted to current project.</b>
<br/>
This ensures pipeline execution happens using a token scoped to the current project abiding with principle of least privilege.
</td><td>Medium</td><td>Yes</td><td>No</td></tr>

<tr><td><b>Audit logs are stored for 90 days and then they’re deleted. Back up audit logs to an external location to keep the data for longer than the 90-day period.</b>
<br/>
Auditing contains many changes that occur throughout an Azure DevOps organization. Changes occur when a user or service identity within the organization edits the state of an artifact. In some limited cases, it can also include accessing an artifact. Think permissions changes, resource deletion, branch policy changes, accessing the auditing feature, and much more.
</td><td>Medium</td><td>No</td><td>No</td></tr>

</table>
<table>
</table>
</body></html>

### Project

<html>
<head>

</head><body>
<table><tr><th>Description & Rationale</th><th>ControlSeverity</th><th>Automated</th><th>Fix Script</th></tr>

<tr><td><b>Ensure that project visibility is set to private/enterprise. </b>
<br/>
Data/content in projects that have public visibility can be downloaded by anyone on the internet without authentication. This can lead to a compromise of corporate data.
</td><td>High</td><td>Yes</td><td>No</td></tr>


<tr><td><b>All teams/groups must be granted minimum required permissions on project</b>
<br/>
Granting minimum access by leveraging RBAC feature ensures that users are granted just enough permissions to perform their tasks. This minimizes exposure of the resources in case of user/service account compromise.
</td><td>High</td><td>No</td><td>No</td></tr>


<tr><td><b>Justify all identities that are granted with member access on group and teams.</b>
<br/>
Accounts that are a member of these groups without a legitimate business reason increase the risk for your Organization. By carefully reviewing and removing accounts that shouldn't be there in the first place, you can avoid attacks if those accounts are compromised.
</td><td>High</td><td>No</td><td>No</td></tr>

<tr><td><b>Anonymous access to status badge API for parallel pipelines should be disabled.</b>
<br/>
</td><td>Low</td><td>Yes</td><td>No</td></tr>

<tr><td><b>Do not permit all pipeline variables to be settable by default.</b>
<br/>
</td><td>Medium</td><td>Yes</td><td>No</td></tr>

<tr><td><b>Scope of access of all pipelines should be restricted to current project.</b>
<br/>
This ensures pipeline execution happens using a token scoped to the current project abiding with principle of least privilege.
</td><td>Medium</td><td>Yes</td><td>No</td></tr>

<tr><td><b>Consider using artifact evaluation for fine-grained control over pipeline stages.</b>
<br/>
Allows pipelines to record metadata. Evaluate artifact check can be configured to define policies using the metadata recorded.
</td><td>Medium</td><td>Yes</td><td>No</td></tr>

</table>
<table>
</table>
</body></html>


### Build

<html> 
<head>

</head><body>
<table><tr><th>Description & Rationale</th><th>ControlSeverity</th><th>Automated</th><th>Fix Script</th></tr>

<tr><td><b>All teams/groups must be granted minimum required permissions on build definition</b>
<br/>
Granting minimum access by leveraging RBAC feature ensures that users are granted just enough permissions to perform their tasks. This minimizes exposure of the resources in case of user/service account compromise.
</td><td>High</td><td>Yes</td><td>No</td></tr>

<tr><td><b>Secrets and keys must not be stored as plain text in build variables/task parameters </b>
<br/>
Keeping secrets such as connection strings, passwords, keys, etc. in clear text can lead to easy compromise. Making them secret type variables ensures that they are protected at rest.
</td><td>High</td><td>Yes</td><td>No</td></tr>


<tr><td><b>Consider adding static code analysis step in your pipelines.</b>
<br/>
Static code analyzer ensure that the code is following all rules for security
</td><td>High</td><td>No</td><td>No</td></tr>


<tr><td><b>Secure Files library must be used to store secret files such as signing certificates, Apple Provisioning Profiles, Android KeyStore files, and SSH keys </b>
<br/>
Keeping secret files such as signing certificates, Apple Provisioning Profiles, Android KeyStore files, SSH keys etc. in repository can lead to easy compromise at various avenues during an application's lifecycle. Storing them in a secure library ensures that they are protected at rest.
</td><td>Medium</td><td>No</td><td>No</td></tr>


<tr><td><b>Inactive build pipelines must be removed if no more required.</b>
<br/>
Each additional build having access at repositories increases the attack surface. To minimize this risk ensure that only activite and legitimate build resources present in Organization
</td><td>Low</td><td>Yes</td><td>No</td></tr>

<tr><td><b>Do not allow inherited permission on build definitions.</b>
<br/>
Disabling inherit permissions lets you finely control access to various operations at the build level for different stakeholders. This ensures that you follow the principle of least privilege and provide access only to the persons that require it.
</td><td>High</td><td>Yes</td><td>No</td></tr>

<tr><td><b>Pipeline variables marked settable at queue time should be carefully reviewed.</b>
<br/>
Pipeline variables not marked settable at queue time can only be changed by someone with elevated permissions. These variables (reasonably) used in ways that make code injection possible.
</td><td>High</td><td>Yes</td><td>No</td></tr>

<tr><td><b>Building code from untrusted external sources is effectively allowing external parties to execute arbitrary code on your computer.</b>
<br/>
Builds execute attacker-controlled code by-design (e.g. solution files contain build command lines to invoke, unit tests compile into DLLs that are loaded and executed by a harness, etc). Building code from untrusted external sources is effectively allowing external parties to execute arbitrary code on your computer.
</td><td>High</td><td>Yes</td><td>No</td></tr>

</table>
<table>
</table>
</body></html>

### Release

<html>
 
<head>

</head><body>
<table><tr><th>Description & Rationale</th><th>ControlSeverity</th><th>Automated</th><th>Fix Script</th></tr>

<tr><td><b>All teams/groups must be granted minimum required permissions on release definition</b>
<br/>
Granting minimum access by leveraging RBAC feature ensures that users are granted just enough permissions to perform their tasks. This minimizes exposure of the resources in case of user/service account compromise.
</td><td>High</td><td>Yes</td><td>No</td></tr>

<tr><td><b>Secrets and keys must not be stored as plain text in release variables/task parameters</b>
<br/>
Keeping secrets such as connection strings, passwords, keys, etc. in clear text can lead to easy compromise. Making them secret type variables ensures that they are protected at rest.
</td><td>High</td><td>Yes</td><td>No</td></tr>

<tr><td><b>Inactive release pipelines must be removed if no more required.</b>
<br/>
Each additional release having access at repositories increases the attack surface. To minimize this risk ensure that only activite and legitimate release resources present in Organization
</td><td>Low</td><td>Yes</td><td>No</td></tr>

<tr><td><b>Do not allow inherited permission on release definitions</b>
<br/>
Disabling inherit permissions lets you finely control access to various operations at the release level for different stakeholders. This ensures that you follow the principle of least privilege and provide access only to the persons that require it.
</td><td>High</td><td>Yes</td><td>No</td></tr>

<tr><td><b>Releases pipeline for production deployments must have pre-deployment approval enabled.</b>
<br/>
Pre-deployment approvals give you an additional layer of defense against inadvertent (or possibly malicious) changes to your production environment.
</td><td>High</td><td>Yes</td><td>No</td></tr>

<tr><td><b>Only legitimate users should be added as approvers for a release pipeline</b>
<br/>
Periodic review of approvers list for production releases ensures that only appropriate people are members of such a critical role. As team composition/membership changes, this privilege may need to be revoked from members who have moved on.
</td><td>Medium</td><td>Yes</td><td>No</td></tr>

<tr><td><b>All releases to Production or pre-Production stages must be done from one and only one (main) branch.</b>
<br/>
You should ensure that production releases are always done from one and only one (main) branch. The main branch should have the tightest access controls and approval standards.`n Any changes in the source code should be tested first on a development branch before merging in the main branch. The source code in the main branch should correspond to production bits at all times. This helps in maintaining stable source code and helps prevent deployment of breaking changes (and potential security bugs) into the production environment.
</td><td>Medium</td><td>No</td><td>No</td></tr>

<tr><td><b>Ensure that release pipelines consume artifacts from trustworthy repos.</b>
<br/>
Pipelines build code from untrusted external sources (e.g. GitHub) via Continuous Integration or Scheduled Builds, giving the public internet access to a Project/Project Collection Build Service token.
</td><td>Medium</td><td>Yes</td><td>No</td></tr>

</table>
<table>
</table>
</body></html>


### Service Connection

<html>
<head>

</head><body>
<table><tr><th>Description & Rationale</th><th>ControlSeverity</th><th>Automated</th><th>Fix Script</th></tr>

<tr><td><b>Azure Active Directory applications, which used in pipeline, must use certificate based authentication</b>
<br/>
Password/shared secret credentials can be easily shared and hence can be easily compromised. Certificate credentials offer better security.
</td><td>High</td><td>Yes</td><td>No</td></tr>

<tr><td><b>Service Connection should not be provided access at subscription level</b>
<br/>
Just like AD-based service accounts, SPNs have a single credential and most scenarios that use them cannot support multi-factor authentication. As a result, adding SPNs to a subscription in 'Owners' or 'Contributors' roles is risky.
</td><td>High</td><td>Yes</td><td>No</td></tr>

<tr><td><b>JJustify all users/groups that have access to the service connection.</b>
<br/>
Accounts with admin access can install/manage extensions for Organization. Members with this access without a legitimate business reason increase the risk for Organization. By carefully reviewing and removing accounts that shouldn't be there in the first place, you can avoid attacks if those accounts are compromised.
</td><td>High</td><td>No</td><td>No</td></tr>

<tr><td><b>Periodically review usage history of service connection to validate use from legitimate pipelines.</b>
<br/>
Periodic reviews of request history logs ensures that sevice connection been used from legitimate build definations and avoid major compromise.
</td><td>High</td><td>No</td><td>No</td></tr>

<tr><td><b>Do not use any classic resources on a subscription</b>
<br/>
You should use new ARM/v2 resources as the ARM model provides several security enhancements such as: stronger access control (RBAC), better auditing, ARM-based deployment/governance, access to managed identities, access to key vault for secrets, AAD-based authentication, support for tags and resource groups for easier security management, etc.
</td><td>High</td><td>Yes</td><td>No</td></tr>

<tr><td><b>Do not allow inherited permissions on service connections</b>
<br/>
Service connections represent credentials of various services/repositories accessed by your project's build/release process. You should exercise fine-grained control over who can access them. Removing inherited access ensures that individuals beyond your control do not get access.
</td><td>High</td><td>Yes</td><td>No</td></tr>

<tr><td><b>Do not grant global security groups access to service connections</b>
<br/>
Global security groups are maintained at organization and project level and may contain users at a very broad scope (e.g., all users in the organization). Granting elevated permissions to these groups can risk exposure of service connections to unwarranted individuals.
</td><td>High</td><td>Yes</td><td>No</td></tr>

<tr><td><b>Do not grant Build Service Account access for connections</b>
<br/>
Build service account is default identity used as part every build in project. Providing access to this common service account will expose connection details to all build definition under project.
</td><td>High</td><td>Yes</td><td>No</td></tr>

<tr><td><b>Do not make service connections accessible to all pipelines</b>
<br/>
To support security of the pipeline operations, Connections must not be granted to access for all pipeline
</td><td>High</td><td>Yes</td><td>No</td></tr>

<tr><td><b>Justify GitHub service connections are authenticated with full scope GitHub PATs instead of the OAuth flow.</b>
<br/>
Full scope PAT is equivalent to full account compromise. The OAuth flow creates a token that only allows source code and webhook read/write access on GitHub. The impact of losing control of a scoped OAuth token is far lower.
</td><td>High</td><td>Yes</td><td>No</td></tr>
</table>
<table>
</table>
</body></html>

### Agent Pool

<html>
<head>

</head><body>
<table><tr><th>Description & Rationale</th><th>ControlSeverity</th><th>Automated</th><th>Fix Script</th></tr>

<tr><td><b>All teams/groups must be granted minimum required permissions on agent pool.</b>
<br/>
Granting minimum access by leveraging RBAC feature ensures that users are granted just enough permissions to perform their tasks. This minimizes exposure of the resources in case of user/service account compromise.
</td><td>High</td><td>Yes</td><td>No</td></tr>

<tr><td><b>Non-hosted agent virtual machine must have all the required security patches installed.</b>
<br/>
Un-patched VMs are easy targets for compromise from various malware/trojan attacks that exploit known vulnerabilities in operating systems and related software.
</td><td>High</td><td>No</td><td>No</td></tr>

<tr><td><b>Use a security hardened, locked down OS image for self-hosted VMs in agent pool.</b>
<br/>
The connector machine is serving as a 'gateway' into the corporate environment allowing internet based client endpoints access to enterprise data. Using a locked-down, secure baseline configuration ensures that this machine does not get leveraged as an entry point to attack the applications/corporate network.
</td><td>Medium</td><td>No</td><td>No</td></tr>

<tr><td><b>Do not allow inherited permission on agent pool.</b>
<br/>
Disabling inherit permissions lets you finely control access to various operations at the agent level for different stakeholders. This ensures that you follow the principle of least privilege and provide access only to the persons that require it.
</td><td>Medium</td><td>Yes</td><td>No</td></tr>

<tr><td><b>Do not allow Auto-provision enables on agent pool.</b>
<br/>
By enabling the 'Auto-provision' The organization agent pool is imported in all your new team projects and is accessible there immediately.
</td><td>High</td><td>Yes</td><td>No</td></tr>

<tr><td><b>Do not make agent pool accesible to all pipelines in the project.</b>
<br/>
By enabling the 'Grant access permission to all pipelines' The agent pool is imported in all your pipeline in the current project and is accessible there immediately.
</td><td>High</td><td>Yes</td><td>No</td></tr>

</table>
<table>
</table>
</body></html>

### User

<html>
<head>

</head><body>
<table><tr><th>Description & Rationale</th><th>ControlSeverity</th><th>Automated</th><th>Fix Script</th></tr>

<tr><td><b>Personal access tokens (PAT) must be defined with minimum required permissions to resources</b>
<br/>
Granting minimum access ensures that PAT is granted with just enough permissions to perform required tasks. This minimizes exposure of the resources in case of PAT compromise.
</td><td>Medium</td><td>Yes</td><td>No</td></tr>

<tr><td><b>Personal access tokens (PAT) must have a shortest possible validity period</b>
<br/>
If a personal access token (PAT) gets compromised, the Azure DevOps assets accessible to the user can be accessed/manipulated by unauthorized users. Minimizing the validity period of the PAT ensures that the window of time available to an attacker in the event of compromise is small.
</td><td>Medium</td><td>Yes</td><td>No</td></tr>

<tr><td><b>Personal access tokens (PAT) near expiry should be renewed.</b>
<br/>
Personal access tokens (PAT) near expiry should be renewed.
</td><td>Medium</td><td>Yes</td><td>No</td></tr>

<tr><td><b>Alternate credential must be disabled.</b>
<br/>
Alternate credential allows user to create username and password to access your Git repository. Login with these credentials doesn't expire and can't be scoped to limit access to your Azure DevOps Services data.
</td><td>Medium</td><td>Yes</td><td>No</td></tr>

</table>
<table>
</table>
</body></html>
