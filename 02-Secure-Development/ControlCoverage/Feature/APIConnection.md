## IMPORTANT: DevOps Kit (AzSK) is being sunset by end of FY21. More details [here](/../../ReleaseNotes/AzSKSunsetNotice.md)
----------------------------------------------

<html>
<head>

</head><body>
<H2>APIConnection</H2><table><tr><th>Description & Rationale</th><th>ControlSeverity</th><th>Automated</th><th>Fix Script</th></tr><tr><td><b>Logic App connectors must use AAD-based authentication wherever possible</b><br/>Using the native enterprise directory for authentication ensures that there is a built-in high level of assurance in the user identity established for subsequent access control. All Enterprise subscriptions are automatically associated with their enterprise directory (xxx.onmicrosoft.com) and users in the native directory are trusted for authentication to enterprise subscriptions.</td><td>High</td><td>Yes</td><td>No</td></tr><tr><td><b>Data transit across connectors must use encrypted channel</b><br/>Use of HTTPS ensures server/service authentication and protects data in transit from network layer man-in-the-middle, eavesdropping, session-hijacking attacks.</td><td>High</td><td>Yes</td><td>No</td></tr></table>
<table>
</table>
</body></html>
