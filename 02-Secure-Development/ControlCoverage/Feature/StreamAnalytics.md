## IMPORTANT: DevOps Kit (AzSK) is being sunset by end of FY21. More details [here](../../../ReleaseNotes/AzSKSunsetNotice.md)
----------------------------------------------

<html>
<head>

</head><body>
<H2>StreamAnalytics</H2><table><tr><th>Description & Rationale</th><th>ControlSeverity</th><th>Automated</th><th>Fix Script</th></tr><tr><td><b>All users/identities must be granted minimum required permissions using Role Based Access Control (RBAC)</b><br/>Granting minimum access by leveraging RBAC feature ensures that users are granted just enough permissions to perform their tasks. This minimizes exposure of the resources in case of user/service account compromise.</td><td>Medium</td><td>Yes</td><td>No</td></tr><tr><td><b>Diagnostics logs must be enabled with a retention period of at least 365 days.</b><br/>Logs should be retained for a long enough period so that activity trail can be recreated when investigations are required in the event of an incident or a compromise. A period of 1 year is typical for several compliance requirements as well.</td><td>Medium</td><td>Yes</td><td>No</td></tr><tr><td><b>Backup must be planned for Stream Analytics job queries.</b><br/>Stream Analytics does not offer features to cover backup/disaster recovery out-of-the-box. As a result, for critical Stream Analytics queries, a team must have adequate backups of the data.</td><td>Medium</td><td>No</td><td>No</td></tr><tr><td><b>Alert rules must be configured for Runtime Errors and Failed Functions</b><br/>Using alert rules, one can ensure high availability of important/critical services by monitoring jobs and getting alerts for runtime errors and job failures.</td><td>High</td><td>Yes</td><td>No</td></tr><tr><td><b>Paired Regions should be configured for disaster recovery</b><br/>Paired namespaces help maintain consistent availability of a Stream Analytics based solution in case of an outage (e.g. throttling, storage issue, subsystem failure) in the primary region.</td><td>Low</td><td>No</td><td>No</td></tr></table>
<table>
</table>
</body></html>
