## IMPORTANT: DevOps Kit (AzSK) is being sunset by end of FY21. More details [here](../../../ReleaseNotes/AzSKSunsetNotice.md)
----------------------------------------------

<html>
<head>

</head>

<body>
    <H2>VirtualNetwork</H2>
    <table>
        <tr>
            <th>Description & Rationale</th>
            <th>ControlSeverity</th>
            <th>Automated</th>
            <th>Fix Script</th>
        </tr>
        <tr>
            <td><b>Minimize the number of Public IPs (i.e. NICs with PublicIP) on a virtual network</b><br />Public IPs
                provide direct access over the internet exposing the VM to all type of attacks over the public network.</td>
            <td>High</td>
            <td>Yes</td>
            <td>No</td>
        </tr>
        <tr>
            <td><b>Use of IP Forwarding on any NIC in a virtual network should be scrutinized</b><br />Enabling IP
                Forwarding on a VM NIC allows the VM to receive traffic addressed to other destinations. IP forwarding
                is required only in rare scenarios (e.g., using the VM as a network virtual appliance) and those should
                be reviewed with the network security team.</td>
            <td>High</td>
            <td>Yes</td>
            <td>No</td>
        </tr>
        <tr>
            <td><b>NSG should be used for subnets in a virtual network to permit traffic only on required
                    inbound/outbound ports. NSGs should not have a rule to allow any-to-any traffic</b><br />Restricting
                inbound and outbound traffic via NSGs limits the network exposure of the subnets within a virtual
                network and limits the attack surface.</td>
            <td>Medium</td>
            <td>Yes</td>
            <td>No</td>
        </tr>
        <tr>
            <td><b>All users/identities must be granted minimum required permissions using Role Based Access Control
                    (RBAC)</b><br />Granting minimum access by leveraging RBAC feature ensures that users are granted
                just enough permissions to perform their tasks. This minimizes exposure of the resources in case of
                user/service account compromise.</td>
            <td>Medium</td>
            <td>Yes</td>
            <td>No</td>
        </tr>
        <tr>
            <td><b>Presence of any virtual network gateways (GatewayType = VPN/ExpressRoute) in the virtual network
                    must be justified</b><br />Virtual network gateways enable network traffic between a virtual
                network and other networks. All such connectivity must be carefully scrutinized to ensure that
                corporate data is not subject to exposure on untrusted networks.</td>
            <td>High</td>
            <td>Yes</td>
            <td>No</td>
        </tr>
        <tr>
            <td><b>Use of any virtual network peerings should be justified</b><br />Resources in the peered virtual
                networks can communicate with each other directly. If the two peered networks are on different sides of
                a security boundary (e.g., corpnet v. private vNet), this can lead to exposure of corporate data. Hence
                any vNet peerings should be closely scrutinized and approved by the network security team</td>
            <td>High</td>
            <td>Yes</td>
            <td>No</td>
        </tr>
    </table>
    <table>
    </table>
</body>

</html>
