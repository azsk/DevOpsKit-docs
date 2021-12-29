
function Pre_requisites {
    <#
    .SYNOPSIS
    This function would check pre requisities modules.
    .DESCRIPTION
    This function would check pre requisities modules to perform clean-up.
	#>

    Write-Host "Required modules are: Az.Resources, Az.Accounts" -ForegroundColor Cyan
    Write-Host "Checking for required modules..."
    $availableModules = $(Get-Module -ListAvailable Az.Resources, Az.Accounts)
    
    # Checking if 'Az.Accounts' module is available or not.
    if ($availableModules.Name -notcontains 'Az.Accounts') {
        Write-Host "Installing module Az.Accounts..." -ForegroundColor Yellow
        Install-Module -Name Az.Accounts -Scope CurrentUser -Repository 'PSGallery'
    }
    else {
        Write-Host "Az.Accounts module is available." -ForegroundColor Green
    }

    # Checking if 'Az.Resources' module is available or not.
    if ($availableModules.Name -notcontains 'Az.Resources') {
        Write-Host "Installing module Az.Resources..." -ForegroundColor Yellow
        Install-Module -Name Az.Resources -Scope CurrentUser -Repository 'PSGallery'
    }
    else {
        Write-Host "Az.Resources module is available." -ForegroundColor Green
    }
}

function Read_UserChoice {
    #This function would read user input and return trimmed value
    $userSelection = ""
    while ($userSelection -ne 'Y' -and $userSelection -ne 'N') {
        $userSelection = Read-Host "User choice"
        if (-not [string]::IsNullOrWhiteSpace($userSelection)) {
            $userSelection = $userSelection.Trim();
        }
    }
    return $userSelection;
}


