## SubscriptionCore

| Control Id | Description | API & Property | Logic |
|------------|-------------------------|----------------|-------|
| Azure_Subscription_AuthZ_Remove_Deprecated_Accounts | Deprecated/stale accounts must not be present on the subscription | <b>API:</b><br>/subscriptions/{subscriptionId}/resourceGroups/<br>{resourceGroupName}/providers/Microsoft.Compute<br>/virtualMachines/{vmName}/extensions?api-version=2019-07-01<br><br><b>Property:</b><br>properties/publisher<br>properties/type<br>| <b>Passed: </b><br>All required extensions are present in VM<br><b>Failed: </b><br>One or more required extensions are missing in VM.<br><b>NotApplicable: </b><br>VM is part of ADB cluster.<br><b>Not Scanned: </b><br>VM OS type is null or empty. |