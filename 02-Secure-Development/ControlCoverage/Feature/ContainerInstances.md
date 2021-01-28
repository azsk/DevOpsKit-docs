## IMPORTANT: DevOps Kit (AzSK) is being sunset by end of FY21. More details [here](../../../ReleaseNotes/AzSKSunsetNotice.md)
----------------------------------------------

<html>
<head>

</head><body>
<H2>ContainerInstances</H2>
<table>
<tr><th>Description & Rationale</th><th>ControlSeverity</th><th>Automated</th><th>Fix Script</th></tr><tr><td><b>Use of public IP address and ports should be carefully reviewed</b><br/>Public IP address provides direct access over the internet exposing the container to all type of attacks over the public network.</td><td>High</td><td>Yes</td><td>No</td></tr>
<tr><td><b>Make sure container images (including nested images) are from a trustworthy source</b><br/>If a container runs an untrusted image (or an untrusted nested image), it can violate integrity of the infrastructure and lead to all types of security attacks.</td><td>High</td><td>Yes</td><td>No</td></tr>
<tr><td><b>Make sure container images are hosted on a trustworthy registry that has strong authentication, authorization and data protection mechanisms</b><br/>If a container image is served from an untrusted registry, the image itself may not be trustworthy. Running such a compromised image can lead to loss of sensitive enterprise data.</td><td>High</td><td>Yes</td><td>No</td></tr>
<tr><td><b>A container group must contain only containers which trust each other</b><br/>Containers hosted in the same container group can monitor traffic of other containers within the group and can also access the file system of the host OS. Hence a container group must not host containers which do not trust each other. In other words, do not mix containers across trust boundaries in the same group.</td><td>High</td><td>Yes</td><td>No</td></tr>
</table>
</body></html>
