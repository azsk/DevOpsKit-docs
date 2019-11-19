<html>
<head>

</head><body>
<H2>Virtual Machine Scale Set</H2>
<table>
<tr>
<th>Description & Rationale</th><th>ControlSeverity</th><th>Automated</th><th>Fix Script</th>
</tr>
<tr><td><b>Log analytics agent should be installed on Virtual Machine Scale Set</b><br/>Installing the Log Analytics extension for Windows and Linux allows Azure Monitor to collect data from your Azure VM Scale Sets which can be used for detailed analysis and correlation of events.</td><td>Medium</td><td>Yes</td><td>No</td>
</tr>

<tr><td><b>Antimalware must be enabled with real time protection on Virtual Machine Scale Set</b><br/>Enabling antimalware protection minimizes the risks from existing and new attacks from various types of malware. Microsoft Antimalware provide real-time protection, scheduled scanning, malware remediation, signature updates, engine updates, samples reporting, exclusion event collection etc.</td><td>High</td><td>Yes</td><td>No</td>
</tr>

<tr><td><b>Diagnostics (IaaSDiagnostics extension on Windows; LinuxDiagnostic extension on Linux) must be enabled on Virtual Machine Scale Set</b><br/>Diagnostics logs are needed for creating activity trail while investigating an incident or a compromise.</td><td>Medium</td><td>Yes</td><td>No</td>
</tr>

<tr><td><b>Disk encryption must be enabled on both OS and data disks for Windows Virtual Machine Scale Set</b><br/>Using this feature ensures that sensitive data is stored encrypted at rest. This minimizes the risk of data loss from physical theft and also helps meet regulatory compliance requirements. In the case of VM Scale Set, both OS and data disks may contain sensitive information that needs to be protected at rest. Hence disk encryption must be enabled for both.</td><td>High</td><td>Yes</td><td>No</td>
</tr>

<tr><td><b>All VMs in VM Scale Set must be up-to-date with the latest scale set model</b><br/>All the security configurations applied on VM Scale Set will be effective only if all the individual VM instances in Scale Set is up-to-date with the latest overall Scale Set model.</td><td>High</td><td>Yes</td><td>No</td>
</tr>

<tr><td><b>All users/identities must be granted minimum required permissions using Role Based Access Control (RBAC)</b><br/>Granting minimum access by leveraging RBAC feature ensures that users are granted just enough permissions to perform their tasks. This minimizes exposure of the resources in case of user/service account compromise.</td><td>Medium</td><td>Yes</td><td>No</td>
</tr>

<tr><td><b>Public IPs on a Virtual Machine Scale Set instances should be carefully reviewed</b><br/>Public IPs provide direct access over the internet exposing the VMSS instance to attacks over the public network. Hence each public IP on a VMSS instance must be reviewed carefully.</td><td>High</td><td>Yes</td><td>No</td>
</tr>

<tr><td><b>NSG must be configured for Virtual Machine Scale Set</b><br/>Restricting inbound and outbound traffic via NSGs limits the network exposure of a VM Scale Set by reducing the attack surface.</td><td>Medium</td><td>Yes</td><td>No</td>
</tr>

<tr><td><b>Do not leave management ports open on Virtual Machine Scale Set</b><br/>Open remote management ports expose a VMSS instance/compute node to a high level of risk from internet-based attacks that attempt to brute force credentials to gain admin access to the machine.</td><td>High</td><td>Yes</td><td>No</td>
</tr>

</table>
</body></html>
