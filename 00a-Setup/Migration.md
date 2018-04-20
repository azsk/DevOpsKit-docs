## Migrating from 'AzSDK' to 'AzSK'

<h4><font color="blue">IMPORTANT:</font></h4> 

> 1) If you are from Microsoft CSE&O, please use the steps [here](https://aka.ms/devopskit/migration). 
> <u>**Do not**</u> use the migration instructions on this page. These are for non-MS consumers of the DevOps Kit. 
> 2) If you are external to Microsoft, then the steps required to migrate to AzSK depend upon whether subscriptions in your org are running with the generic (org-neutral) policy or you have setup a custom AzSDK policy for your organization using the  [`Install-AzSDKOrganizationPolicy`](https://github.com/azsdk/azsdk-docs/tree/master/07-Customizing-AzSDK-for-your-Org) command. 
>  These two steps are described below. The first step guides you for migrating org policy and the second step guides individual subscription owners for migrating from 'AzSDK' to 'AzSK'. 

### Step-1: Migrating Org Policy:
> **Note:** Step-1 is required only if you have [custom org policy](../07-Customizing-AzSK-for-your-Org/Readme.md) setup (as mentioned above). If not, then directly go to Step-2 further below. 
> 
> Also, if your org policy setup is basic/trivial to replicate, you might consider recreating a fresh setup using the Install-AzSKOrganizationPolicy cmdlet. In either case, individual subscription owners in your org should not migrate their subscriptions before org policy has been migrated. (That is, only after you have completed Step-1 should individual subscription owners complete Step-2.)
>
> If you would like to understand how policy and subscription migration works under the hood, please review the policy migration question in the FAQ below.


[Pre-Requisite: You must be an **Owner** for the subscription where your org policy is hosted.)

 0) Close all PS sessions. 

 1) Open a *fresh* PS session and install the latest DevOps Kit release by running the command below: (This will get 
 the new 'AzSK' module onto your machine.)

	```PowerShell
	install-module AzSK -Scope CurrentUser -AllowClobber
	```

 2) Close the installation session, open a *fresh* PS session again and run the following commands: (This will migrate org-policy and create new resources as per 'AzSK' module.)

	The OrgName and DepartmentName values in the command below should be the same ones you used when setting up org policy using AzSDK earlier.

	```PowerShell
	import-module AzSK	
	Update-AzSKOrganizationPolicy -SubscriptionId <sub_id> -OrgName <org_name> -DepartmentName <department_name> -Migrate
	```

	**Note:** 
	- If you have made any changes/customizations to `AzSDK-EasyInstaller.ps1` or `RunbookScanAgent.ps1` (e.g., if you changed the default flags used while running CA scan commands) then you should re-apply those to the newly generated `AzSK-EasyInstaller.ps1` and `RunbookScanAgent.ps1` respectively.
	- If you are using baseline control feature, you should should add -UseBaselineControls flag for commands Get-AzSKAzureServicesSecurityStatus and Get-AzSKSubscriptionSecurityStatus in `RunbookScanAgent.ps1` file.

 
At this point, policy migration is complete. However, we will do some additional verifications to ensure that it worked successfully before notifying individual subscription owners to migrate.

3) Run the newly generated **"iwr"** command which was displayed in the output of the migration command above. (This is basically the *new* installation command for your org created using AzSK-based policy containers.)

	```PowerShell
	# Note: replace the 'iwr' line below with the post-migrate 'iwr' for your org as output by the previous step
	iwr 'https://azsk............/AzSK-EasyInstaller.ps1' -UseBasicParsing | iex
	```
	
 4) Now start another *fresh* PS session and verify if the newly setup policy settings are in effect. You can do so by running AzSK scan commands such as GSS (Get-Az**SK**SubscriptionSecurityStatus) or GRS (Get-Az**SK**AzureServicesSecurityStatus) for any of your subscriptions. (If you have configured a custom controls baseline, you can also specify '-UseBaselineControls' flag to validate that your org-specific baseline is honored by the scan commands post-migration.)  

 5) You can now communicate the newly generated **"iwr"** to your subscription owners/end users so that they can install the new Az**SK** module using the latest (migrated) org policy. After installing using the new **"iwr"** all subscription owners can migrate their subscriptions to "AzSK" using instructions from Step-2 below. 

**Notes:** 
 - Your old (AzSDK-based) org policy will be retained under the old "AzSDK-[OrgName]-[DeptName]-RG" resource group inside your policy host subscription. You can delete this RG after ensuring that migration has worked as expected for both the policy and individual subscriptions across your org. 
 
 - If you had enabled 'baseline scanning' via the "SupportedSources = "CC"" setting in ControlSettings.json, that approach has been deprecated. Please use the "-UseBaselineControls" switch directly in the command invocation inside you RunbookScanAgent.PS1.
 
 - If you had made changes to CosmosDB settings and had an entry for 'cosmosdb.json' in your ServerConfigMetadata.json file, you may have to rename the file to 'CosmosDB.json' and re-upload it.
 
 - Please review different configuration capabilities available for org policy control in the org policy section [here](../07-Customizing-AzSK-for-your-Org/Readme.md#basic-files-setup-during-policy-setup).

<br>

### Step-2: Migrating individual subscriptions:
The steps below will help you to migrate your subscription from 'AzSDK' to 'AzSK'. 

[Pre-requisite: You should be an **Owner** for the subscription being migrated.]

 0) Close all PS sessions. 

 1) Open a *fresh* PS session and install the latest release by running **one** of the 2 commands below (this will get 
 the new 'AzSK' module onto your machine):

	```PowerShell
	# Run this command if you do not have org-policy setup
	install-module AzSK -Scope CurrentUser -AllowClobber
	
	# Run this command if your organization has custom org-policy setup. (The exact command in this case will be provided by your organization's cloud security team.)
	iwr 'https://azsk............/AzSK-EasyInstaller.ps1' -UseBasicParsing | iex
	```
 2) Close the installation session, open a *fresh* PS session again and run the following:

	```PowerShell
	import-module AzSK
	Update-AzSKSubscriptionSecurity -SubscriptionId <sub_id> -Migrate
	```

