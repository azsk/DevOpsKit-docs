## IMPORTANT: DevOps Kit (AzSK) is being sunset by end of FY21. More details [here](../../../ReleaseNotes/AzSKSunsetNotice.md)
----------------------------------------------

<html>
<head>

</head><body>
<H2>TrafficManager</H2><table><tr><th>Description & Rationale</th><th>ControlSeverity</th><th>Automated</th><th>Fix Script</th></tr><tr><td><b>All Users/Identities must be granted minimum required permissions using Role Based Access Control (RBAC)</b><br/>Granting minimum access by leveraging RBAC feature ensures that users are granted just enough permissions to perform their tasks. This minimizes exposure of the resources in case of user/service account compromise.</td><td>Medium</td><td>Yes</td><td>No</td></tr><tr><td><b>Traffic Manager profile should use HTTPS protocol for endpoint monitoring</b><br/>Use of HTTPS ensures server/service authentication and protects data in transit from network layer man-in-the-middle, eavesdropping, session-hijacking attacks.</td><td>Medium</td><td>Yes</td><td>Yes</td></tr></table>
<table>
</table>
</body></html>
