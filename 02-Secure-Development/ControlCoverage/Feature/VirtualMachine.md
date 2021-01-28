## IMPORTANT: DevOps Kit (AzSK) is being sunset by end of FY21. More details [here](../../../ReleaseNotes/AzSKSunsetNotice.md)
----------------------------------------------

<html>
<head>

</head><body>
<H2>VirtualMachine</H2><table><tr><th>Description & Rationale</th><th>ControlSeverity</th><th>Automated</th><th>Fix Script</th></tr><tr><td><b>Virtual Machine should have latest OS version installed</b><br/>Being on the latest OS version significantly reduces risks from security design issues and security bugs that may be present in older versions.</td><td>Medium</td><td>Yes</td><td>No</td></tr><tr><td><b>OS automatic updates must be enabled on Windows Virtual Machine</b><br/>VMs where automatic updates are disabled are likely to miss important security patches due to human error. This may lead to compromise from various malware/trojan attacks that exploit known vulnerabilities in operating systems and related software.</td><td>High</td><td>Yes</td><td>No</td></tr><tr><td><b>Antimalware must be enabled with real time protection on Windows Virtual Machine</b><br/>Enabling antimalware protection minimizes the risks from existing and new attacks from various types of malware. Microsoft Antimalware provide real-time protection, scheduled scanning, malware remediation, signature updates, engine updates, samples reporting, exclusion event collection etc.</td><td>High</td><td>Yes</td><td>No</td></tr><tr><td><b>NSG must be configured for Virtual Machine</b><br/>Restricting inbound and outbound traffic via NSGs limits the network exposure of a VM by reducing the attack surface.</td><td>Medium</td><td>Yes</td><td>No</td></tr><tr><td><b>Public IPs on a Virtual Machine should carefully reviewed</b><br/>Public IPs provide direct access over the internet exposing the VM to attacks over the public network. Hence each public IP on a VM must be reviewed carefully.</td><td>High</td><td>Yes</td><td>No</td></tr><tr><td><b>Disk encryption must be enabled on both OS and data disks for Windows Virtual Machine</b><br/>Using this feature ensures that sensitive data is stored encrypted at rest. This minimizes the risk of data loss from physical theft and also helps meet regulatory compliance requirements. In the case of VMs, both OS and data disks may contain sensitive information that needs to be protected at rest. Hence disk encryption must be enabled for both.</td><td>High</td><td>Yes</td><td>No</td></tr><tr><td><b>Virtual Machine must be in a healthy state in Azure Security Center</b><br/>Azure Security Center raises alerts (which are typically indicative of resources that are not compliant with some baseline security protection). It is important that these alerts/actions are resolved promptly in order to eliminate the exposure to attacks.</td><td>High</td><td>Yes</td><td>No</td></tr><tr><td><b>Virtual Machine must have all the required OS patches installed.</b><br/>Unpatched VMs are easy targets for compromise from various malware/trojan attacks that exploit known vulnerabilities in operating systems and related software.</td><td>High</td><td>Yes</td><td>No</td></tr><tr><td><b>Virtual Machine must implement all the flagged ASC recommendations.</b><br/>Azure Security Center provide various security recommendations for resources that are not compliant with some baseline security protection. It is important that these recommendations are resolved promptly in order to eliminate the exposure to attacks.</td><td>High</td><td>Yes</td><td>No</td></tr><tr><td><b>Diagnostics (IaaSDiagnostics extension on Windows; LinuxDiagnostic extension on Linux) must be enabled on Virtual Machine</b><br/>Diagnostics logs are needed for creating activity trail while investigating an incident or a compromise.</td><td>Medium</td><td>Yes</td><td>No</td></tr><tr><td><b>Do not leave management ports open on Virtual Machines</b><br/>Open remote management ports expose a VM/compute node to a high level of risk from internet-based attacks that attempt to brute force credentials to gain admin access to the machine.</td><td>Critical</td><td>Yes</td><td>No</td></tr><tr>
    <td><b>Vulnerability assessment solution should be installed on VM</b><br />Known OS/framework vulnerabilities in a system can be easy targets for attackers. An attacker can start by compromising a VM/container with such a vulnerability and can eventually compromise the security of the entire network. A vulnerability assessment solution can help to detect/warn about vulnerabilities in the system and facilitate addressing them in a timely manner.</td>
    <td>Medium</td>
    <td>Yes</td>
    <td>No</td>
</tr>
<tr>
    <td><b>Guest Configuration extension must be deployed to the VM using Azure Policy assignment</b><br />Installing Guest configuration extension on VM allows you to run In-Guest Policy on the VM, making it possible to monitor system and security policies for compliance checks in the VM.</td>
    <td>Medium</td>
    <td>Yes</td>
    <td>No</td>
</tr>
<tr>
    <td><b>Guest config extension should report compliant status for all in-guest policies</b><br />In-guest policies cover various native (data-plane)  security requirements for a VM.  A VM that is compliant to these requirements has a lower overall exposure to getting compromised.</td>
    <td>Medium</td>
    <td>Yes</td>
    <td>No</td>
</tr>
<tr>
    <td><b>All VM extensions required as per your Org policy must be deployed to the VM</b><br />One or more extensions may be required for maintaining data plane security hygiene and visibility for all Azure VMs in use at an Org. It is important to ensure all required extensions are installed and in healthy provisioning state.</td>
    <td>Medium</td>
    <td>Yes</td>
    <td>No</td>
</tr></table>
<table>
</table>
</body></html>
