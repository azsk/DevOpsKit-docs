<html>
<head>

</head><body>
<H2>User</H2><table><tr><th>Description & Rationale</th><th>ControlSeverity</th><th>Automated</th><th>Fix Script</th></tr>

<tr><td><b>Personal access tokens (PAT) must be defined with minimum required permissions to resources</b>
<br/>
Granting minimum access ensures that PAT is granted with just enough permissions to perform required tasks. This minimizes exposure of the resources in case of PAT compromise.
</td><td>High</td><td>Yes</td><td>No</td></tr>

<tr><td><b>Personal access tokens (PAT) must have a shortest possible validity period</b>
<br/>
If a personal access token (PAT) gets compromised, the Azure DevOps assets accessible to the user can be accessed/manipulated by unauthorized users. Minimizing the validity period of the PAT ensures that the window of time available to an attacker in the event of compromise is small.
</td><td>High</td><td>No</td><td>No</td></tr>

<tr><td><b>Alternate credential must be disabled </b>
<br/>
Alternate credential allows user to create username and password to access your Git repository.Login with these credentials doesn't expire and can't be scoped to limit access to your Azure DevOps Services data.
</td><td>High</td><td>No</td><td>No</td></tr>

</table>
<table>
</table>
</body></html>
