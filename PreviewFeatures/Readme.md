# Preview Features

### Configure new runtime account in CA
Now you can configure new runtime account by running UCA (Update-AzSKContinuousAssurance) command with switch "-NewRuntimeAccount". 
This feature is helpful in case when CA certificate is expired but the SPN owner who had setup CA is not available, due to that certificate can't be renewed. This command will setup new runtime account and the person running the command will become new SPN owner.

### User Comments/Custom Tags

To track compliance progress on your subscription you can place 'custom tags/comments' on controls, these comments will be persisted inside your subscription's AzSK storage account. Anyone across your subscription can read the comments later by running GSS/GRS/GCS command with switch "-IncludeUserComments". 

> **Note:** You need to explicitly enable this feature for your subscription. To do so, Please run following command:
>```PowerShell
>    Set-AzSKUserPreference -PersistScanReportInSubscription
>```
	
#### How to add/update user comments?

Please follow the following steps to update user comments:

Step 1: Run GRS/GSS/GCS cmd with “-IncludeUserComments” switch. For e.g.
```PowerShell
      Get-AzSKAzureServicesSecurityStatus -SubscriptionId <Your SubscriptionId> -IncludeUserComments
```

In the .CSV file that is generated, there will be an extra column “UserComments” which will contain custom comments provided by users.

Step 2: Edit/Update “UserComments” column and save file.	

Step 3: Upload edited .CSV file using below cmdlt,
```PowerShell
      Update-AzSKPersistedState -SubscriptionId  <Your SubscriptionId> -FilePath <Path for updated CSV file> -StateType "UserComments"
```    
#### How to read user comments?

To read user comments on any controls you just need to run GCS/GSS/GRS cmd  with an extra switch "-IncludeUserComments". Once a scan completes the .CSV file will contain "UserComments" column which will show comments/custom tags.

![08_Info_UserComments_PS](../Images/08_Info_UserComments_PS.JPG)  


### Attestation Workflow Changes
* Two new attestation state are introduced to split "NotAnIssue" (which had an overloaded meaning earlier) into the following 3 possible states:
	* (Genuine) NotAnIssue -- to represent situations where the control is implemented in another way, so the finding does not apply.
	* StateConfirmed -- to represent acknowledgment by a user that the control state (e.g., IP addressed ranges on a firewall) is correct/appropriate
	* NotApplicable -- the control is not applicable for the given design/context (e.g., a storage container that is public access ‘by design’)

* Change in expiry of attestation for controls:
	
	* NotAnIssue and NotApplicable attestation states will expire in 90 days from the attested date
	* StateConfirmed,WillFixLater,WillNotFix will expire based on the control severity if the controls are in grace period.
	* Post grace period expiry any control attested with WillFixLater would expire and will result in actual verification state 
	  and 'WillFixLater' will not be available as an attestation option for the control.




