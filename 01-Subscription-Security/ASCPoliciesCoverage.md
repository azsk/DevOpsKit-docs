<html>
<head></head>
<body>
<H1>List of 'ASC default initiative' policies enabled via AzSK</H1>

<H2>Mandatory ASC policies</H2>

<table>

<tr><th>Policy</th><th>Description</th></tr>

<tr><td><b>Audit remote debugging state for an API App</b></td><td>Remote debugging requires inbound ports to be opened on an API app. Remote debugging should be turned off.</td></tr>

<tr><td><b>Audit remote debugging state for a Function App</b></td><td>Remote debugging requires inbound ports to be opened on an function app. Remote debugging should be turned off.</td></tr>

<tr><td><b>Audit remote debugging state for a Web Application</b></td><td>Remote debugging requires inbound ports to be opened on a web application. Remote debugging should be turned off.</td></tr>

<tr><td><b>Audit HTTPS only access for an API App</b></td><td>Use of HTTPS ensures server/service authentication and protects data in transit from network layer eavesdropping attacks.</td></tr>

<tr><td><b>Audit HTTPS only access for a Function App</b></td><td>Use of HTTPS ensures server/service authentication and protects data in transit from network layer eavesdropping attacks.</td></tr>

<tr><td><b>Audit HTTPS only access for a Web Application</b></td><td>Use of HTTPS ensures server/service authentication and protects data in transit from network layer eavesdropping attacks.</td></tr>

<tr><td><b>Audit enabling of only secure connections to your Redis Cache</b></td><td>Audit enabling of only connections via SSL to Redis Cache. Use of secure connections ensures authentication between the server and the service and protects data in transit from network layer attacks such as man-in-the-middle, eavesdropping, and session-hijacking</td></tr>

<tr><td><b>Audit usage of Azure Active Directory for client authentication in Service Fabric</b></td><td>Audit usage of client authentication only via Azure Active Directory in Service Fabric</td></tr>

<tr><td><b>Audit the setting of ClusterProtectionLevel property to EncryptAndSign in Service Fabric</b></td><td>Service Fabric provides three levels of protection (None, Sign and EncryptAndSign) for node-to-node communication using a primary cluster certificate. Set the protection level to ensure that all node-to-node messages are encrypted and digitally signed</td></tr>

<tr><td><b>Audit SQL servers without Advanced Data Security</b></td><td>Audit SQL servers without Advanced Data Security</td></tr>

<tr><td><b>Audit provisioning of an Azure Active Directory administrator for SQL server</b></td><td>Audit provisioning of an Azure Active Directory administrator for your SQL server to enable Azure AD authentication. Azure AD authentication enables simplified permission management and centralized identity management of database users and other Microsoft services</td></tr>

<tr><td><b>Monitor unencrypted SQL databases in Azure Security Center</b></td><td>Unencrypted SQL databases will be monitored by Azure Security Center as recommendations</td></tr>

<tr><td><b>Audit unrestricted network access to storage accounts</b></td><td>Audit unrestricted network access in your storage account firewall settings. Instead, configure network rules so only applications from allowed networks can access the storage account. To allow connections from specific internet or on-premise clients, access can be granted to traffic from specific Azure virtual networks or to public internet IP address ranges</td></tr>

<tr><td><b>Audit secure transfer to storage accounts</b></td><td>Audit requirment of Secure transfer in your storage account. Secure transfer is an option that forces your storage account to accept requests only from secure connections (HTTPS). Use of HTTPS ensures authentication between the server and the service and protects data in transit from network layer attacks such as man-in-the-middle, eavesdropping, and session-hijacking</td></tr>

<tr><td><b>Audit external accounts with owner permissions on a subscription</b></td><td>External accounts with owner permissions should be removed from your subscription in order to prevent unmonitored access.</td></tr>

<tr><td><b>Audit external accounts with write permissions on a subscription</b></td><td>External accounts with write privileges should be removed from your subscription in order to prevent unmonitored access.</td></tr>

<tr><td><b>Audit external accounts with read permissions on a subscription</b></td><td>External accounts with read privileges should be removed from your subscription in order to prevent unmonitored access.</td></tr>

