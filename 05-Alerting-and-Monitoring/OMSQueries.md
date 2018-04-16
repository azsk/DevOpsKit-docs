## OMS Helper Queries

### Contents
- [Overview](OMSQueries.md#overview)
- [Local effective scan result](OMSQueries.md#Local-effective-scan-result)
- [Services scan result for baseline controls](OMSQueries.md#services-scan-result-for-baseline-controls)

--------------------------
### Overview: 
To help team visualize the scan results effectively we have added properties in OMS data objects. 
This will help to filter scan results based on latest module version/access/expiry/baseline etc.


--------------------------
### Local effective scan result

You can validate your local scan with below query by adding Runidentifier (Runidentifier is nothing but the folder name where local scan resides e.g. "20180112_111359_GRS")

``` AIQL
AzSK_CL
| where HasAttestationReadPermissions_b == true and HasRequiredAccess_b == true and IsLatestPSModule_b == true and RunIdentifier_s == "<RunIdentifier>"
```

--------------------------
### Services scan result for baseline controls: 
Following query will help you to check effective scan result for baseline controls

``` AIQL
let passStatuslist = AzSK_MetaData_CL
| summarize arg_max(TimeGenerated, *)
| project parsejson(TreatAsPassedStatuses_s);
let baseControlList = AzSK_Inventory_CL
| summarize RunIdentifier_s=max(RunIdentifier_s) by SubscriptionId
| join kind= inner
(
    AzSK_Inventory_CL
    | where  IsBaselineControl_b == true
)
on RunIdentifier_s;
let elevatedAccessControlStatus = AzSK_CL
| where TimeGenerated > ago(90d) and HasAttestationReadPermissions_b == true and HasRequiredAccess_b == true and IsLatestPSModule_b == true and IsBaselineControl_b == true  and Tags_s contains "OwnerAccess"
| summarize arg_max(TimeGenerated,ControlStatus_s) by SubscriptionId,ResourceId,ChildResourceName_s,ControlId_s;
let readerAccessControlStatus= AzSK_CL
| where TimeGenerated > ago(3d) and HasAttestationReadPermissions_b == true and HasRequiredAccess_b == true and IsLatestPSModule_b == true and IsBaselineControl_b == true and Tags_s !contains "OwnerAccess"
| summarize arg_max(TimeGenerated,ControlStatus_s) by SubscriptionId,ResourceId,ChildResourceName_s,ControlId_s;
let result = baseControlList
| join kind=leftouter
(
    elevatedAccessControlStatus
    | union readerAccessControlStatus
)
on SubscriptionId,ResourceId,ControlId_s;
result
| project SubscriptionId,FeatureName_s,ResourceGroupName_s,ResourceName_s,ControlId_s,ControlStatus_s
| extend  FinalStatus=iff(ControlStatus_s !in (passStatuslist),"Failed","Passed")
| summarize StatusCount=count() by FinalStatus, SubscriptionId
```




