<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"  "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

</head><body>
<H2>Build</H2><table><tr><th>Description & Rationale</th><th>ControlSeverity</th><th>Automated</th><th>Fix Script</th></tr>

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
</td><td>Low</td><td>No</td><td>No</td></tr>

</table>
<table>
</table>
</body></html>