function Remove-AzSKResourceGroups {
    <#
    .SYNOPSIS
    This command would help in deleting the AzSK deployed Azure resources in subscription.
    .DESCRIPTION
    This command will list all resources deployed in AzSKRG nd AzSDKRG and divide them in two list a). AzSK deployed resources b). Non-AzSK deployed resources and will provide option to delete RG
    .PARAMETER SubscriptionId
        Enter subscription id of the subscription for which clean-up need to be performed.
    .PARAMETER PerformPreReqCheck
        Perform pre requisities check to ensure all required module to perform clean-up operation is available.
    .PARAMETER Force
        Switch to force deletion of AzSK resources without further user consent.
    #>
    param (
        [string]
        [Parameter(Mandatory = $true, HelpMessage = "Enter subscription id to delete resource groups for AzSK related resources: ")]
        $SubscriptionId,
        [Parameter(Mandatory = $false, HelpMessage = "Use this switch to avoid user confimration before deletion of resource groups")]
        [switch]
        $Force
    )

    Write-Host "======================================================"

    try {
        Write-Host "Checking for pre-requisites..."
        Pre_requisites
        Write-Host "------------------------------------------------------"     
    }
    catch {
        Write-Host "Error occured while checking pre-requisites. ErrorMessage [$($_)]" -ForegroundColor Red    
        break
    }
    

    # Connect to AzAccount
    $isContextSet = Get-AzContext
    if ([string]::IsNullOrEmpty($isContextSet)) {       
        Write-Host "Connecting to AzAccount..."
        Connect-AzAccount
        Write-Host "Connected to AzAccount" -ForegroundColor Green
    }

    # Setting context for current subscription.
    $currentSub = Set-AzContext -SubscriptionId $SubscriptionId -ErrorAction Stop -Force

    Write-Host "Metadata Details: `n SubscriptionId: [$($SubscriptionId)] `n AccountName: [$($currentSub.Account.Id)] `n AccountType: [$($currentSub.Account.Type)]"
    Write-Host "------------------------------------------------------"
    Write-Host "Starting with Subscription [$($SubscriptionId)]..."


    Write-Host "`nStep 1: Validating whether the current user [$($currentSub.Account.Id)] have the required permissions to run the script for Subscription [$($SubscriptionId)]..."

    # Safe Check: Checking whether the current account is of type User
    if ($currentSub.Account.Type -ne "User") {
        Write-Host "WARNING: This script can only be run by user account type." -ForegroundColor Yellow
        break;
    }

    # Safe Check: Current user need to have Owner role for the subscription
    $currentLoginRoleAssignments = Get-AzRoleAssignment -SignInName $currentSub.Account.Id -Scope "/subscriptions/$($SubscriptionId)" -IncludeClassicAdministrators;

    if (($currentLoginRoleAssignments | Where-Object { $_.RoleDefinitionName -eq "Owner" -or $_.RoleDefinitionName -match 'CoAdministrator' -or $_.RoleDefinitionName -like '*ServiceAdministrator*' } | Measure-Object).Count -le 0) {
        Write-Host "WARNING: This script can only be run by an Owner of subscription [$($SubscriptionId)] " -ForegroundColor Yellow
        break;
    }
    else {
        Write-Host "User has all required permissions." -ForegroundColor Green
    }

    # Declaring all AzSK resources name/pattern
    $azskRGName = "AzSKRG"
    $azsdkRGName = "AzSDKRG"
    
    Write-Host "`nStep 2: Listing AzSK related resource groups in Subscription [$($SubscriptionId)]..."

    # Get AzSK RG
    $azskRG = Get-AzResourceGroup $azskRGName -ErrorAction SilentlyContinue

    if (-not $azskRG) {
        Write-Host "$($azskRGName) is not present in subscription [$($SubscriptionId)]" -ForegroundColor Green
    }
    # Get AzSDK RG 
    $azsdkRG = Get-AzResourceGroup $azsdkRGName -ErrorAction SilentlyContinue

    if (-not $azsdkRG) {
        Write-Host "$($azsdkRGName) is not present in subscription [$($SubscriptionId)]" -ForegroundColor Green
   
    }
    #No resource groups found to be cleaned up
    if (-not $azsdkRG -and -not $azskRG) { 
        Write-Host "No resource groups found to be deleted." -ForegroundColor Red
        return
    }
    if ($azskRG) {
        RemoveAzSKRG 
    }
    if ($azsdkRG) {
        RemoveAzSDKRG
    }
    #End block
}