<tr><td><b>Audit deprecated accounts on a subscription</b></td><td>Deprecated accounts should be removed from your subscriptions. Deprecated accounts are accounts that have been blocked from signing in.</td></tr>

<tr><td><b>Audit use of classic storage accounts</b></td><td>Use new Azure Resource Manager v2 for your storage accounts to provide security enhancements such as: stronger access control (RBAC), better auditing, Azure Resource Manager based deployment and governance, access to managed identities, access to key vault for secrets, Azure AD-based authentication and support for tags and resource groups for easier security management</td></tr>

<tr><td><b>Audit use of classic virtual machines</b></td><td>Use new Azure Resource Manager v2 for your virtual machines to provide security enhancements such as: stronger access control (RBAC), better auditing, ARM-based deployment and governance, access to managed identities, access to key vault for secrets, Azure AD-based authentication and support for tags and resource groups for easier security management</td></tr>

<tr><td><b>Monitor unencrypted VM Disks in Azure Security Center</b></td><td>VMs without an enabled disk encryption will be monitored by Azure Security Center as recommendations</td></tr>

<tr><td><b>Monitor OS vulnerabilities in Azure Security Center</b></td><td>Servers which do not satisfy the configured baseline will be monitored by Azure Security Center as recommendations</td></tr>

<tr><td><b>Monitor VM Vulnerabilities in Azure Security Center</b></td><td>Monitors vulnerabilities detected by Vulnerability Assessment solution and VMs without a Vulnerability Assessment solution in Azure Security Center as recommendations.</td></tr>

<tr><td><b>Monitor missing Endpoint Protection in Azure Security Center</b></td><td>Servers without an installed Endpoint Protection agent will be monitored by Azure Security Center as recommendations</td></tr>

<tr><td><b>Monitor missing system updates in Azure Security Center</b></td><td>Missing security system updates on your servers will be monitored by Azure Security Center as recommendations</td></tr>

<tr><td><b>Audit OS vulnerabilities on your virtual machine scale sets in Azure Security Center</b></td><td>Audit the OS vulnerabilities on your virtual machine scale sets to protect them from attacks.</td></tr>

<tr><td><b>Audit the endpoint protection solution on virtual machine scale sets in Azure Security Center</b></td><td>Audit the existence and health of an endpoint protection solution on your virtual machines scale sets, to protect them from threats and vulnerabilities.</td></tr>

<tr><td><b>Audit any missing system updates on virtual machine scale sets in Azure Security Center</b></td><td>Audit whether there are any missing system security updates and critical updates that should be installed to ensure that your Windows and Linux virtual machine scale sets are secure.</td></tr>

<tr><td><b>Monitor SQL vulnerability assessment results in Azure Security Center</b></td><td>Monitor Vulnerability Assessment scan results and recommendations for how to remediate database vulnerabilities.</td></tr>

<tr><td><b>Audit accounts with owner permissions who are not MFA enabled on a subscription</b></td><td>Multi-Factor Authentication (MFA) should be enabled for all subscription accounts with owner permissions to prevent a breach of accounts or resources.</td></tr>

<tr><td><b>Audit accounts with write permissions who are not MFA enabled on a subscription</b></td><td>Multi-Factor Authentication (MFA) should be enabled for all subscription accounts with write privileges to prevent a breach of accounts or resources.</td></tr>

<tr><td><b>Audit accounts with read permissions who are not MFA enabled on a subscription</b></td><td>Multi-Factor Authentication (MFA) should be enabled for all subscription accounts with read privileges to prevent a breach of accounts or resources.</td></tr>

<tr><td><b>Audit standard tier of DDoS protection is enabled for a virtual network</b></td><td>DDoS protection standard should be enabled for all virtual networks with a subnet that is part of an application gateway with a public IP.</td></tr>

<tr><td><b>Audit SQL managed instances without Advanced Data Security</b></td><td>Audit SQL managed instances without Advanced Data Security</td></tr>

</table>

<H2>Optional ASC policies</H2>

<table>

<tr><th>Policy</th><th>Description</th></tr>

<tr><td><b>Audit CORS resource access restrictions for an API App</b></td><td>Cross origin Resource Sharing (CORS) should not allow all domains to access your API app. Allow only required domains to interact with your API app.</td></tr>

