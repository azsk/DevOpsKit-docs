## Storage

| Control Id | Description | API & Property | Logic |
|------------|-------------------------|----------------|-------|
| Azure_Storage_AuthN_Dont_Allow_Anonymous | The Access Type for containers must not be set to 'Anonymous' | <b>Used ARM API(s):</b><br>/subscriptions/{subscriptionId}/providers<br>/Microsoft.Storage/storageAccounts?<br>api-version=2019-06-01 <br><br><b>Used Property:</b><br>allowBlobPublicAccess, provisioningState, kind | <b>Passed: </b><br>Storage does not have any container with public access.<br><b>Failed: </b><br>Storage has at least one container with public access. |