Function RemoveAzSKRG {
    # declare all required variables

    $azskRGName = "AzSKRG"
    $automationAccountName = "AzSKContinuousAssurance"
    $azskRunbookNames = @('AzSKContinuousAssurance/Continuous_Assurance_Runbook', 'AzSKContinuousAssurance/Alert_Runbook', 'AzSKContinuousAssurance/Continuous_Assurance_ScanOnTrigger_Runbook')
    $StorageAccountNamePattern = "^azsk\d{14}$"
    $alertNamePattern = "AzSK_*_Alert*"
    $azskActionGroupNames = @("AzSKAlertActionGroup", "AzSKCriticalAlertActionGroup", "ResourceDeploymentActionGroup")

    $allResources = @()
    $azskResources = @()
    $nonAzSKResources = @()
    $azskRGDeleted = $false

    # Get all resources in AzSKRG 
    $allResources += Get-AzResource -ResourceGroupName $azskRGName -ErrorAction Stop

    if (($allResources | Measure-Object).Count -gt 0) {
        # Check AzSK Stoarge account 
        $storageAccount = $allResources | Where-Object { $_.Name -match $StorageAccountNamePattern -and $_.ResourceType -eq "Microsoft.Storage/storageAccounts" }
        if (($storageAccount | Measure-Object).Count -gt 0) {
            $azskResources += $storageAccount
        }
        
        # Check AzSK continuous assurance automation accounts
        $existingAutomationAccount = $allResources | Where-Object { $_.Name -eq $automationAccountName -and $_.ResourceType -eq "Microsoft.Automation/automationAccounts" }
        if (($existingAutomationAccount | Measure-Object).Count -gt 0) {
            $azskResources += $existingAutomationAccount

            # Check AzSK runbooks
            $existingAzSKRunbooks += $allResources | Where-Object { $_.ResourceType -eq "Microsoft.Automation/automationAccounts/runbooks" -and $_.Name -in $azskRunbookNames }
            if (($existingAzSKRunbooks  | Measure-Object).Count -gt 0) {
                $azskResources += $existingAzSKRunbooks	
            }
            
        }

        # Get the alerts
        $configuredAlerts = $allResources | Where-Object { $_.ResourceType -eq "Microsoft.Insights/activityLogAlerts" -and $_.Name -like $alertNamePattern }
        if ($configuredAlerts) {
            $azskResources += $configuredAlerts	
        }

        # Get the Action Group
        $actionGrps = $allResources | Where-Object { $_.ResourceType -eq "microsoft.insights/actiongroups" -and $_.Name -in $azskActionGroupNames }
        if ($actionGrps) {
            $azskResources += $actionGrps	
        }
        
        if ($azskResources) {
            $nonAzSKResources += $allResources | Where-Object { $_.Id -inotin $azskResources.Id }
        }
        else {
            $nonAzSKResources += $allResources
        }

        
        Write-Host "A) Listing AzSK resources present in $($azskRGName):"
        if ($azskResources) {
            $azskResources | Select-Object Name, ResourceType | Format-Table
        }
        else {
            Write-Host "No such resources found.`n"
        }

        Write-Host("B) Listing Non-AzSK resources present in $($azskRGName):")
        if ($nonAzSKResources) {   
            $nonAzSKResources | Select-Object Name, ResourceType | Format-Table
        }
        else {
            Write-Host "No such resources found."
        }

        #Display Warning in case NonAzSK resources are present

        if ($nonAzSKResources) {
            Write-Host "WARNING: Following Non-AzSK deployed resources are also present in AzSKRG resource group, if you choose to delete resource group, these resources will also be deleted." -ForegroundColor Yellow
            $nonAzSKResources | Select-Object Name, ResourceType | Format-Table
            Write-Host "`nPlease confirm deletion of all above listed resources: `n[Y]: Yes`n[N]: No" -ForegroundColor Cyan 
            $userChoice = ""
            $userChoice = Read_UserChoice
            if ($userChoice -ne 'Y') {
                Write-Host "Skipped deletion of $($azskRGName) group." -ForegroundColor Yellow
                return
            }
        }
        Write-Host "------------------------------------------------------"

        Write-Host "`nStep 3:Cleaning resources present under resource group [$($azskRGName)] in Subscription [$($SubscriptionId)]..."
       
        if ($azskResources) {
            $userChoice = "" 
            if ($force) {
                $userChoice = "Y"
                Write-Host "`nForce parameter is set to 'True', no further consent required." -ForegroundColor Yellow 
            }
            else {

                Write-Host "Please select an action from below: `n[Y]: Delete $($azskRGName) reosurce group `n[N]: Skip deletion for $($azskRGName) resource group`n" -ForegroundColor Cyan 
                
                $userChoice = Read-Host "User choice"
                if (-not [string]::IsNullOrWhiteSpace($userChoice)) {
                    $userChoice = $userChoice.Trim();
                }
                
            }
            switch ($userChoice.ToUpper()) {                    
                "Y" { 
                    #DeleteRG	
                    Write-Host "======================================================"
                    Write-Host "`n$($azskRGName) resource group and all resources in it will be deleted:"

                    Write-Host "------------------------------------------------------"
                    try {
                        Write-Host "Deleting AzSK resource group [$($azskRGName)] from subscription [$($SubscriptionId)].This might take few minutes.."
                        $success = Remove-AzResourceGroup -Name $azskRGName -Force
                        if (-not $success) {
                            throw;
                        }
                        $azskRGDeleted = $true
                        
                    }
                    catch {
                        Write-Host "ERROR: Error occurred while deleting resource group [$($azskRGName)], please contact support team." -ForegroundColor Red
                    }
                }
                Default {
                    Write-Host "WARNING: Deletion of AzSK resource group [$($azskRGName)] skipped." -ForegroundColor Yellow
                }
            }
 
            # Next Steps
            $success = $true
            if (-not $azskRGDeleted) {
                Write-Host "[$($azskRGName)] is not removed from subscription [$($SubscriptionId)], please look at the wanrings/errors listed above after step #3."
                Write-Host "`ta) If there is any Non-AzSK resources present in $($azskRGName), please remove/delete those resources using Azure portal."
                Write-Host "`tb) If there is any error occurred while deleting AzSK resources, please look at the error details to resolve or try deleting such resources from Azure portal."
                $success = $success -and $false
            }  

            if ($success) {
                Write-Host "------------------------------------------------------"
                Write-Host "$($azskRGName) resource group deleted successfully." -ForegroundColor Green
            }

            Write-Host "======================================================" -ForegroundColor Cyan

        }
    }
}

