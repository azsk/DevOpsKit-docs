<html>
<head>

</head><body>
<H2>ServiceConnection</H2><table><tr><th>Description & Rationale</th><th>ControlSeverity</th><th>Automated</th><th>Fix Script</th></tr>

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
