using namespace Microsoft.Azure.Management.Storage.Models
using namespace Microsoft.WindowsAzure.Storage.Shared.Protocol
Set-StrictMode -Version Latest 
class StorageExt: Storage
{       

    StorageExt([string] $subscriptionId, [string] $resourceGroupName, [string] $resourceName): 
                 Base($subscriptionId, $resourceGroupName, $resourceName) 
    { 
    }

    StorageExt([string] $subscriptionId, [SVTResource] $svtResource): 
        Base($subscriptionId, $svtResource) 
    { 
    }

   
     hidden [ControlResult] CheckStorageInApprovedRegions([ControlResult] $controlResult)
     {
		$reqdRegion = $($this.ControlSettings.Storage.RequiredRegion)
		$stgAcctName = $this.ResourceContext.ResourceName

		 if($this.ResourceObject.Location -eq $reqdRegion)
		 {
			
			$controlResult.VerificationResult = [VerificationResult]::Passed
		}
		else
		{
			$controlResult.AddMessage("Note: Storage account [$stgAcctName] is not in the org-required region [$reqdRegion].")
			$controlResult.VerificationResult = [VerificationResult]::Failed
		}
		 
 		return $controlResult;  
     }
}
