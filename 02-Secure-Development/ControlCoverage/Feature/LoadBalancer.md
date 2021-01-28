## IMPORTANT: DevOps Kit (AzSK) is being sunset by end of FY21. More details [here](../../../ReleaseNotes/AzSKSunsetNotice.md)
----------------------------------------------

<html>
<head>

</head><body>
<H2>LoadBalancer</H2><table><tr><th>Description & Rationale</th><th>ControlSeverity</th><th>Automated</th><th>Fix Script</th></tr><tr><td><b>All users/identities must be granted minimum required permissions using Role Based Access Control (RBAC)</b><br/>Granting minimum access by leveraging RBAC feature ensures that users are granted just enough permissions to perform their tasks. This minimizes exposure of the resources in case of user/service account compromise.</td><td>Medium</td><td>Yes</td><td>No</td></tr><tr><td><b>Diagnostics logs must be enabled with a retention period of at least 365 days.</b><br/>Logs should be retained for a long enough period so that activity trail can be recreated when investigations are required in the event of an incident or a compromise. A period of 1 year is typical for several compliance requirements as well.</td><td>Medium</td><td>Yes</td><td>No</td></tr><tr><td><b>Public IPs on a internet facing Load Balancer should be carefully reviewed</b><br/>Public IPs provide direct access over the internet exposing the infrastructure behind the load balancer to all type of attacks over the public network.</td><td>High</td><td>Yes</td><td>No</td></tr></table>
<table>
</table>
</body></html>
