<H2>AzSK Alerts List </H2>
<H2> Mandatory Alerts </H2>
<table>
    <tr>
        <th align="left">Alert Name</th>
        <th align="left">Description</th>
        <th align="left">Operation List</th>
    </tr>
    <tr>
        <td>AzSK_Subscription_Alert</td>
        <td>Alerts for Subscription Activities</td>
        <td>Microsoft.Authorization/elevateAccess/action <br /> Microsoft.Authorization/classicAdministrators/write <br />
            Microsoft.Authorization/classicAdministrators/delete <br /> Microsoft.Authorization/locks/write <br />
            Microsoft.Authorization/locks/delete <br /> Microsoft.Authorization/policyAssignments/delete <br />
            Microsoft.Authorization/policyAssignments/write <br /> Microsoft.Authorization/policyDefinitions/delete <br />
            Microsoft.Authorization/roleAssignments/write <br /> Microsoft.Authorization/roleAssignments/delete <br />
            Microsoft.Insights/ActivityLogAlerts/Delete <br /> Microsoft.Insights/ActivityLogAlerts/Write <br />
            Microsoft.Insights/ActionGroups/Write <br /> Microsoft.Insights/ActionGroups/Delete <br /></td>
    </tr>
    <tr>
        <td>AzSK_Storage_Alert</td>
        <td>Alerts for Storage Account</td>
        <td>Microsoft.Storage/storageAccounts/delete <br /></td>
    </tr>
    <tr>
        <td>AzSK_Database_Alert</td>
        <td>Alerts for Database</td>
        <td>Microsoft.Sql/servers/administrators/write <br /> Microsoft.Sql/servers/administrators/delete <br />
            Microsoft.Sql/servers/firewallRules/write <br /> Microsoft.Sql/servers/firewallRules/delete <br />
            Microsoft.Sql/servers/elasticPools/delete <br /> Microsoft.Sql/servers/databases/delete <br /></td>
    </tr>
    <tr>
        <td>AzSK_Networking_Alert</td>
        <td>Alerts for Network</td>
        <td>Microsoft.Network/dnszones/write <br /> Microsoft.Network/dnszones/delete <br />
            Microsoft.Network/dnszones/MX/write <br /> Microsoft.Network/dnszones/MX/delete <br />
            Microsoft.Network/dnszones/AAAA/write <br /> Microsoft.Network/dnszones/AAAA/delete <br />
            Microsoft.Network/dnszones/CNAME/write <br /> Microsoft.Network/dnszones/CNAME/delete <br />
            Microsoft.Network/dnszones/A/write <br /> Microsoft.Network/dnszones/A/delete <br />
            Microsoft.Network/virtualNetworks/delete <br /></td>
    </tr>
    <tr>
        <td>AzSK_Security_Alert</td>
        <td>Alerts for KeyVault</td>
        <td>Microsoft.KeyVault/vaults/write <br /> Microsoft.KeyVault/vaults/delete <br />
            Microsoft.KeyVault/vaults/secrets/write <br /></td>
    </tr>
    <tr>
        <td>AzSK_Analytics_Alert</td>
        <td>Alerts for Analytics</td>
        <td>Microsoft.DataLakeAnalytics/accounts/delete <br /></td>
    </tr>
    <tr>
        <td>AzSK_Compute_Alert</td>
        <td>Alerts for Compute</td>
        <td>Microsoft.Compute/virtualMachines/delete <br /></td>
    </tr>
    <tr>
        <td>AzSK_Web_Alert_v2</td>
        <td>Alerts for Web</td>
        <td>Microsoft.Web/sites/Delete <br /></td>
    </tr>
</table>

<H2> Optional Alerts </H2>
<table>
    <tr>
        <th align="left">Alert Name</th>
        <th align="left">Description</th>
        <th align="left">Operation List</th>
    </tr>
    <tr>
    <td>AzSK_SQL_Alert</td>
    <td>Alerts for SQL</td>
    <td>Microsoft.Sql/servers/administrators/write <br /> Microsoft.Sql/servers/administrators/delete <br />
        Microsoft.Sql/servers/firewallRules/write <br /> Microsoft.Sql/servers/firewallRules/delete <br />
        Microsoft.Sql/servers/elasticPools/delete <br /> Microsoft.Sql/servers/databases/delete <br />
        Microsoft.Sql/servers/databases/replicationLinks/delete <br />
        Microsoft.Sql/servers/databases/replicationLinks/unlink/action <br />
        Microsoft.Sql/servers/databases/dataMaskingPolicies/write <br />
        Microsoft.Sql/servers/databases/dataMaskingPolicies/rules/delete <br />
        Microsoft.Sql/servers/databases/dataMaskingPolicies/rules/write <br />
        Microsoft.Sql/servers/databases/connectionPolicies/write <br />
        Microsoft.Sql/servers/databases/transparentDataEncryption/write <br />
        Microsoft.Sql/servers/databases/auditingPolicies/write <br /> Microsoft.Sql/servers/virtualNetworkRules/write
        <br /> Microsoft.Sql/servers/virtualNetworkRules/delete <br /></td>
