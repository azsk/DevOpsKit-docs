## IMPORTANT: DevOps Kit (AzSK) is being sunset by end of FY21. More details [here](../../../ReleaseNotes/AzSKSunsetNotice.md)
----------------------------------------------

<html>
<head>

</head><body>
<H2>HDInsight</H2><table><tr><th>Description & Rationale</th><th>ControlSeverity</th><th>Automated</th><th>Fix Script</th></tr>

<tr><td><b>HDInsight must have supported HDI cluster version</b>
<br/>Being on the latest/supported HDInsight version significantly reduces risks from security bugs or updates that may be present in older or retired cluster versions.  </td>
<td>High</td><td>No</td><td>Yes</td></tr>

<tr><td><b>Use Public-Private key pair together with a passcode for SSH login</b>
<br/>Public-Private key pair help to protect against password guessing and brute force attacks</td>
<td>High</td><td>No</td><td>No</td></tr>

<tr><td><b>HDInsight cluster access must be restricted using virtual network or Azure VPN gateway service with NSG traffic rules</b>
<br/>Restricting cluster access with inbound and outbound traffic via NSGs limits the network exposure for cluster and reduces the attack surface.</td>
<td>High</td><td>No</td><td>Yes</td></tr>

<tr><td><b>Secure transfer protocol must be used for accessing storage account resources</b>
<br/>Use of secure transfer ensures server/service authentication and protects data in transit from network layer man-in-the-middle, eavesdropping, session-hijacking attacks. When enabling HTTPS one must remember to simultaneously disable access over plain HTTP else data can still be subject to compromise over clear text connections.</td>
<td>High</td><td>No</td><td>No</td></tr>

<tr><td><b>Storage used for cluster must have encryption at rest enabled</b>
<br/>Using this feature ensures that sensitive data is stored encrypted at rest. This minimizes the risk of data loss from physical theft and also helps meet regulatory compliance requirements.</td>
<td>High</td><td>No</td><td>No</td></tr>

<tr><td><b>Sensitive data must be stored on storage linked to cluster and not on cluster node disks</b>
<br/>Cluster node restart may cause loss of data present on cluster nodes. Also currently HDInsight does not support encryption at rest for cluster node disk.</td>
<td>High</td><td>No</td><td>No</td></tr>

<tr><td><b>Access to cluster's storage must be restricted to virtual network of the cluster</b>
<br/>Restricting storage access within cluster network boundary reduces the attack surface.</td>
<td>Medium</td><td>No</td><td>No</td></tr>

<tr><td><b>All users/identities must be granted minimum required cluster operation permissions using Ambari Role Based Access Control (RBAC)</b>
<br/>Granting minimum access by leveraging RBAC feature ensures that users are granted just enough permissions to perform their tasks. This minimizes exposure of the resources in case of user/service account compromise.</td>
<td>Medium</td><td>No</td><td>No</td></tr>

<tr><td><b>Only required users/identities must be granted access to Ambari views</b>
<br/>Granting access to only required users to Ambari views ensures minimum exposure of underline data resources.</td>
<td>Medium</td><td>No</td><td>No</td></tr>

<tr><td><b>Ambari admin password must be renewed after a regular interval</b>
<br/>Periodic key/password rotation is a good security hygiene practice as, over time, it minimizes the likelihood of data loss/compromise which can arise from key theft/brute forcing/recovery attacks.</td>
<td>Medium</td><td>No</td><td>No</td></tr>

<tr><td><b>Diagnostics must be enabled for cluster operations</b>
<br/>Diagnostics logs are needed for creating activity trail while investigating an incident or a compromise.</td>
<td>Medium</td><td>No</td><td>No</td></tr>

<tr><td><b>Secrets and keys must not be in plain text in notebooks and jobs</b>
<br/>Keeping secrets such as connection strings, passwords, keys, etc. in clear text can lead to easy compromise. Storing them in a secure place (like KeyVault) ensures that they are protected at rest.</td>
<td>Medium</td><td>No</td><td>No</td></tr>

<table>
</table>
</body></html>
