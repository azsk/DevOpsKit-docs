
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