</tr>
<tr>
    <td>AzSK_Services_Alert</td>
    <td>Alerts for Azure Services</td>
    <td>Microsoft.ServiceBus/namespaces/authorizationRules/write <br />
        Microsoft.ServiceBus/namespaces/authorizationRules/delete <br />
        Microsoft.ServiceBus/namespaces/authorizationRules/listkeys/action <br />
        Microsoft.ServiceBus/namespaces/queues/Delete <br />
        Microsoft.ServiceBus/namespaces/queues/authorizationRules/write <br />
        Microsoft.ServiceBus/namespaces/queues/authorizationRules/delete <br />
        Microsoft.ServiceBus/namespaces/queues/authorizationRules/listkeys/action <br />
        Microsoft.ServiceBus/namespaces/topics/Delete <br />
        Microsoft.ServiceBus/namespaces/topics/authorizationRules/write <br />
        Microsoft.ServiceBus/namespaces/topics/authorizationRules/delete <br />
        Microsoft.ServiceBus/namespaces/topics/authorizationRules/listkeys/action <br />
        Microsoft.ServiceBus/namespaces/topics/subscriptions/Delete <br /> Microsoft.DataLakeStore/accounts/delete
        <br /> Microsoft.DataLakeStore/accounts/firewallRules/write <br /> Microsoft.DataLakeAnalytics/accounts/delete
        <br /> Microsoft.DataLakeAnalytics/accounts/storageAccounts/delete <br />
        Microsoft.DataLakeAnalytics/accounts/dataLakeStoreAccounts/delete <br /> Microsoft.Compute/virtualMachines/write
        <br /> Microsoft.Compute/virtualMachines/delete <br /> Microsoft.Compute/virtualMachines/extensions/write <br />
        Microsoft.Compute/virtualMachines/extensions/delete <br /> Microsoft.Cache/redis/patchSchedules/delete <br />
        Microsoft.DocumentDB/databaseAccounts/listKeys/action <br />
        Microsoft.DocumentDB/databaseAccounts/regenerateKey/action <br /> Microsoft.Cache/redis/regenerateKey/action
        <br /> Microsoft.Cache/redis/firewallRules/write <br /> Microsoft.Cache/redis/firewallRules/delete <br />
        Microsoft.ContainerService/managedClusters/accessProfiles/listCredential/action <br />
        Microsoft.ContainerService/managedClusters/listClusterAdminCredential/action <br />
        Microsoft.ContainerRegistry/registries/listCredentials/action <br />
        Microsoft.ContainerRegistry/registries/regenerateCredential/action <br />
        Microsoft.ContainerRegistry/locations/deleteVirtualNetworkOrSubnets/action <br />
        Microsoft.ContainerInstance/locations/deleteVirtualNetworkOrSubnets/action <br />
        Microsoft.HDInsight/clusters/updateGatewaySettings/action <br />
        Microsoft.HDInsight/clusters/configurations/action <br /> Microsoft.HDInsight/clusters/applications/write <br />
        Microsoft.HDInsight/clusters/applications/delete <br />
        Microsoft.NotificationHubs/Namespaces/authorizationRules/write <br />
        Microsoft.NotificationHubs/Namespaces/NotificationHubs/authorizationRules/write <br />
        Microsoft.NotificationHubs/Namespaces/authorizationRules/listkeys/action <br />
        Microsoft.NotificationHubs/Namespaces/authorizationRules/regenerateKeys/action <br />
        Microsoft.NotificationHubs/Namespaces/NotificationHubs/authorizationRules/listkeys/action <br />
        Microsoft.NotificationHubs/Namespaces/NotificationHubs/authorizationRules/regenerateKeys/action <br />
        Microsoft.Cdn/profiles/GenerateSsoUri/action <br />
        Microsoft.Cdn/profiles/endpoints/customdomains/DisableCustomHttps/action <br />
        Microsoft.Automation/automationAccounts/agentRegistrationInformation/regenerateKey/action <br />
        Microsoft.ApiManagement/service/users/action <br /> Microsoft.ApiManagement/service/groups/write <br />
        Microsoft.ApiManagement/service/groups/users/write <br /> Microsoft.ApiManagement/service/users/write <br />
        Microsoft.ApiManagement/service/users/token/action <br />
        Microsoft.ApiManagement/service/users/generateSsoUrl/action <br />
        Microsoft.ApiManagement/service/getssotoken/action <br />
        Microsoft.ApiManagement/service/applynetworkconfigurationupdates/action <br />
        Microsoft.ApiManagement/service/tenant/regeneratePrimaryKey/action <br />
        Microsoft.ApiManagement/service/tenant/regenerateSecondaryKey/action <br />
        Microsoft.ApiManagement/service/products/policy/write <br />
        Microsoft.ApiManagement/service/products/policy/delete <br />
        Microsoft.ApiManagement/service/products/policies/write <br />
        Microsoft.ApiManagement/service/products/policies/delete <br />
        Microsoft.ApiManagement/service/subscriptions/regeneratePrimaryKey/action <br />
        Microsoft.ApiManagement/service/subscriptions/regenerateSecondaryKey/action <br />
        Microsoft.ApiManagement/service/apis/operations/policy/write <br />
        Microsoft.ApiManagement/service/apis/operations/policy/delete <br />
        Microsoft.ApiManagement/service/apis/operations/policies/write <br />
        Microsoft.ApiManagement/service/apis/operations/policies/delete <br /></td>
