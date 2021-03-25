## Storage

| ControlId & Description | Used API(s) & Properties | Logic |
|-------------------------|--------------------------|-------|
| Azure_Storage_AuthN_Dont_Allow_Anonymous<br><br><b>Description: </b><br>The Access Type for containers must not be set to 'Anonymous' | <b>ARM API to list Storage Account at subscription level: </b><br>/subscriptions/{subscriptionId}/providers<br>/Microsoft.Storage/storageAccounts?<br>api-version=2019-06-01 <br><br><b>Properties:</b><br>allowBlobPublicAccess, provisioningState, kind | <b>Passed: </b><br>Storage does not have any container with public access.<br><b>Failed: </b><br>Storage has at least one container with public access or provisioning state for storage is not 'Succeeded'.<br><b>Verify: </b><br>Not able to fetch container details for storage.<br><b>NotApplicable: </b><br>Storage is of type FileStorage.(Kind FileStorage does not support containers). |
