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

    hidden [ControlResult] CheckStorageEncryptionInTransitExt([ControlResult] $controlResult)
     {
        $stgAcctName = $this.ResourceContext.ResourceName
		# Call the default implementation to get the actual status.
		$controlResult = $this.CheckStorageEncryptionInTransit($controlResult)
		$exemptedRegion = $($this.ControlSettings.Storage.HttpsExemptedRegion)
		$encryptionEnabled = ($controlResult.VerificationResult -eq [VerificationResult]::Passed)
		# 'Exempt' the account if it belongs to the exempted region...
		if($this.ResourceObject.Location -eq $exemptedRegion)
		{
			$controlResult.AddMessage("Note: Storage account [$stgAcctName] has EnableHttps set to: $encryptionEnabled.`nAccounts in the region [$exemptedRegion] are not required to enable encryption. Control result overridden as [Passed]");
			$controlResult.VerificationResult = [VerificationResult]::Passed
		} 
		else
		{
			$controlResult.AddMessage("Note: Storage account [$stgAcctName] has EnableHttps set to: $encryptionEnabled.`nThis account is not in the exempted region [$exemptedRegion]. Default AzSK control result applies to it!");
		}
 		return $controlResult;  
     }
}