<tr><td><b>Audit CORS resource access restrictions for a Function App</b></td><td>Cross origin Resource Sharing (CORS) should not allow all domains to access your Function app. Allow only required domains to interact with your Function app.</td></tr>

<tr><td><b>Audit CORS resource access restrictions for a Web Application</b></td><td>Cross origin Resource Sharing (CORS) should not allow all domains to access your web application. Allow only required domains to interact with your web app.</td></tr>

<tr><td><b>Audit enabling of diagnostic logs in App Services</b></td><td>Audit enabling of diagnostic logs on the app. This enables you to recreate activity trails for investigation purposes if a security incident occurs or your network is compromised</td></tr>

<tr><td><b>Audit enablement of encryption of Automation account variables</b></td><td>It is important to enable encryption of Automation account variable assets when storing sensitive data</td></tr>

<tr><td><b>Audit enabling of diagnostic logs in Batch accounts</b></td><td>Audit enabling of diagnostic logs. This enables you to recreate activity trails to use for investigation purposes; when a security incident occurs or when your network is compromised</td></tr>

<tr><td><b>Audit configuration of metric alert rules on Batch accounts</b></td><td>Audit configuration of metric alert rules on Batch account to enable the required metric</td></tr>

<tr><td><b>Audit enabling of diagnostic logs in Data Lake Analytics</b></td><td>Audit enabling of diagnostic logs. This enables you to recreate activity trails to use for investigation purposes; when a security incident occurs or when your network is compromised</td></tr>

<tr><td><b>Audit enabling of diagnostic logs in Azure Data Lake Store</b></td><td>Audit enabling of diagnostic logs. This enables you to recreate activity trails to use for investigation purposes; when a security incident occurs or when your network is compromised</td></tr>

<tr><td><b>Audit enabling of diagnostic logs in Event Hub</b></td><td>Audit enabling of diagnostic logs. This enables you to recreate activity trails to use for investigation purposes; when a security incident occurs or when your network is compromised</td></tr>

<tr><td><b>Audit authorization rules on Event Hub namespaces</b></td><td>Event Hub clients should not use a namespace level access policy that provides access to all queues and topics in a namespace. To align with the least privilege security model, you shoud create access policies at the entity level for queues and topics to provide access to only the specific entity</td></tr>

<tr><td><b>Audit existence of authorization rules on Event Hub entities</b></td><td>Audit existence of authorization rules on Event Hub entities to grant least-privileged access</td></tr>

<tr><td><b>Audit enabling of diagnostic logs in Key Vault</b></td><td>Audit enabling of diagnostic logs. This enables you to recreate activity trails to use for investigation purposes; when a security incident occurs or when your network is compromised</td></tr>

<tr><td><b>Audit enabling of diagnostic logs in Logic Apps</b></td><td>Audit enabling of diagnostic logs. This enables you to recreate activity trails to use for investigation purposes; when a security incident occurs or when your network is compromised</td></tr>

<tr><td><b>Audit enabling of diagnostic logs for Search service</b></td><td>Audit enabling of diagnostic logs. This enables you to recreate activity trails to use for investigation purposes; when a security incident occurs or when your network is compromised</td></tr>

<tr><td><b>Audit enabling of diagnostic logs in Service Bus</b></td><td>Audit enabling of diagnostic logs. This enables you to recreate activity trails to use for investigation purposes; when a security incident occurs or when your network is compromised</td></tr>

<tr><td><b>Audit authorization rules on Service Bus namespaces</b></td><td>Service Bus clients should not use a namespace level access policy that provides access to all queues and topics in a namespace. To align with the least privilege security model, you shoud create access policies at the entity level for queues and topics to provide access to only the specific entity</td></tr>

<tr><td><b>Audit enabling of diagnostics logs in Service Fabric and Virtual Machine Scale Sets</b></td><td>It is recommended to enable Logs so that activity trail can be recreated when investigations are required in the event of an incident or a compromise.</td></tr>

<tr><td><b>Audit SQL server level Auditing settings</b></td><td>Audits the existence of SQL Auditing at the server level</td></tr>

<tr><td><b>Monitor unaudited SQL servers in Azure Security Center</b></td><td>SQL servers which don't have SQL auditing turned on will be monitored by Azure Security Center as recommendations</td></tr>

