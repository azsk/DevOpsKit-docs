## Externally Scanned controls in Azure Tenant Security (AzTS)

There are certain controls that can not be effectively evaluated by AzTS (due to various limitations for e.g. some controls requires VM to be in running state) for such controls AzTS will put verification result as 'ExtScanned'. And effective verification result of such controls will be determined based on external feeds (if available). 

In AzTS UI, Controls with verification result 'ExtScanned' are excluded from compliance.

### List of externally scanned controls

Following controls in AzTS are currently externally scanned:

| ControlId | DisplayName | Description |
|-----------|-------------|-------------|
| Azure_VirtualMachineScaleSet_SI_Missing_OS_Patches|System updates on virtual machine scale sets must be installed.|Virtual Machine Scale Set must have all the required OS patches installed.|
