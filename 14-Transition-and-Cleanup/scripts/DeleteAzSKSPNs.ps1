function Read_UserChoice
{
    $userSelection = ""
    while($userSelection -ne 'Y' -and $userSelection -ne 'N')
    {
        $userSelection = Read-Host "User choice"
        if(-not [string]::IsNullOrWhiteSpace($userSelection))
		{
			$userSelection = $userSelection.Trim();
		}
    }

    return $userSelection;
}
  function Delete_AADApplication
{
    param ($AadAppId)

    Write-Host "Deleting AAD application of AzSK CA SPN $($AadAppId).Do You want to continue?`n[Y]: Yes`n[N]: No"
    $userChoice = Read_UserChoice 
    if($userChoice -eq 'Y')
    {
       try{
            $success = Remove-AzADApplication -ApplicationId $AadAppId -Force
            # Added this check as remove-azadapplication not returing success true/false properly
            $appStillExist = Get-AzADApplication -ApplicationId $AadAppId -ErrorAction SilentlyContinue
            if($appStillExist)
            {
                throw;
            }
            Write-Host "Successfully deleted AAD application of AzSK CA SPN $($AadAppId)" -ForegroundColor Green
        }
        catch{
            Write-Host "Error while deleting AAD application of AzSK CA SPN." -ForegroundColor DarkYellow
        }

    }
}
Function Remove-AzSKSPN
{
  Connect-AzureAD
  Connect-AzAccount
  #List SPNs
  $objectId= (Get-AzureADUser  -Filter "UserPrincipalName eq '$($(Get-AzContext).Account)'").ObjectId
  $spnList = Get-AzureADUserOwnedObject -ObjectId $objectId| Where-Object {($_.ObjectType -eq "ServicePrincipal") -and ($_.DisplayName -clike "AzSK_CA_SPN*")} 
  Write-Host("`nList of SPNs for which current logged in user is Owner`n")
  $spnList|Select-Object "DisplayName", "ObjectId", "AppId" | Format-Table
  foreach($spn in $spnList)
  {
    $appId= Get-AzADApplication -ApplicationId $spn.AppId
    Delete_AADApplication($spn.AppId)
  }
}
  
