<html>
<head>

</head>

<body>
    <H2>KubernetesService</H2>
    <table>
        <tr>
            <th>Description & Rationale</th>
            <th>ControlSeverity</th>
            <th>Automated</th>
        </tr>
        <tr>
            <td><b>Cluster RBAC must be enabled in Kubernetes Service</b><br />Enabling RBAC in a cluster lets you
                finely control access to various operations at the cluster/node/pod/namespace scopes for different
                stakeholders. Without RBAC enabled, every user has full access to the cluster which is a violation of
                the principle of least privilege. Note that Azure Kubernetes Service does not currently support other
                mechanisms to define authorization in Kubernetes (such as Attribute-based Access Control authorization
                or Node authorization).</td>
            <td>High</td>
            <td>Yes</td>
        </tr>
        <tr>
            <td><b>AAD should be enabled in Kubernetes Service</b><br />Using the native enterprise directory for
                authentication ensures that there is a built-in high level of assurance in the user identity
                established for subsequent access control.All Enterprise subscriptions are automatically associated
                with their enterprise directory (xxx.onmicrosoft.com) and users in the native directory are trusted for
                authentication to enterprise subscriptions.</td>
            <td>High</td>
            <td>Yes</td>
        </tr>
        <tr>
            <td><b>All users/identities must be granted minimum required permissions using Role Based Access Control
                    (RBAC)</b><br />Granting minimum access by leveraging RBAC feature ensures that users are granted
                just enough permissions to perform their tasks. This minimizes exposure of the resources in case of
                user/service account compromise.</td>
            <td>Medium</td>
            <td>Yes</td>
        </tr>
        <tr>
            <td><b>Do not directly or indirectly grant cluster admin level access to developers</b><br />Cluster admin
                have full privileges to perform critical operations on Kubernetes cluster. Granting minimum required
                access ensures that developer are granted just enough permissions to perform their tasks.</td>
            <td>High</td>
            <td>No</td>
        </tr>
        <tr>
            <td><b>The latest version of Kubernetes should be used</b><br />Running on older versions could mean you
                are not using latest security classes. Usage of such old classes and types can make your application
                vulnerable.</td>
            <td>Medium</td>
            <td>Yes</td>
        </tr>
        <tr>
            <td><b>Make sure container images (including nested images) deployed in Kubernetes are from a trustworthy
                    source</b><br />If a Kubernetes Service runs an untrusted container image (or an untrusted nested
                image), it can violate integrity of the infrastructure and lead to all types of security attacks.</td>
            <td>High</td>
            <td>No</td>
        </tr>
        <tr>
            <td><b>Do not use the default cluster namespace to deploy applications</b><br />Resources/Applications in
                same namespace will have same access control (RBAC) policies. Users are granted permission on default
                namespace if no other namespace is provided in rolebindings. As a result, the permissions in the
                default namespace might not be appropriate if your application/workload is sensitive. It is hence
                better to create a separate namespace.</td>
            <td>Medium</td>
            <td>No</td>
        </tr>
        <tr>
            <td><b>All Kubernetes Service secrets should be stored in Key Vault</b><br />Keeping secrets such as DB
                connection strings, passwords, keys, etc. in clear text can lead to easy compromise at various avenues
                during an application's lifecycle. Storing them in a key vault ensures that they are protected at rest.</td>
            <td>Medium</td>
            <td>No</td>
        </tr>
        <tr>
            <td><b>All the Kubernetes cluster nodes must have all the required OS patches installed</b><br />Unpatched
                cluster nodes (VMs) are easy targets for compromise from various malware/trojan attacks that exploit
                known vulnerabilities in operating systems and related software.</td>
            <td>Medium</td>
            <td>No</td>
        </tr>
        <tr>
            <td><b>Pod Identity must be used for accessing other AAD-protected resources from the Kubernetes Service.</b><br />Pod
                Identity allows your Kubernetes Service to easily access other AAD-protected resources such as Azure
                Key Vault. The identity is managed by the Azure platform and eliminates the need to
                provision/manage/rotate any secrets thus reducing the overall risk.</td>
            <td>Medium</td>
            <td>No</td>
        </tr>
        <tr>
            <td><b>Issues/recommendations provided by kube advisor should be reviewed periodically</b><br />The
                kube-advisor tool scans Kubernets cluster and reports on issues related to CPU and memory resource
                consumption limits. If resource quotas are not applied then by default pod consumes all the CPU and
                memory available, which impacts availability of another POD/application.</td>
            <td>Medium</td>
            <td>No</td>
        </tr>
        <tr>
            <td><b>Monitoring must be enabled for Azure Kubernetes Service</b><br />Auditing enables log collection of
                important system events pertinent to security. Regular monitoring of audit logs can help to detect any
                suspicious and malicious activity early and respond in a timely manner.</td>
            <td>Medium</td>
            <td>Yes</td>
        </tr>
        <tr>
            <td><b>Do not leave management ports open on Kubernetes nodes unless required</b><br />Open remote
                management ports expose a VM/compute node to a high level of risk from internet-based attacks that
                attempt to brute force credentials to gain admin access to the machine.</td>
            <td>Medium</td>
            <td>Yes</td>
        </tr>
        <tr>
            <td><b>Data transit inside/across Kubernetes must use encrypted channel</b><br />Use of HTTPS ensures
                server/service authentication and protects data in transit from network layer man-in-the-middle,
                eavesdropping, session-hijacking attacks.</td>
            <td>High</td>
            <td>No</td>
        </tr>
        <tr>
            <td><b>Diagnostics logs must be enabled with a retention period of at least 365 days.</b><br />Logs should
                be retained for a long enough period so that activity trail can be recreated when investigations are
                required in the event of an incident or a compromise. A period of 1 year is typical for several
                compliance requirements as well.</td>
            <td>Medium</td>
            <td>Yes</td>
        </tr>
    </table>
    <table>
    </table>
</body>
</html>