<tr><td><b>Audit enabling of diagnostic logs in Azure Stream Analytics</b></td><td>Audit enabling of diagnostic logs. This enables you to recreate activity trails to use for investigation purposes; when a security incident occurs or when your network is compromised</td></tr>

<tr><td><b>Audit usage of custom RBAC rules</b></td><td>Audit built-in roles such as 'Owner, Contributer, Reader' instead of custom RBAC roles, which are error prone. Using custom roles is treated as an exception and requires a rigorous review and threat modeling</td></tr>

<tr><td><b>Audit maximum number of owners for a subscription</b></td><td>It is recommended to designate up to 3 subscription owners in order to reduce the potential for breach by a compromised owner.</td></tr>

<tr><td><b>Audit minimum number of owners for subscription</b></td><td>It is recommended to designate more than one subscription owner in order to have administrator access redundancy.</td></tr>

<tr><td><b>Audit deprecated accounts with owner permissions on a subscription</b></td><td>Deprecated accounts with owner permissions should be removed from your subscription. Deprecated accounts are accounts that have been blocked from signing in.</td></tr>

<tr><td><b>[Preview]: Monitor open management ports on Virtual Machines</b></td><td>Open remote management ports are exposing your VM to a high level of risk from Internet-based attacks. These attacks attempt to brute force credentials to gain admin access to the machine.</td></tr>

<tr><td><b>Monitor Internet-facing virtual machines for Network Security Group traffic hardening recommendations</b></td><td>Azure Security Center analyzes the traffic patterns of Internet facing virtual machines and provides Network Security Group rule recommendations that reduce the potential attack surface</td></tr>

<tr><td><b>Monitor permissive network access in Azure Security Center</b></td><td>Network Security Groups with too permissive rules will be monitored by Azure Security Center as recommendations</td></tr>

<tr><td><b>[Preview]: Monitor IP forwarding on virtual machines</b></td><td>Enabling IP forwarding on a virtual machine's NIC allows the machine to receive traffic addressed to other destinations. IP forwarding is rarely required (e.g., when using the VM as a network virtual appliance), and therefore, this should be reviewed by the network security team.</td></tr>

<tr><td><b>Audit enabling of diagnostic logs in IoT Hubs</b></td><td>Audit enabling of diagnostic logs. This enables you to recreate activity trails to use for investigation purposes; when a security incident occurs or when your network is compromised</td></tr>

<tr><td><b>Monitor possible network Just In Time (JIT) access in Azure Security Center</b></td><td>Possible network Just In Time (JIT) access will be monitored by Azure Security Center as recommendations</td></tr>

<tr><td><b>Monitor possible app Whitelisting in Azure Security Center</b></td><td>Possible Application Whitelist configuration will be monitored by Azure Security Center</td></tr>

<tr><td><b>Monitor permissive network access of VMs running web-apps in Azure Security Center</b></td><td>Azure security center has discovered that some of your virtual machines are running web applications, and the NSGs associated to these virtual machines are overly permissive with regards to the web application ports</td></tr>

<tr><td><b>Monitor unprotected network endpoints in Azure Security Center</b></td><td>Network endpoints without a Next Generation Firewall's protection will be monitored by Azure Security Center as recommendations</td></tr>

<tr><td><b>[Preview]: Monitor SQL data discovery and classification recommendations in Azure Security Center</b></td><td>Azure Security Center monitors the data discovery and classification scan results for your SQL databases and provides recommendations to classify the sensitive data in your databases for better monitoring and security</td></tr>

<tr><td><b>Audit SQL servers without Vulnerability Assessment</b></td><td>Audit Azure SQL servers which do not have recurring vulnerability assessment scans enabled. Vulnerability assessment can discover, track, and help you remediate potential database vulnerabilities.</td></tr>

<tr><td><b>Audit SQL managed instances without Vulnerability Assessment</b></td><td>Audit SQL managed instances which do not have recurring vulnerability assessment scans enabled. Vulnerability assessment can discover, track, and help you remediate potential database vulnerabilities.</td></tr>

<tr><td><b>[Preview]: Monitor permissive network access to app-services</b></td><td>Azure security center has discovered that the networking configuration of some of your app services are overly permissive and allow inbound traffic from ranges that are too broad</td></tr>

</table>

</body>
</html>
