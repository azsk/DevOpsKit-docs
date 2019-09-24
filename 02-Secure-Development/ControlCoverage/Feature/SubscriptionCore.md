<html>

<head>

</head>

<body>
    <H2>SubscriptionCore</H2>
    <table>
        <tr>
            <th>Control ID, Description & Rationale</th>
            <th>ControlSeverity</th>
            <th>Automated</th>
            <th>Fix Script</th>
        </tr>
        <tr>
            <td>Azure_Subscription_AuthZ_Limit_Admin_Owner_Count<br/><br/><b>Minimize the number of admins/owners</b><br />Each additional person in the Owner/Contributor role
                increases the attack surface for the entire subscription. The number of members in these roles should be
                kept to as low as possible.</td>
            <td>Medium</td>
            <td>Yes</td>
            <td>No</td>
        </tr>
        <tr>
            <td>Azure_Subscription_AuthZ_Justify_Admins_Owners<br/></br><b>Justify all identities that are granted with admin/owner access on your
                    subscription.</b><br />Accounts that are a member of these groups without a legitimate business
                reason increase the risk for your subscription. By carefully reviewing and removing accounts that
                shouldn't be there in the first place, you can avoid attacks if those accounts are compromised.</td>
            <td>Medium</td>
            <td>Yes</td>
            <td>No</td>
        </tr>
        <tr>
            <td>Azure_Subscription_AuthZ_Add_Required_Central_Accounts<br/><br/><b>Mandatory central accounts must be present on the subscription</b><br />Certain central accounts are
                expected to be present in all subscriptions to support enterprise wide functions (e.g., security
                scanning, cost optimization, etc.). Certain other accounts may also be required depending on special
                functionality enabled in a subscription (e.g., Express Route network management). The script checks for
                presence of such 'mandatory' and 'scenario-specific' accounts. If these are not present per the current
                baseline, there may be security/functionality impact for your subscription.</td>
            <td>High</td>
            <td>Yes</td>
            <td>Yes</td>
        </tr>
        <tr>
            <td>Azure_Subscription_AuthZ_Remove_Deprecated_Accounts<br/><br/><b>Deprecated/stale accounts must not be present on the subscription</b><br />Deprecated accounts are
                ones that were once deployed to your subscription for some trial/pilot initiative (or some other
                purpose). These are not required any more and are a standing risk if present in any role on the
                subscription.</td>
            <td>Critical</td>
            <td>Yes</td>
            <td>Yes</td>
        </tr>
        <tr>
            <td>Azure_Subscription_AuthZ_Dont_Use_NonAD_Identities<br/><br/><b>Do not grant permissions to external accounts (i.e., accounts outside the native directory for the
                    subscription)</b><br />Non-AD accounts (such as xyz@hotmail.com, pqr@outlook.com, etc.) present at
                any scope within a subscription subject your cloud assets to undue risk. These accounts are not managed
                to the same standards as enterprise tenant identities. They don't have multi-factor authentication
                enabled. Etc.</td>
            <td>High</td>
            <td>Yes</td>
            <td>No</td>
        </tr>
        <tr>
            <td>Azure_Subscription_AuthZ_Dont_Use_SVC_Accounts_No_MFA<br/><br/><b>Service accounts cannot support MFA and should not be used for subscription activity</b><br />Service
                accounts are typically not multi-factor authentication capable. Quite often, teams who own these
                accounts don't exercise due care (e.g., someone may login interactively on servers using a service
                account exposing their credentials to attacks such as pass-the-hash, phishing, etc.) As a result, using
                service accounts in any privileged role in a subscription exposes the subscription to 'credential
                theft'-related attack vectors. (In effect, the subscription becomes accessible after just one factor
                (password) is compromised...this defeats the whole purpose of imposing the MFA requirement for cloud
                subscriptions.)</td>
            <td>High</td>
            <td>No</td>
            <td>No</td>
        </tr>
        <tr>
            <td>Azure_Subscription_AuthZ_Limit_ClassicAdmin_Count<br/><br/><b>There should not be more than 2 classic administrators</b><br />The v1 (ASM-based) version of Azure
                resource access model did not have much in terms of RBAC granularity. As a result, everyone who needed
                any access on a subscription or its resources had to be added to the Co-administrator role. These
                individuals are referred to as 'classic' administrators. In the v2 (ARM-based) model, this is not
                required at all and even the count of 2 classic admins currently permitted is for backward
                compatibility. (Some Azure services are still migrating onto the ARM-based model so creating/operating
                on them needs 'classic' admin privilege.)</td>
            <td>High</td>
            <td>Yes</td>
            <td>No</td>
        </tr>
        <tr>
            <td>Azure_Subscription_AuthZ_Remove_Management_Certs<br/></br><b>Use of management certificates is not permitted.</b><br />Just like classic admins, management
                certificates were used in the v1 model for script/tool based automation on Azure subscriptions. These
                management certificates are risky because the (private) key management hygiene tends to be lax. These
                certificates have no role to play in the current ARM-based model and should be immediately cleaned up if
                found on a subscription. (VS-deployment certificates from v1 timeframe are a good example of these.)
            </td>
            <td>High</td>
            <td>Yes</td>
            <td>No</td>
        </tr>
        <tr>
            <td>Azure_Subscription_Config_Azure_Security_Center<br/><br/><b>Azure Security Center (ASC) must be correctly configured on the subscription</b><br />The Security
                Center feature in Azure helps with important central settings for the subscription such as configuring a
                security point of contact. It also supports key policy settings (e.g., is patching configured for VMs?,
                is threat detection enabled for SQL?, etc.) and alerts about resources which are not compliant to those
                policy settings. Correctly configuring ASC is critical as it gives a baseline layer of protection for
                the subscription and commonly used resource types.</td>
            <td>High</td>
            <td>Yes</td>
            <td>Yes</td>
        </tr>
        <tr>
            <td>Azure_Subscription_Audit_Resolve_Azure_Security_Center_Alerts<br/><br/><b>Pending Azure Security Center (ASC) alerts must be resolved</b><br />Based on the policies that are
                enabled in the subscription, Azure Security Center raises alerts (which are typically indicative of
                resources that ASC suspects might be under attack or needing immediate attention). It is important that
                these alerts/actions are resolved promptly in order to eliminate the exposure to attacks.</td>
            <td>High</td>
            <td>Yes</td>
            <td>No</td>
        </tr>
        <tr>
            <td>Azure_Subscription_AuthZ_Dont_Add_SPNs_as_Owner<br/><br/><b>Service Principal Names (SPNs) should not be Owners or Contributors on the subscription</b><br />Just
                like AD-based service accounts, SPNs have a single credential and most scenarios that use them cannot
                support multi-factor authentication. As a result, adding SPNs to a subscription in 'Owners' or
                'Contributors' roles is risky.</td>
            <td>Medium</td>
            <td>Yes</td>
            <td>No</td>
        </tr>
        <tr>
            <td>Azure_Subscription_SI_Lock_Critical_Resources<br/><br/><b>Critical application resources should be protected using a resource lock</b><br />A resource lock
                protects a resource from getting accidentally deleted. With proper RBAC configuration, it is possible to
                setup critical resources in a subscription in such a way that people can perform most operations on them
                but cannot delete them. resource locks can help ensure that important data is not lost by
                accidental/malicious deletion of such resources (thus ensuring that availability is not impacted).</td>
            <td>Medium</td>
            <td>Yes</td>
            <td>No</td>
        </tr>
        <tr>
            <td>Azure_Subscription_Config_ARM_Policy<br/><br/><b>ARM policies should be used to audit or deny certain activities in the subscription that can impact
                    security</b><br />The AzSK subscription security setup configures a set of ARM policies which result
                in audit log entries upon actions that violate the policies. (For instance, an audit event is generated
                if someone creates a v1 resource in a subscription.) These policies help by raising visibility to
                potentially insecure actions. </td>
            <td>Medium</td>
            <td>Yes</td>
            <td>Yes</td>
        </tr>
        <tr>
            <td>Azure_Subscription_Audit_Configure_Critical_Alerts<br/><br/><b>Alerts must be configured for critical actions on subscription and resources</b><br />The AzSK
                subscription security setup configures Insights-based alerts for sensitive operations in the
                subscription. These alerts notify the configured security point of contact about various sensitive
                activities on the subscription and its resources (for instance, adding a new member to subscription
                'Owners' group or deleting a firewall setting or creating a new web app deployment, etc.)</td>
            <td>High</td>
            <td>Yes</td>
            <td>Yes</td>
        </tr>
        <tr>
            <td>Azure_Subscription_AuthZ_Custom_RBAC_Roles<br/><br/><b>Do not use custom-defined RBAC roles</b><br />Custom RBAC role definitions are usually tricky to get
                right. A lot of threat modeling goes in when the product team works on and defines the various
                'out-of-box' roles ('Owners', 'Contributors', etc.). As much as possible, teams should use these roles
                for their RBAC needs. Using custom roles is treated as an exception and requires a rigorous review.</td>
            <td>Medium</td>
            <td>Yes</td>
            <td>No</td>
        </tr>
        <tr>
            <td>Azure_Subscription_SI_Classic_Resources<br/><br/><b>Do not use any classic resources on a subscription</b><br />You should use new ARM/v2 resources as
                the ARM model provides several security enhancements such as: stronger access control (RBAC), better
                auditing, ARM-based deployment/governance, access to managed identities, access to key vault for
                secrets, AAD-based authentication, support for tags and resource groups for easier security management,
                etc.</td>
            <td>Medium</td>
            <td>Yes</td>
            <td>No</td>
        </tr>
        <tr>
            <td>Azure_Subscription_SI_Dont_Use_Classic_VMs<br/><br/><b>Do not use any classic virtual machines on your subscription.</b><br />You should use new Az
                resources as the ARM model provides several security enhancements such as: stronger access control
                (RBAC), better auditing, ARM-based deployment/governance, access to managed identities, access to key
                vault for secrets, AAD-based authentication, support for tags and resource groups for easier security
                management, etc.</td>
            <td>High</td>
            <td>Yes</td>
            <td>No</td>
        </tr>
        <tr>
            <td>Azure_Subscription_NetSec_Justify_PublicIPs<br/><br/><b>Verify the list of public IP addresses on your subscription</b><br />Public IPs provide direct access
                over the internet exposing a cloud resource to all type of attacks over the public network. Hence use of
                public IPs should be carefully scrutinized/reviewed.</td>
            <td>High</td>
            <td>Yes</td>
            <td>No</td>
        </tr>
        <tr>
            <td>Azure_Subscription_AuthZ_Dont_Grant_Persistent_Access<br/><br/><b>Enable PIM (Privileged Identity Management) for granting privileged access to subscription level
                    roles.</b><br />PIM (Privileged Identity Management) allows to manage, control, and monitor access
                on your subscription which helps to mitigate the risk of excessive, unnecessary or misused access
                rights.By using PIM, one can ensure that least required access is granted for just enough duration of
                time thereby eliminating risks from persistent privileged role memberships.</td>
            <td>High</td>
            <td>Yes</td>
            <td>No</td>
        </tr>
        <tr>
            <td>Azure_Subscription_AuthZ_Dont_Grant_Persistent_Access_RG<br/><br/><b>Enable PIM (Privileged Identity Management) for granting privileged access to resource group level
                    roles.</b><br />PIM (Privileged Identity Management) allows to manage, control, and monitor access
                on your resource group which helps to mitigate the risk of excessive, unnecessary or misused access
                rights.By using PIM, one can ensure that least required access is granted for just enough duration of
                time thereby eliminating risks from persistent privileged role memberships.<br /><i>Note: This control
                    gets executed only during CA scan.</i></td>
            <td>High</td>
            <td>Yes</td>
            <td>No</td>
        </tr>
        <tr>
            <td>Azure_Subscription_Config_Add_Required_Tags<br/><br><b>Mandatory tags must be set per your organization policy.</b><br />Certain tags are expected to be
                present in all resources to support enterprise wide functions (e.g., security visibility based on
                environment, security scanning, cost optimization, etc.). The script checks for presence of such
                'mandatory' and 'scenario-specific' tags.</td>
            <td>High</td>
            <td>Yes</td>
            <td>No</td>
        </tr>
        <tr>
            <td>Azure_Subscription_Config_ASC_Tier<br/><br/><b>Standard tier must be enabled for Azure Security Center.</b><br />ASC standard tier enables advanced
                threat detection capabilities, which uses built-in behavioral analytics and machine learning to identify
                attacks and zero-day exploits, access and application controls to reduce exposure to network attacks and
                malware, and more.</td>
            <td>High</td>
            <td>Yes</td>
            <td>No</td>
        </tr>
        <tr>
            <td>Azure_Subscription_Check_Credential_Rotation<br/><br/><b>Ensure any credentials approaching expiry are rotated soon.</b><br />Periodic credential rotation is
                a good security hygiene practice as, over time, it minimizes the likelihood of data loss/compromise
                which can arise from key theft/brute forcing/recovery attacks. Credential expiry can also impact
                availability of existing apps.</td>
            <td>High</td>
            <td>Yes</td>
            <td>No</td>
        </tr>
    </table>
    <table>
    </table>
</body>

</html>
