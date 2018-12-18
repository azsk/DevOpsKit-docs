<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"  "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

</head><body>
<H2>Organizaiton</H2><table><tr><th>Description & Rationale</th><th>ControlSeverity</th><th>Automated</th><th>Fix Script</th></tr>
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
</td><td>High</td><td>No</td><td>No</td></tr>

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
