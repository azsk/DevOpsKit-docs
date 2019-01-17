<html>
 
<head>

</head><body>
<H2>Release</H2><table><tr><th>Description & Rationale</th><th>ControlSeverity</th><th>Automated</th><th>Fix Script</th></tr>

<tr><td><b>All teams/groups must be granted minimum required permissions on release defination</b>
<br/>
Granting minimum access by leveraging RBAC feature ensures that users are granted just enough permissions to perform their tasks. This minimizes exposure of the resources in case of user/service account compromise.
</td><td>High</td><td>No</td><td>No</td></tr>

<tr><td><b>Secrets and keys must not be stored as plain text in release variables/task parameters</b>
<br/>
Keeping secrets such as connection strings, passwords, keys, etc. in clear text can lead to easy compromise. Making them secret type variables ensures that they are protected at rest.
</td><td>High</td><td>No</td><td>No</td></tr>

</table>
<table>
</table>
</body></html>
