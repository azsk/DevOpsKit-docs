```PowerShell
function PrepareTargetSubscriptionForCentralModeCA($SubscriptionId, $Location, $AADAppName)
{
    #Do not change this rgName value unless you have your own AzSK org-specific policy setup
    $rgName = 'AzSKRG'  
    $baseTimeout = 10   
 
    #region Step 1: Set context to target subscription
    Write-Host "Changing current subscription context to [$subscriptionId]..." -ForegroundColor Yellow
    Set-AzureRmContext -Subscription $subscriptionId | Out-Null
    Write-Host "Completed changing subscription context to [$subscriptionId]." -ForegroundColor Green
    #endregion
 
    #region Step 2: Create the AzSK resource group
 
    #check if the resourcegroup exists
    Write-Host "Checking if resource rroup [$rgName] exists in the target subscription..." -ForegroundColor Yellow
    if((Get-AzureRmResourceGroup -Name $rgName -ErrorAction SilentlyContinue | Measure-Object).Count -eq 0)
    {
        Write-Host "Creating new resource group [$rgName]..." -ForegroundColor Yellow
        $newRG = New-AzureRmResourceGroup -Name $rgName -Location $Location -ErrorAction Stop
    }
    $azSKRG = $null;
 
    #wait  untill resourcegroup creation is completed
    $retryCount = 6
    $localTimeout = $baseTimeout;
    while($retryCount -gt 0 -and $null -eq $azSKRG)
    {
        $azSKRG = Get-AzureRmResourceGroup -Name $rgName -ErrorAction SilentlyContinue;
        if($null -eq $azSKRG)
        {
            Write-Host "Waiting...sleep interval: [$localTimeout] RetryCount: [$retryCount]"
            Start-Sleep -Seconds $localTimeout
            $localTimeout += 10
            $retryCount--;
        }
    }
    Write-Host "Completed creating resource group [$rgName]" -ForegroundColor Green
    #endregion
 
    #region Step 3: Register for Storage Resource provider
 
    $provideNamespace = "Microsoft.Storage";
    Write-Host "Checking if resource provider [$provideNamespace] is registered..." -ForegroundColor Yellow
    $isRegistered = $false
    if((Get-AzureRmResourceProvider -ProviderNamespace $provideNamespace | Where-Object { $_.RegistrationState -ne "Registered" } | Measure-Object).Count -eq 0)
    {
        $isRegistered = $true;
        Write-Host "Resource provider [$provideNamespace] is already registered" -ForegroundColor Green
    }
 
    if(-not $isRegistered)
    {
        Register-AzureRmResourceProvider -ProviderNamespace $provideNamespace
        $retryCount = 10;
        $localTimeout = $baseTimeout;
        while($retryCount -ne 0 -and -not $isRegistered)
        {
            $isRegistered = ((Get-AzureRmResourceProvider -ProviderNamespace $provideNamespace | Where-Object { $_.RegistrationState -ne "Registered" } | Measure-Object).Count -eq 0);
            if(-not $isRegistered)
            {
                Write-Host "Waiting...Sleeping Interval: [$localTimeout] RetryCount: [$retryCount]"
                   Start-Sleep -Seconds $localTimeout
                   $retryCount--;     
                $localTimeout += 5
            }    
        }
        Write-Host "Completed registereing resource provider [$provideNamespace]" -ForegroundColor Green
    }
    #endregion
 
    #region Step 4: Create AzSK storage account
    $storageAccountPreName = 'azsk';
    $storageResourceType = "Microsoft.Storage/storageAccounts"
    $storageType = 'Standard_LRS';
    Write-Host "Checking if AzSK storage account is present..." -ForegroundColor Yellow
    #check if storage account is present
    $storageAccount = Find-AzureRmResource -ResourceGroupNameEquals $rgName `
                  -ResourceNameContains $storageAccountPreName `
                  -ResourceType $storageResourceType `
                  -ErrorAction Stop
    $isStoragePreset = (($storageAccount | Where-Object{$_.ResourceName -match '^azsk\d{14}$'} | Measure-Object).Count -ne 0)
    if(-not $isStoragePreset)
    {
        $storageAccountName = ($storageAccountPreName + (Get-Date).ToUniversalTime().ToString("yyyyMMddHHmmss")); 
        $newStorage = New-AzureRmStorageAccount -ResourceGroupName $rgName `
                        -Name $storageAccountName `
                        -Type $storageType `
                        -Location $Location `
                        -Kind BlobStorage `
                        -AccessTier Cool `
                        -EnableEncryptionService "Blob,File" `
                        -EnableHttpsTrafficOnly $true `
                        -ErrorAction Stop
 
        $retryAccount = 6
        $localTimeout = $baseTimeout;
        while($null -ne $storageObject -and $retryAccount -gt 0)
        {
            $storageObject = Get-AzureRmStorageAccount -ResourceGroupName 'AzSKRG' -Name $storageAccountName -ErrorAction SilentlyContinue
            if($null -ne $storageObject)
            {
                Write-Host "Waiting...sleep interval: [$localTimeout] RetryCount: [$retryCount]"
                Start-Sleep -seconds $localTimeout
                $localTimeout += 5;
                $retryAccount++;
            }
        }
 
        #the below settings are required to create compliant AzSK storage
        if ($storageObject) {
            $currentContext = $storageObject.Context
            Set-AzureStorageServiceLoggingProperty -ServiceType Blob -LoggingOperations All -Context $currentContext -RetentionDays 365 -PassThru -ErrorAction Stop
            Set-AzureStorageServiceMetricsProperty -MetricsType Hour -ServiceType Blob -Context $currentContext -MetricsLevel ServiceAndApi -RetentionDays 365 -PassThru -ErrorAction Stop
        }
        Write-Host "Created a new AzSK storage account [$storageAccountName]" -ForegroundColor Green
    }
    else
    {
        Write-Host "AzSK storage account is already present" -ForegroundColor Green
    }
    #endregion
 
    #region Step 5: Grant required permissions on target sub and AzSK RG
    Write-Host "Setting up permissions for AzSK CA SPN [$AADAppName]..." -ForegroundColor Yellow
    $ADApplication = Get-AzureRmADApplication -DisplayNameStartWith $AADAppName | Where-Object -Property DisplayName -eq $AADAppName
    if(($ADApplication | Measure-Object).Count -le 0)
    {
        throw "AADApplication [$AADAppName] not found. You must specify an existing app name for which you are Owner."
    }
 
    $haveRGAccess = $false;
    $haveSubAccess = $false;
    $spPermissions = Get-AzureRmRoleAssignment -serviceprincipalname $ADApplication.ApplicationId
    if(($spPermissions|Measure-Object).count -gt 0)
    {
           $haveRGAccess = ($spPermissions | Where-Object {$_.scope -eq (Get-AzureRmResourceGroup -Name $rgName).ResourceId -and $_.RoleDefinitionName -eq "Contributor" }|measure-object).count -gt 0
           $haveSubAccess = ($spPermissions | Where-Object {$_.scope -eq "/subscriptions/$subscriptionId" -and $_.RoleDefinitionName -eq "Reader"}|Measure-Object).count -gt 0
    }
 
    if(-not $haveRGAccess)
    {
           New-AzureRMRoleAssignment -Scope $azSKRG.ResourceId -RoleDefinitionName Contributor -ServicePrincipalName $ADApplication.ApplicationId -ErrorAction SilentlyContinue | Out-Null
        Write-Host "Completed granting access to AzSK CA SPN on ResourceGroup [$rgName]" -ForegroundColor Green
    }
    else
    {
        Write-Host "AzSK CA SPN already have required access on ResourceGroup [$rgName]" -ForegroundColor Green
    }
    if(-not $haveRGAccess)
    {
           New-AzureRMRoleAssignment -RoleDefinitionName Reader -ServicePrincipalName $ADApplication.ApplicationId -ErrorAction SilentlyContinue | Out-Null
        Write-Host "Completed granting access to AzSK CA SPN on Subscription" -ForegroundColor Green
    }
    else
    {
        Write-Host "AzSK CA SPN already have required access on Subscription" -ForegroundColor Green
    }
    #endregion 
}


#This is the SPN that got created when you setup CA in the central (host) 
#subscription in central scan mode. You can get it by calling 'Get-AzSKContinuousAssurance'
#for that subscription (or from the CA log).
$azskSPN = '<AzSK_CA_SPN_from_host_sub>' #'AzSK_CA_SPN_xxxx'

#The resource group and storage account will be created at this location.
#Choose the location where your host subscription's 'AzSKRG' is setup.
$loc = '<AzSKRG_location_from_host_sub>' #'eastus2'

#This is the target subscription. Each target sub should be similarly 'prepped' 
$subId = "<target_sub_id>"
PrepareTargetSubscriptionForCentralModeCA -SubscriptionId $subId -Location $loc -AADAppName $azskSPN 

```
