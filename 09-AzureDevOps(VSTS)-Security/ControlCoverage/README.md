## Security controls covered by the Secure DevOps Kit for Azure DevOps(VSTS)

This page displays security controls that are automated via the devops kit and also controls that have to manually verified. Controls have a 'Severity' field to help distinguish issues by degree of risk. Apart from that the automated flag indicates whether a particular control is automated and 'Fix Script' provides the availability of  a 'control fix' script that the user can review and run to apply the fixes. 

### Azure DevOps Services supported by AzSK

Below resource types can be checked for validating the security controls. 

|FeatureName|
|---|
|[Organization](ControlCoverage#Organization.md)|
|[Project](ControlCoverage#Project.md)|
|[Build](ControlCoverage#Build.md)|
|[Release](ControlCoverage#Release.md)|
|[ServiceConnection](ControlCoverage#Service-Connection.md)|
|[Agent Pool](ControlCoverage#Agent-Pool.md)|
|[User](ControlCoverage#User.md)|


### Organization

<html>
<head>

</head><body>
<table><tr><th>Description & Rationale</th><th>ControlSeverity</th><th>Automated</th><th>Fix Script</th></tr>
<tr><td><b>Organization must be configured to authenticate users using Azure Active Directory backed credentials.</b><br/>Using the native enterprise directory for authentication ensures that there is a built-in high level of assurance in the user identity established for subsequent access control.All Enterprise subscriptions are automatically associated with their enterprise directory (xxx.onmicrosoft.com) and users in the native directory are trusted for authentication to enterprise subscriptions.</td><td>High</td><td>Yes</td><td>No</td></tr>

<tr><td><b>Permissions to external accounts (i.e., accounts outside the native directory for the Organization) must be disabled</b>
<br/>
Non-AD accounts (such as xyz@hotmail.com, pqr@outlook.com, etc.) present at any scope within a Organization subject your assets to undue risk. These accounts are not managed to the same standards as enterprise tenant identities. They don't have multi-factor authentication enabled. Etc.
</td><td>High</td><td>Yes</td><td>No</td></tr>

<tr><td><b>Alternate credential must be disabled for users</b>
<br/>
Alternate credential allows user to create username and password to access Git repositories.Login with these credentials doesn't expire and can't be scoped to limit access to your Azure DevOps Services data.
</td><td>High</td><td>Yes</td><td>No</td></tr>

<tr><td><b>Public projects must be turned off for Organization</b>
<br/>
Data/content in projects that have anonymous access can be downloaded by anyone on the internet without authentication. This can lead to a compromise of corporate data. 
</td><td>High</td><td>Yes</td><td>No</td></tr>

<tr><td><b>Justify all guest identities that are granted access on Organization. </b>
<br/>
Non-AD accounts (such as xyz@hotmail.com, pqr@outlook.com, etc.) present at any scope within a Organization subject your cloud assets to undue risk. These accounts are not managed to the same standards as enterprise tenant identities. They don't have multi-factor authentication enabled. Etc.
</td><td>High</td><td>Yes</td><td>No</td></tr>

<tr><td><b>Extensions must be installed from a trustworthy source</b>
<br/>
Running extensions from untrusted source can lead to all type of attacks and loss of sensitive enterprise data.
</td><td>High</td><td>Yes</td><td>No</td></tr>

<tr><td><b>Justify all identities that are granted with manager access for extensions.</b>
<br/>
Accounts with extension manager access can install/manage extensions for Organization. Members with this access without a legitimate business reason increase the risk for Organization. By carefully reviewing and removing accounts that shouldn't be there in the first place, you can avoid attacks if those accounts are compromised.
</td><td>High</td><td>Yes</td><td>No</td></tr>

<tr><td><b>Unintended/inactive user access must be revoked</b>
<br/>
Each additional person having access at Organization level increases the attack surface for the entire resources. To minimize this risk ensure that critical resources present in Organization are accessed only by the legitimate users when required.
</td><td>High</td><td>Yes</td><td>No</td></tr>

<tr><td><b>All teams/groups must be granted minimum required permissions on Organization</b>
<br/>
Granting minimum access by leveraging RBAC feature ensures that users are granted just enough permissions to perform their tasks. This minimizes exposure of the resources in case of user/service account compromise.
</td><td>High</td><td>No</td><td>No</td></tr>


<tr><td><b> Justify all identities that are granted with member access on groups and teams.</b>
<br/>
Accounts that are a member of these groups without a legitimate business reason increase the risk for your Organization. By carefully reviewing and removing accounts that shouldn't be there in the first place, you can avoid attacks if those accounts are compromised.
</td><td>High</td><td>No</td><td>No</td></tr>

<tr><td><b>Alerts must be configured for critical actions on Organization </b>
<br/>
Alerts notify the configured security point of contact about various sensitive activities on the Organization and its resources (for instance, external Extensions have been installed/modified etc.)
</td><td>Low</td><td>No</td><td>No</td></tr>

</table>
<table>
</table>
</body></html>

### Project

<html>
<head>

</head><body>
<table><tr><th>Description & Rationale</th><th>ControlSeverity</th><th>Automated</th><th>Fix Script</th></tr>

<tr><td><b>Projects visibility must be set to private </b>
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
</table>
<table>
</table>
</body></html>


### Build

<html> 
<head>

</head><body>
<table><tr><th>Description & Rationale</th><th>ControlSeverity</th><th>Automated</th><th>Fix Script</th></tr>

<tr><td><b>All teams/groups must be granted minimum required permissions on build defination</b>
<br/>
Granting minimum access by leveraging RBAC feature ensures that users are granted just enough permissions to perform their tasks. This minimizes exposure of the resources in case of user/service account compromise.
</td><td>High</td><td>No</td><td>No</td></tr>

<tr><td><b>Secrets and keys must not be stored as plain text in build variables/task parameters </b>
<br/>
Keeping secrets such as connection strings, passwords, keys, etc. in clear text can lead to easy compromise. Making them secret type variables ensures that they are protected at rest.
</td><td>High</td><td>No</td><td>No</td></tr>


<tr><td><b>Static code analyzer must be enabled on build" </b>
<br/>
Static code analyzer ensure that the code is following all rules for security
</td><td>High</td><td>No</td><td>No</td></tr>


<tr><td><b>Secure Files library must be used to store secret files such as signing certificates, Apple Provisioning Profiles, Android KeyStore files, and SSH keys </b>
<br/>
Keeping secret files such as signing certificates, Apple Provisioning Profiles, Android KeyStore files, SSH keys etc. in repository can lead to easy compromise at various avenues during an application's lifecycle. Storing them in a secure library ensures that they are protected at rest.
</td><td>Medium</td><td>No</td><td>No</td></tr>


<tr><td><b>Inactive build must be removed </b>
<br/>
Each additional build having access at repositories increases the attack surface. To minimize this risk ensure that only activite and legitimate build resources present in Organization
</td><td>Low</td><td>Yes</td><td>No</td></tr>

</table>
<table>
</table>
</body></html>

### Release

<html>
 
<head>

</head><body>
<table><tr><th>Description & Rationale</th><th>ControlSeverity</th><th>Automated</th><th>Fix Script</th></tr>

<tr><td><b>All teams/groups must be granted minimum required permissions on release defination</b>
<br/>
Granting minimum access by leveraging RBAC feature ensures that users are granted just enough permissions to perform their tasks. This minimizes exposure of the resources in case of user/service account compromise.
</td><td>High</td><td>No</td><td>No</td></tr>

<tr><td><b>Secrets and keys must not be stored as plain text in release variables/task parameters</b>
<br/>
Keeping secrets such as connection strings, passwords, keys, etc. in clear text can lead to easy compromise. Making them secret type variables ensures that they are protected at rest.
</td><td>High</td><td>No</td><td>No</td></tr>

<tr><td><b>Inactive release must be removed </b>
<br/>
Each additional release having access at repositories increases the attack surface. To minimize this risk ensure that only activite and legitimate release resources present in Organization
</td><td>Low</td><td>Yes</td><td>No</td></tr>

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
</td><td>Medium</td><td>Yes</td><td>No</td></tr>

<tr><td><b>Justify all identities that are granted with admin/user access for extensions.</b>
<br/>
Accounts with admin access can install/manage extensions for Organization. Members with this access without a legitimate business reason increase the risk for Organization. By carefully reviewing and removing accounts that shouldn't be there in the first place, you can avoid attacks if those accounts are compromised.
</td><td>High</td><td>No</td><td>No</td></tr>

<tr><td><b>Request history must be reviewed validate request is coming from legitimate build/release defination</b>
<br/>
Periodic reviews of request history logs ensures that sevice connection been used from legitimate build definations and avoid major compromise.
</td><td>High</td><td>No</td><td>No</td></tr>

<tr><td><b>Do not use any classic resources on a subscription</b>
<br/>
You should use new ARM/v2 resources as the ARM model provides several security enhancements such as: stronger access control (RBAC), better auditing, ARM-based deployment/governance, access to managed identities, access to key vault for secrets, AAD-based authentication, support for tags and resource groups for easier security management, etc.
</td><td>Medium</td><td>No</td><td>No</td></tr>
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
