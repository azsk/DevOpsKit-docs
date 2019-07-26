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

		 if($this.ResourceObject.Location -eq 'eastus2')
		 {

			$controlResult.VerificationResult = [VerificationResult]::Passed
		}
		else
		{
			$controlResult.EnableFixControl = $true;
			$controlResult.VerificationResult = [VerificationResult]::Failed
		}
		 
 		return $controlResult;  
     }

}