This will make all changes necessary in your subscription in order to start using the new ('AzSK') module. 
If any of the individual steps fail, you can retry migration simply by re-running the 'migrate' command 
as per (2) above.

For other questions related to migration (e.g., *Why are we migrating? What happens behind the scenes during 
migration? What about CICD?* etc., please see the FAQ at the end of this page. 

**Note:** Until a subscription is migrated, you may be able to use the 'AzSDK' module and corresponding 'AzSDK' 
versions of cmdlets as earlier. 
However, after a subscription has been migrated, new 'AzSK' versions of the cmdlets 
from the new module should only be used. If you are using generic org-policy (i.e., you do not have a custom org policy and an "iwr-based" setup), you may need to explicitly uninstall the old (AzSDK) module using `uninstall-module AzSDK -Force` from a fresh PS console after closing other existing PS sessions.

The logs generated by locally run scan commands from the new module will appear 
under the `'%localappdata%\Microsoft\AzSKLogs'` folder.


#### FAQ: 

##### Why are we migrating from AzSDK to AzSK?
We received feedback from various forums that the 'SDK' in the module name was misleading because 'SDK' is
traditionally used for 'Software Development Kit'. Secondly, some folks were also confusing 'AzSDK' and 'Azure SDK'
using the two interchangeably. 


##### What exactly happens during migration?
The migration process basically prepares your local machine and your subscription to start using the new
'AzSK' PS module. Depending on the subscription security features from the DevOps Kit you have setup on your 
subscription, the following steps happen during migration:

 - The old resource group ('AzSDKRG') will be retained for certain duration and locked for any modifications post migration
 - Attestation data/ Resource groups tags are auto migrated to the new resource group ('AzSKRG')
 - Attestation data is still retained in the old storage account as backup
 - Previously setup alerts, ARM policies and Continuous Assurance Automation Account will get deleted 
 and corresponding new resources will get created under AzSK RG.

If you created any other resources under the (old) DevOps Kit resource group ('AzSDKRG') you may need to migrate 
them yourselves.

##### How will the old cmdlets (from the old 'AzSDK' module) behave? 
If you have not yet migrated, all AzSDK cmdlets (Get-AzSDKxxx or Set-AzSDKxxx) will work as usual. The latest
version of AzSDK (2.11.x) will show warnings about migration.

Once you migrate your subscription, most cmdlets from AzSDK 2.11.x will report errors telling you to use 
cmdlets from the 'AzSK' module.

##### Can I use the new 'AzSK' module if I have not migrated?
Some commands (which are 'read only' in behavior) will work. However, others (e.g., attestation or Set-AzSKSubscriptionSecurity)
will be blocked. This is to not create conflicts with 'AzSDK-based' state in the subscription.

##### How will Continuous Assurance transition through migration?
If you have not yet migrated, the current AzSDK setup will seamlessly transition by updating the AzSDK module
to the latest AzSDK (version 2.11.x). Thus existing CA setups will not get impacted (scanning will continue as earlier).

Once you migrate, the migration process will create a new CA setup in the subscription using the same settings
that were provided when CA was setup originally. The new CA setup will be 'AzSK'-based and will import the 'AzSK'
module into the automation account. Thereafter, CA scanning will use 'AzSK' and will update to newer releases of 
'AzSK' module whenever they become available.

##### What about CICD extension?
The CICD extension has been revised to reflect the switch from 'AzSDK' to 'AzSK'. 
The previous extension will continue to work in the pipeline. Once a subscription has been migrated, you should
just go to the extension UI and select the newest version. 

If you have setup CICD in non-hosted mode, you may have to manually remove the older module as an additional step.

##### Are my old CA scan logs retained after migration?
Yes. We retain the old CA logs in the (old) storage account within 'AzSDKRG'. The migration process places a 'read'
lock on 'AzSDKRG'. Because of this, you may not be able to migrate to the storage account's blobs and view the logs.
Should you need to view any of the old logs, you can go to the 'AzSDK' resource group and view 'Locks' for it. 
Change the lock type from 'read-only' to 'delete' temporarily and download/view and logs you wish to. However, as soon 
as you can, please change the lock type back to 'read only'. This lock required so that other users using older 'AzSDK'
modules (prior to AzSDK 2.11.x) should not be able to write to the old RG once migration has been performed. 

##### What happens during 'org policy' migration? 
(This applies only if you have custom org policy setup.)

If you setup custom org policy using the Install-AzSDKOrganizationPolicy cmdlet in the past, you perhaps know that your customized org policy is hosted in your (master) subscription within a resource group named after your org and department name. Individual subscription owners across your org setup the DevOps Kit using an **"iwr"**-based installer that is customized for your org. This ensures that all users in the org run the DevOps Kit cmdlets using policy from a central policy store that is owned and managed by you.

In order to migrate policy, as the owner of the policy host subscription, you need to run the policy migration command. Behind the scenes, the policy migration occurs using the following steps:

  a) The migration command first downloads all artifacts from the current policy store onto a folder on your desktop with the name 'AzSK-[OrgName]-[DeptName]-Policy'. 

  b) It then creates new resources with 'AzSK'-based names in the policy host subscription
  
  c) Finally, the old policy JSONs and other files are fetched from the local copy (on the desktop) and uploaded to the new policy location.

  d) A new **"iwr"** command is generated for use by subscription owners to install 'AzSK' with policy URL pointing to the new location. 