</tr>
<tr>
    <td>AzSK_Network_Alert</td>
    <td>Alerts for Network</td>
    <td>Microsoft.Network/dnszones/write <br /> Microsoft.Network/dnszones/delete <br />
        Microsoft.Network/dnszones/MX/write <br /> Microsoft.Network/dnszones/MX/delete <br />
        Microsoft.Network/dnszones/AAAA/write <br /> Microsoft.Network/dnszones/AAAA/delete <br />
        Microsoft.Network/dnszones/CNAME/write <br /> Microsoft.Network/dnszones/CNAME/delete <br />
        Microsoft.Network/dnszones/A/write <br /> Microsoft.Network/dnszones/A/delete <br />
        Microsoft.Network/networkInterfaces/write <br /> Microsoft.Network/networkInterfaces/join/action <br />
        Microsoft.Network/networkInterfaces/delete <br /> Microsoft.Network/publicIPAddresses/delete <br />
        Microsoft.Network/virtualNetworks/write <br /> Microsoft.Network/virtualNetworks/delete <br />
        Microsoft.Network/virtualNetworks/peer/action <br />
        Microsoft.Network/virtualNetworks/virtualNetworkPeerings/write <br />
        Microsoft.Network/virtualNetworks/virtualNetworkPeerings/delete <br />
        Microsoft.Network/virtualNetworks/subnets/write <br /> Microsoft.Network/virtualNetworks/subnets/delete <br />
        Microsoft.Network/virtualNetworks/subnets/join/action <br /> Microsoft.Network/networkSecurityGroups/write
        <br /> Microsoft.Network/networkSecurityGroups/delete <br /> Microsoft.Network/networkSecurityGroups/join/action
        <br /> Microsoft.Network/networkSecurityGroups/securityRules/write <br />
        Microsoft.Network/networkSecurityGroups/securityRules/delete <br /> Microsoft.Network/routeTables/write <br />
        Microsoft.Network/routeTables/delete <br /> Microsoft.Network/routeTables/join/action <br />
        Microsoft.Network/routeTables/routes/write <br /> Microsoft.Network/routeTables/routes/delete <br />
        Microsoft.Network/loadBalancers/inboundNatRules/write <br />
        Microsoft.Network/trafficManagerProfiles/azureEndpoints/write <br />
        Microsoft.Network/trafficManagerProfiles/externalEndpoints/write <br />
        Microsoft.Network/trafficManagerProfiles/nestedEndpoints/write <br /></td>
</tr>
<tr>
    <td>AzSK_Web_Alert</td>
    <td>Alerts for Web </td>
    <td>Microsoft.Web/sites/Delete <br /> Microsoft.Web/sites/slotsswap/Action <br />
        Microsoft.Web/sites/applySlotConfig/Action <br /> Microsoft.Web/sites/slots/config/Write <br />
        Microsoft.Web/sites/slots/config/list/Action <br /> Microsoft.Web/sites/config/Write <br />
        Microsoft.Web/sites/config/list/Action <br /> Microsoft.Web/sites/functions/listSecrets/Action <br />
        Microsoft.Web/certificates/Write <br /> Microsoft.Web/certificates/Delete <br />
        Microsoft.web/publishingusers/write <br /> Microsoft.Web/sites/publishxml/Action <br />
        Microsoft.web/sites/virtualnetworkconnections/write <br /> Microsoft.web/sites/virtualnetworkconnections/delete
        <br /></td>
</tr>
<tr>
    <td>AzSK_KeyVault_Alert</td>
    <td>Alerts for KeyVault</td>
    <td>Microsoft.KeyVault/vaults/write <br /> Microsoft.KeyVault/vaults/delete <br />
        Microsoft.KeyVault/vaults/deploy/action <br /> Microsoft.KeyVault/vaults/secrets/read <br />
        Microsoft.KeyVault/vaults/secrets/write <br /></td>
</tr>
</table>