Function RemoveAzSDKRG {
    # declare all required variables

    $azsdkRGName = "AzSDKRG"
    $azsdkRGName = "AzSDKRG"
    $automationAccountName = "AzSDKContinuousAssurance"
    $azsdkRunbookNames = @('AzSDKContinuousAssurance/Continuous_Assurance_Runbook', 'AzSDKContinuousAssurance/Alert_Runbook', 'AzSDKContinuousAssurance/Continuous_Assurance_ScanOnTrigger_Runbook')
    $StorageAccountNamePattern = "^azsdk\d{14}$"
    $alertNamePattern = "AzSDK_*_Alert*"
    $azsdkActionGroupNames = @("AzSDKAlertActionGroup", "AzSDKCriticalAlertActionGroup", "ResourceDeploymentActionGroup")

    $allResources = @()
    $azsdkResources = @()
    $nonAzSDKResources = @()
    $azsdkRGDeleted = $false

    # Get All resource in AzSDKRG 
    $allResources += Get-AzResource -ResourceGroupName $azsdkRGName -ErrorAction Stop

    if (($allResources | Measure-Object).Count -gt 0) {
        # Check AzSDK Stoarge account 
        $storageAccount = $allResources | Where-Object { $_.Name -match $StorageAccountNamePattern -and $_.ResourceType -eq "Microsoft.Storage/storageAccounts" }
        if (($storageAccount | Measure-Object).Count -gt 0) {
            $azsdkResources += $storageAccount
        }
        
        # Check AzSDK continuous assurance automation accounts
        $existingAutomationAccount = $allResources | Where-Object { $_.Name -eq $automationAccountName -and $_.ResourceType -eq "Microsoft.Automation/automationAccounts" }
        if (($existingAutomationAccount | Measure-Object).Count -gt 0) {
            $azsdkResources += $existingAutomationAccount

            # Check AzSDK runbooks
            $existingAzSDKRunbooks += $allResources | Where-Object { $_.ResourceType -eq "Microsoft.Automation/automationAccounts/runbooks" -and $_.Name -in $azsdkRunbookNames }
            if (($existingAzSDKRunbooks  | Measure-Object).Count -gt 0) {
                $azsdkResources += $existingAzSDKRunbooks	
            }
            
        }

        # Get the alerts
        $configuredAlerts = $allResources | Where-Object { $_.ResourceType -eq "Microsoft.Insights/activityLogAlerts" -and $_.Name -like $alertNamePattern }
        if ($configuredAlerts) {
            $azsdkResources += $configuredAlerts	
        }

        # Get the Action Group
        $actionGrps = $allResources | Where-Object { $_.ResourceType -eq "microsoft.insights/actiongroups" -and $_.Name -in $azsdkActionGroupNames }
        if ($actionGrps) {
            $azsdkResources += $actionGrps	
        }
        
        if ($azsdkResources) {
            $nonAzSDKResources += $allResources | Where-Object { $_.Id -inotin $azsdkResources.Id }
        }
        else {
            $nonAzSDKResources += $allResources
        }

        
        Write-Host "A) Listing AzSDK resources present in $($azsdkRGName):"
        if ($azsdkResources) {
            $azsdkResources | Select-Object Name, ResourceType | Format-Table
        }
        else {
            Write-Host "No such resources found.`n"
        }

        Write-Host("B) Listing Non-AzSDK resources present in $($azsdkRGName):")
        if ($nonAzSDKResources) {   
            $nonAzSDKResources | Select-Object Name, ResourceType | Format-Table
        }
        else {
            Write-Host "No such resources found."
        }

        #Display Warning in case NonAzSDK resources are present

        if ($nonAzSDKResources) {
            Write-Host "WARNING: Following Non-AzSDK deployed resources are also present in AzSDKRG resource group, if you choose to delete resource group, these resources will also be deleted." -ForegroundColor Yellow
            $nonAzSDKResources | Select-Object Name, ResourceType | Format-Table
            Write-Host "`nPlease confirm deletion of all above listed resources: `n[Y]: Yes`n[N]: No" -ForegroundColor Cyan 
            $userChoice = ""
            $userChoice = Read_UserChoice
            if ($userChoice -ne 'Y') {
                Write-Host "Skipped deletion of $($azsdkRGName) group." -ForegroundColor Yellow
                return
            }
        }
        Write-Host "------------------------------------------------------"

        Write-Host "`nStep 4: Cleaning resources present under resource group [$($azsdkRGName)] in Subscription [$($SubscriptionId)]..."
       
        if ($azsdkResources) {
            $userChoice = "" 
            if ($force) {
                $userChoice = "Y"
                Write-Host "`nForce parameter is set to 'True', no further consent required." -ForegroundColor Yellow 
            }
            else {

                Write-Host "Please select an action from below: `n[Y]: Delete $($azsdkRGName) reosurce group `n[N]: Skip deletion for $($azsdkRGName) resource group`n" -ForegroundColor Cyan 
                
                $userChoice = Read-Host "User choice"
                if (-not [string]::IsNullOrWhiteSpace($userChoice)) {
                    $userChoice = $userChoice.Trim();
                }
                
            }
            switch ($userChoice.ToUpper()) {                    
                "Y" { 
                    #DeleteRG	
                    Write-Host "======================================================"
                    Write-Host "`n$($azsdkRGName) resource group and all resources in it will be deleted:"

                    Write-Host "------------------------------------------------------"
                    try {
                        Write-Host "Deleting resource group [$($azsdkRGName)] from subscription [$($SubscriptionId)].This might take few minutes.."
                        $success = Remove-AzResourceGroup -Name $azsdkRGName -Force
                        if (-not $success) {
                            throw;
                        }
                        $azsdkRGDeleted = $true
                        
                    }
                    catch {
                        Write-Host "ERROR: Error occurred while deleting resource group [$($azsdkRGName)], please contact support team." -ForegroundColor Red
                    }
                }
                Default {
                    Write-Host "WARNING: Deletion of resource group [$($azsdkRGName)] skipped." -ForegroundColor Yellow
                }
            }
 
            # Next Steps
            $success = $true
            if (-not $azsdkRGDeleted) {
                Write-Host "[$($azsdkRGName)] is not removed from subscription [$($SubscriptionId)], please look at the wanrings/errors listed above after step #3."
                Write-Host "`ta) If there is any Non-AzSDK resources present in $($azsdkRGName), please remove/delete those resources using Azure portal."
                Write-Host "`tb) If there is any error occurred while deleting AzSDK resources, please look at the error details to resolve or try deleting such resources from Azure portal."
                $success = $success -and $false
            }  

            if ($success) {
                Write-Host "------------------------------------------------------"
                Write-Host "$($azsdkRGName) resource group deleted successfully." -ForegroundColor Green
            }

            Write-Host "======================================================" -ForegroundColor Cyan

        }
    }
}


