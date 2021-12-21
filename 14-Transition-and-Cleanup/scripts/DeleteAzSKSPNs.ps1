  #List SPNs
  $objectId= (Get-AzureADUser  -Filter "UserPrincipalName eq '$($(Get-AzContext).Account)'").ObjectId
  $spnList = Get-AzureADUserOwnedObject -ObjectId $objectId| Where-Object {($_.ObjectType -eq "ServicePrincipal") -and ($_.DisplayName -clike "AzSK_CA_SPN*")} 
  $spnList
