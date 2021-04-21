## Externally Scanned controls in Azure Tenant Security (AzTS)

There are certain controls that can not be effectively evaluated by AzTS (due to various limitations for e.g. some controls requires VMSS instances to be in running state) for such controls AzTS will put verification result as 'ExtScanned'. And effective verification result of such controls should be determined based on external feeds later (if available). 

As verification result for such controls depends on other sources and get determined outside AzTS boundary. So, in AzTS UI, controls with verification result 'ExtScanned' are excluded from compliance. By default such controls will not be listed in scan results view however user can use filter ('AzTS-based controls only') provided in AzTS UI to list these controls.

### List of externally scanned controls

Following controls in AzTS are currently externally scanned:

| ControlId | DisplayName | Description |
|-----------|-------------|-------------|
| Azure_VirtualMachineScaleSet_SI_Missing_OS_Patches|System updates on virtual machine scale sets must be installed.|Virtual Machine Scale Set must have all the required OS patches installed.|
