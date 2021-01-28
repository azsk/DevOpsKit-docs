## IMPORTANT: DevOps Kit (AzSK) is being sunset by end of FY21. More details [here](../../../ReleaseNotes/AzSKSunsetNotice.md)
----------------------------------------------

<html>
<head>

</head><body>
<H2>DataFactoryV2</H2><table><tr><th>Description & Rationale</th><th>ControlSeverity</th><th>Automated</th></tr><tr><td><b>User accounts/roles connecting to data source must have minimum required permissions</b><br/>Granting minimum access ensures that users are granted just enough permissions to perform their tasks. This minimizes exposure of the resources in case of user/service account compromise.</td><td>Medium</td><td>No</td></tr><tr><td><b>All linked service credentials should be stored in Key Vault.</b><br/>Keeping secrets such as DB connection strings, passwords, keys, etc., in clear text can lead to easy compromise at various avenues during an application's lifecycle. Storing them in a key vault ensures that they are protected at rest.</td><td>Medium</td><td>No</td></tr><tr><td><b>Data factory must use a service identity for authenticating to supported linked services.</b><br/>Using a service identity for authentication ensures that there is a built-in high level of assurance for subsequent access control.</td><td>Medium</td><td>No</td></tr><tr><td><b>Configure activity output as 'Secure Output' if the activity emits sensitive data.</b><br/>Configuring activity output as 'Secure Output' prevents it from getting logged to monitoring.</td><td>Medium</td><td>No</td></tr></table>
<table>
</table>
</body></html>
