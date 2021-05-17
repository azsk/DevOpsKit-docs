function Pre_requisites
{
    <#
    .SYNOPSIS
    This command would check pre requisities modules.
    .DESCRIPTION
    This command would check pre requisities modules to perform clean-up.
	#>

    Write-Host "Required modules are: Az.Resources, Az.Accounts, Az.Automation" -ForegroundColor Cyan
    Write-Host "Checking for required modules..."
    $availableModules = $(Get-Module -ListAvailable Az.Resources, Az.Accounts, Az.Automation)
    
    # Checking if 'Az.Accounts' module is available or not.
    if($availableModules.Name -notcontains 'Az.Accounts')
    {
        Write-Host "Installing module Az.Accounts..." -ForegroundColor Yellow
        Install-Module -Name Az.Accounts -Scope CurrentUser -Repository 'PSGallery'
    }
    else
    {
        Write-Host "Az.Accounts module is available." -ForegroundColor Green
    }

    # Checking if 'Az.Resources' module is available or not.
    if($availableModules.Name -notcontains 'Az.Resources')
    {
        Write-Host "Installing module Az.Resources..." -ForegroundColor Yellow
        Install-Module -Name Az.Resources -Scope CurrentUser -Repository 'PSGallery'
    }
    else
    {
        Write-Host "Az.Resources module is available." -ForegroundColor Green
    }

     # Checking if 'Az.Automation' module is available or not.
    if($availableModules.Name -notcontains 'Az.Automation')
    {
        Write-Host "Installing module Az.Automation..." -ForegroundColor Yellow
        Install-Module -Name Az.Automation -Scope CurrentUser -Repository 'PSGallery'
    }
    else
    {
        Write-Host "Az.Automation module is available." -ForegroundColor Green
    }

}

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

function Delete_StorageAccount
{
    param ($StorageAccount)
    
    Write-Host "Deleting AzSK storage account [$($storageAccount.Name)]..."  
    $success = Remove-AzResource -ResourceGroupName $azskRGName -ResourceName $storageAccount.Name -ResourceType 'Microsoft.Storage/storageAccounts' -Force
    if(-not $success)
    {
        throw;
    }
    Write-Host "Successfully deleted AzSK storage account." -ForegroundColor Green
}

function Delete_AutomationAccount
{
    param ($ExistingAutomationAccount)
    
    Write-Host "Deleting AzSK automation account [$($existingAutomationAccount.Name)]..." 
    $success = Remove-AzResource -ResourceGroupName $azskRGName -ResourceName $existingAutomationAccount.Name -ResourceType 'Microsoft.Automation/automationAccounts' -Force
    if(-not $success)
    {
        throw;
    }
    Write-Host "Successfully deleted AzSK automation account." -ForegroundColor Green
}

function Delete_RoleAssignments
{
    param ($AzskRoleAssignments)

    Write-Host "Deleting role assignments of AzSK CA SPN..." 
    $azskRoleAssignments | Remove-AzRoleAssignment
    Write-Host "Successfully deleted role assignment of AzSK CA SPN." -ForegroundColor Green
}

function Delete_AADApplication
{
    param ($AadApp)

    Write-Host "Deleting AAD application of AzSK CA SPN..." 
    $success = Remove-AzADApplication -ApplicationId $aadApp.ApplicationId -Force
    # Added this check as remove-azadapplication not returing success true/false properly
    $appStillExist = Get-AzADApplication -ApplicationId $aadApp.ApplicationId -ErrorAction SilentlyContinue
    if($appStillExist)
    {
        throw;
    }
    Write-Host "Successfully deleted AAD application of AzSK CA SPN." -ForegroundColor Green
}

function Remove-AzSKResources
{
    <#
    .SYNOPSIS
    This command would help in deleting the AzSK deployed Azure resources in subscription.
    .DESCRIPTION
    This command will list all resources deployed in AzSKRG and divide them in two list a). AzSK deployed resources b). Non-AzSK deployed resources and will provide option to clean AzSK deployed resources.

    .PARAMETER SubscriptionId
        Enter subscription id of the subscription for which clean-up need to be performed.
    .PARAMETER PerformPreReqCheck
        Perform pre requisities check to ensure all required module to perform clean-up operation is available.
    .PARAMETER Force
        Switch to force deletion of AzSK resources without further user consent.
    #>

    param (
    [string]
    [Parameter(Mandatory = $true, HelpMessage="Enter subscription id for clean-up")]
    $SubscriptionId,

    [switch]
    $PerformPreReqCheck,

    [switch]
    $Force
    )

    Write-Host "======================================================"
    Write-Host "Starting to perform clean-up for subscription [$($SubscriptionId)]..."
    Write-Host "------------------------------------------------------"

    if($PerformPreReqCheck)
    {
        try 
        {
            Write-Host "Checking for pre-requisites..."
            Pre_requisites
            Write-Host "------------------------------------------------------"     
        }
        catch 
        {
            Write-Host "Error occured while checking pre-requisites. ErrorMessage [$($_)]" -ForegroundColor Red    
            break
        }
    }

    # Connect to AzAccount
    $isContextSet = Get-AzContext
    if ([string]::IsNullOrEmpty($isContextSet))
    {       
        Write-Host "Connecting to AzAccount..."
        Connect-AzAccount
        Write-Host "Connected to AzAccount" -ForegroundColor Green
    }

    # Setting context for current subscription.
    $currentSub = Set-AzContext -SubscriptionId $SubscriptionId -ErrorAction Stop -Force

    Write-Host "Metadata Details: `n SubscriptionId: [$($SubscriptionId)] `n AccountName: [$($currentSub.Account.Id)] `n AccountType: [$($currentSub.Account.Type)]"
    Write-Host "------------------------------------------------------"
    Write-Host "Starting with Subscription [$($SubscriptionId)]..."


    Write-Host "`nStep 1 of 3: Validating whether the current user [$($currentSub.Account.Id)] have the required permissions to run the script for Subscription [$($SubscriptionId)]..."

    # Safe Check: Checking whether the current account is of type User
    if($currentSub.Account.Type -ne "User")
    {
        Write-Host "WARNING: This script can only be run by user account type." -ForegroundColor Yellow
        break;
    }

    # Safe Check: Current user need to have Owner role for the subscription
    $currentLoginRoleAssignments = Get-AzRoleAssignment -SignInName $currentSub.Account.Id -Scope "/subscriptions/$($SubscriptionId)" -IncludeClassicAdministrators;

    if(($currentLoginRoleAssignments | Where-Object { $_.RoleDefinitionName -eq "Owner" -or $_.RoleDefinitionName -match 'CoAdministrator' -or $_.RoleDefinitionName -like '*ServiceAdministrator*'} | Measure-Object).Count -le 0)
    {
        Write-Host "WARNING: This script can only be run by an Owner of subscription [$($SubscriptionId)] " -ForegroundColor Yellow
        break;
    }
    else{
        Write-Host "User has all required permissions." -ForegroundColor Green
    }

    # Declaring all AzSK resources name/pattern
    $azskRGName = "AzSKRG"
    $automationAccountName = "AzSKContinuousAssurance"
    $azskRunbookNames = @('AzSKContinuousAssurance/Continuous_Assurance_Runbook', 'AzSKContinuousAssurance/Alert_Runbook', 'AzSKContinuousAssurance/Continuous_Assurance_ScanOnTrigger_Runbook')
    $connectionAssetName = "AzureRunAsConnection"
    $StorageAccountNamePattern= "^azsk\d{14}$"
    $alertNamePattern = "AzSK_*_Alert*"
    $azskLocalSPNFormatString = "AzSK_CA_SPN_*"
    $azskActionGroupNames = @("AzSKAlertActionGroup", "AzSKCriticalAlertActionGroup", "ResourceDeploymentActionGroup")

    Write-Host "`nStep 2 of 3: Listing resources present under resource group [$($azskRGName)] in Subscription [$($SubscriptionId)]..."

    # Get AzSK RG
    $azskRG = Get-AzResourceGroup $azskRGName -ErrorAction SilentlyContinue

    if(-not $azskRG)
    {
        Write-Host "AzSKRG is not present in subscription [$($SubscriptionId)]" -ForegroundColor Red
        return;
    }

    # declare all required variables
    $allResources  = @()
    $azskResources = @()
    $nonAzSKResources = @()
    $errorCollection = @()
    $userSkippedResources = @()
    $existingAzSKRunbooks = @()
    $nonAzSKRunbooks = @()
    $azskRoleAssignments = @()
    $deleteAzSKRG = $false
    $caSPN = $null
    $aadApp = $null
    $aadAppDeleted = $false
    $roleAssignmentRemoved = $false
    $azskRGDeleted = $false

    # Get All resource in AzSKRG 
    $allResources += Get-AzResource -ResourceGroupName $azskRGName -ErrorAction Stop

    if(($allResources | Measure-Object).Count -gt 0)
    {
        # Check AzSK Stoarge account 
        $storageAccount = $allResources | Where-Object { $_.Name -match $StorageAccountNamePattern -and $_.ResourceType -eq "Microsoft.Storage/storageAccounts" }
        if(($storageAccount|Measure-Object).Count -gt 0)
        {
	        $azskResources += $storageAccount
        }
        
        # Check AzSK continuous assurance automation accounts
        $existingAutomationAccount = $allResources | Where-Object { $_.Name -eq $automationAccountName -and $_.ResourceType -eq "Microsoft.Automation/automationAccounts" }
        if(($existingAutomationAccount|Measure-Object).Count -gt 0)
        {
	        $azskResources += $existingAutomationAccount

            # Check AzSK runbooks
            $existingAzSKRunbooks += $allResources | Where-Object { $_.ResourceType -eq "Microsoft.Automation/automationAccounts/runbooks" -and $_.Name -in $azskRunbookNames}
            if(($existingAzSKRunbooks  |Measure-Object).Count -gt 0)
            {
	            $azskResources += $existingAzSKRunbooks	
            }
            
            # Check non AzSK runbooks present in AzSK Automation account
            $nonAzSKRunbooks += $allResources | Where-Object { $_.ResourceType -eq "Microsoft.Automation/automationAccounts/runbooks" -and  $_.Name -like "$($automationAccountName)/*" -and $_.Name -notin $azskRunbookNames} 
            if($nonAzSKRunbooks)
            {
                $azskResources += $nonAzSKRunbooks
            }


            # Fetching appID of CA SPN 
            $connection = Get-AzAutomationConnection -AutomationAccountName $automationAccountName -ResourceGroupName  $azskRGName -Name $connectionAssetName -ErrorAction SilentlyContinue			
            if($connection)
            {
              $appID = $connection.FieldDefinitionValues.ApplicationId
              $caSPN = Get-AzADServicePrincipal -ServicePrincipalName $appID -ErrorAction SilentlyContinue
              $aadAPP = Get-AzADApplication -ApplicationId $appID -ErrorAction SilentlyContinue
              # Safe check: SPN display name should match AzSK specified name pattern
              if(-not ($caSPN.DisplayName -like $azskLocalSPNFormatString))
              {
                $caSPN = $null
                $aadAPP = $null
              }
            }

            # Get role assignment of current SPN
            if($caSPN)
            {
                $subscriptionScope = "/subscriptions/{0}" -f $SubscriptionId
                $rgScope = "/subscriptions/{0}/resourcegroups/{1}" -f $SubscriptionId, $azskRGName
                $spnObjectId = $caSPN.Id

                # check subscription scope 'reader' role assignment
                $azskRoleAssignments += Get-AzRoleAssignment -Scope $subscriptionScope -RoleDefinitionName Reader | Where-Object { $_.ObjectId -eq $spnObjectId }
                # check resource group scope 'contributor' role assignment
                $azskRoleAssignments += Get-AzRoleAssignment -Scope $rgScope -RoleDefinitionName Contributor | Where-Object { $_.ObjectId -eq $spnObjectId }

            }
            
        }

        # Get the alerts
        $configuredAlerts = $allResources | Where-Object {$_.ResourceType -eq "Microsoft.Insights/activityLogAlerts"-and $_.Name -like $alertNamePattern }
        if($configuredAlerts)
        {
            $azskResources += $configuredAlerts	
        }

        # Get the Action Group
        $actionGrps = $allResources | Where-Object { $_.ResourceType  -eq "microsoft.insights/actiongroups" -and $_.Name -in $azskActionGroupNames}
        if($actionGrps)
        {
            $azskResources += $actionGrps	
        }
        
        if($azskResources)
        {
            $nonAzSKResources += $allResources | Where-Object {$_.Id -inotin $azskResources.Id }
        }
        else
        {
            $nonAzSKResources += $allResources
        }

        Write-Host "`nA) Listing details of SPN associated with current AzSK automation account:"
        if($caSPN)
        {
            $caSPN | Select-Object "DisplayName", "ApplicationId" | Format-Table

            if($azskRoleAssignments)
            {
                Write-Host "`tRole assignments for SPN:"
                $azskRoleAssignments | Select-Object "RoleDefinitionName", "Scope" | Format-Table

            }
        }
        else
        {
            Write-Host("No SPN found.`n")
        }

        Write-Host "B) Listing AzSK resources present in AzSKRG:"
        if($azskResources)
        {
            $azskResources | Select-Object Name, ResourceType | Format-Table
        }
        else{
            Write-Host "No such resources found.`n"
        }

        Write-Host("C) Listing Non-AzSK resources are present in AzSKRG:")
        if($nonAzSKResources)
        {   
            $nonAzSKResources | Select-Object Name, ResourceType | Format-Table
        }
        else{
            Write-Host "No such resources found."
        }

        Write-Host "`nStep 3 of 3: Cleaning resources present under resource group [$($azskRGName)] in Subscription [$($SubscriptionId)]..."

        if($azskResources)
        {
            $userChoice="" 
            if($force)
            {
                $userChoice="A"
                Write-Host "`nForce parameter is set to 'True', no further consent required." -ForegroundColor Yellow 
            }
            else
            {

                Write-Host "Please select an action from below: `n[A]: Delete all AzSK deployed resources & AAD application `n[N]: Delete none`n[S]: Delete selected" -ForegroundColor Cyan 
                while($userChoice -ne 'A' -and $userChoice -ne 'N' -and $userChoice -ne 'S')
                {
                    $userChoice = Read-Host "User choice"
                    if(-not [string]::IsNullOrWhiteSpace($userChoice))
			        {
				        $userChoice = $userChoice.Trim();
			        }
                }
            }


            switch ($userChoice.ToUpper())
            {                    
			    "A" #DeleteAll
			    {	
                    Write-Host "======================================================"
                    Write-Host "`nFollowing resources will be deleted:"

                    Write-Host "------------------------------------------------------"
                    Write-Host "`tAzure resources:" -ForegroundColor Cyan 
                    $azskResources | Select-Object Name, ResourceType | Format-Table

                    if($caSPN)
                    {
                        Write-Host "------------------------------------------------------"
                        if($azskRoleAssignments)
                        {
                            Write-Host "`tRole assignments:" -ForegroundColor Cyan
                            $azskRoleAssignments | Select-Object "RoleDefinitionName", "Scope" | Format-Table
                        }
                        
                        Write-Host "`tAzure AD application:" -ForegroundColor Cyan 
                        $caSPN | Select-Object DisplayName, ApplicationId | Format-Table

                        Write-host "WARNING: Before deleting SPN & AAD Application [$($caSPN.DisplayName)], please make sure that this AAD application & SPN is not used anywhere else." -ForegroundColor Yellow
                        Write-Host "------------------------------------------------------"

                    }
                    Write-Host "======================================================"

                    $userChoice = ""
                    if($force)
                    {
                        $userChoice="Y" # No further user consent required as 'Force' switch is enabled
                    }else
                    {
                        Write-Host "`nPlease confirm deletion of all above listed resources: `n[Y]: Yes`n[N]: No" -ForegroundColor Cyan 
                    
                        $userChoice = Read_UserChoice
                    }
                   

                    if($userChoice -ne "Y")
                    {
                        Write-Host "No resources were deleted." -ForegroundColor Yellow  
                        $userSkippedResources = $azskResources                  
			            break;
                    }

                    

                    # Delete storage account if exists
                    if($storageAccount)
                    {
                        try
                        {
                            Delete_StorageAccount -StorageAccount $storageAccount
                        }
                        catch
                        {
                            $errorCollection += $storageAccount
                            Write-Host "Error occurred while deleting AzSK storage account [$($storageAccount.Name)]." -ForegroundColor DarkYellow
                        }
                    }

                    # Delete automation account and all associated runbooks if exists
                    if($existingAutomationAccount)
                    {
                        try
                        {   
                            Delete_AutomationAccount -ExistingAutomationAccount $existingAutomationAccount
                        }
                        catch
                        {
                            $errorCollection += $existingAutomationAccount
                            $errorCollection += $existingAzSKRunbooks 
                            Write-Host "Error occurred while deleting AzSK automation account [$($existingAutomationAccount.Name)]." -ForegroundColor DarkYellow
                        }
                    }

                    # Delete the alerts if exist
                    if($configuredAlerts)
                    {
                        $errorCount = 0 
                        Write-Host "Deleting AzSK alerts..." 
                        $configuredAlerts | ForEach-Object {
	                        $alertName = $_.Name;
                            $alert = $_;
	                        # Remove alert
	                        try
	                        {
		                        $success = Remove-AzResource -ResourceType "Microsoft.Insights/activityLogAlerts" -ResourceGroupName  $azskRGName -Name $alertName -Force  
                                if(-not $success)
                                {
                                    throw;
                                }  
	                        }
	                        catch
	                        {
		                        $errorCount += 1;
                                $errorCollection += $alert
	                        }
                        }

                        if($errorCount -gt 0)
                        {
                            Write-Host "Error occurred while deleting AzSK alerts." -ForegroundColor DarkYellow
                        }else{
                            Write-Host "Successfully deleted AzSK alerts." -ForegroundColor Green
                        }
                    }
                
                    # Delete the action groups if exist
                    if($actionGrps)
                    {
                        Write-Host "Deleting AzSK action groups..." 
                        $errorCount = 0
                        $actionGrps | ForEach-Object {
                            $actionGroupName = $_.Name;
	                        $actionGroup = $_;
	                        try
	                        {
		                        $success = Remove-AzResource -ResourceType "Microsoft.Insights/actiongroups" -ResourceGroupName  $azskRGName -Name $actionGroupName -Force  
                                if(-not $success)
                                {
                                    throw;
                                }   
	                        }
	                        catch
	                        {
		                        $errorCount += 1;
                                $errorCollection += $actionGroup
	                        }
                        }

                        if($errorCount -gt 0)
                        {
                            Write-Host "Error occurred while deleting AzSK action groups." -ForegroundColor DarkYellow
                        }else{
                            Write-Host "Successfully deleted AzSK action groups." -ForegroundColor Green
                        }
                    }    

                    # Delete role assignments
                    if($azskRoleAssignments)
                    {
                        try
                        {
                            Delete_RoleAssignments -AzskRoleAssignments $azskRoleAssignments
                            $roleAssignmentRemoved = $true
                        }
                        catch
                        {
                            Write-Host "ERROR: There was some error while removing role assignment for AzSK SPN." -ForegroundColor DarkYellow
                        }
                    }

                    # Delete the AAD Application
                    if($aadApp)
                    {
                        try
                        {
                            Delete_AADApplication -AadApp $aadApp
                            $aadAppDeleted = $true
                        }
                        catch
                        {
                            Write-Host "ERROR: There was an error while deleting the AAD application. You may not have 'Owner' permission on it." -ForegroundColor DarkYellow
                        }
                    }
                
                    break  				
			    }
			    "N" #None
			    {
                    Write-Host "Process aborted. No resources were deleted." -ForegroundColor Yellow  
                    $userSkippedResources = $azskResources   
                    return;               
			        break
			    }
			    "S" #Select
			    {
                    Write-Host "======================================================"
                    # Delete storage account if exists and user confirms
                    if($storageAccount)
                    {
                        Write-Host "------------------------------------------------------"
                        Write-Host "`nDo you want to delete AzSK storage account: `n[Y]: Yes`n[N]: No" -ForegroundColor Cyan 
                        $storageAccount | Select-Object Name, ResourceType | Format-Table
                        $userChoice=""
                        $userChoice = Read_UserChoice
                    
                        if($userChoice -eq 'Y')
                        {
                            try
                            {
                                Delete_StorageAccount -StorageAccount $storageAccount
                            }
                            catch
                            {
                                $errorCollection += $storageAccount
                                Write-Host "Error occurred while deleting AzSK storage account [$($storageAccount.Name)]." -ForegroundColor DarkYellow
                            }
                        }
                        else
                        {
                            $userSkippedResources += $storageAccount
                            Write-Host "Skipped deletion of AzSK storage account [$($storageAccount.Name)]." -ForegroundColor Yellow
                        }
                        Write-Host "------------------------------------------------------"
                        
                    }

                    # Delete automation account and all associated runbooks if exists
                    if($existingAutomationAccount)
                    {
                        Write-Host "------------------------------------------------------"
                        Write-Host "`nDo you want to delete AzSK automation account and all associated runbooks: `n[Y]: Yes`n[N]: No" -ForegroundColor Cyan 
                        (@($existingAutomationAccount) + $existingAzSKRunbooks) | Select-Object Name, ResourceType | Format-Table
                        

                        if($nonAzSKRunbooks)
                        {
                            Write-Host "WARNING: Following Non-AzSK deployed runbooks are also present in AzSK automation account, if you choose to delete AzSK automation account these runbooks will also be deleted." -ForegroundColor Yellow
                            $nonAzSKRunbooks | Select-Object Name, ResourceType | Format-Table
                        }

                        $userChoice=""
                        $userChoice = Read_UserChoice

                        if($userChoice -eq 'Y')
                        {

                            try
                            {   
                                Delete_AutomationAccount -ExistingAutomationAccount $existingAutomationAccount
                            }
                            catch
                            {
                                $errorCollection += $existingAutomationAccount
                                $errorCollection += $existingAzSKRunbooks 
                                Write-Host "Error occurred while deleting AzSK automation account [$($existingAutomationAccount.Name)]." -ForegroundColor DarkYellow
                            }
                        }
                        else
                        {
                            $userSkippedResources += $existingAutomationAccount
                            $userSkippedResources += $existingAzSKRunbooks
                            Write-Host "Skipped deletion of AzSK automation account [$($existingAutomationAccount.Name)]." -ForegroundColor Yellow
                        }
                        Write-Host "------------------------------------------------------"
                    }

                    # Delete the alerts if exist
                    if($configuredAlerts)
                    {
                        Write-Host "------------------------------------------------------"
                        Write-Host "`nDo you want to delete AzSK alerts: `n[Y]: Yes`n[N]: No" -ForegroundColor Cyan 
                        $configuredAlerts | Select-Object Name, ResourceType | Format-Table
                        $userChoice=""
                        $userChoice = Read_UserChoice

                        if($userChoice -eq 'Y')
                        {
                            $errorCount = 0 
                            Write-Host "Deleting AzSK alerts..." 
                            $configuredAlerts | ForEach-Object {
	                            $alertName = $_.Name;
                                $alert = $_;
	                            # Remove alert
	                            try
	                            {
		                            $success = Remove-AzResource -ResourceType "Microsoft.Insights/activityLogAlerts" -ResourceGroupName  $azskRGName -Name $alertName -Force    
                                    if(-not $success)
                                    {
                                        throw;
                                    }
	                            }
	                            catch
	                            {
		                            $errorCount += 1;
                                    $errorCollection += $alert
	                            }
                            }

                            if($errorCount -gt 0)
                            {
                                Write-Host "Error occurred while deleting AzSK alerts." -ForegroundColor DarkYellow
                            }else{
                                Write-Host "Successfully deleted AzSK alerts." -ForegroundColor Green
                            }
                        }
                        else
                        {
                            $userSkippedResources += $configuredAlerts
                            Write-Host "Skipped deletion of AzSK alerts." -ForegroundColor Yellow
                        }
                        Write-Host "------------------------------------------------------"
                    }
                
                    # Delete the action groups if exist
                    if($actionGrps)
                    {
                        Write-Host "------------------------------------------------------"
                        Write-Host "`nDo you want to delete AzSK alert action groups: `n[Y]: Yes`n[N]: No" -ForegroundColor Cyan 
                        $actionGrps | Select-Object Name, ResourceType | Format-Table
                        $userChoice=""
                        $userChoice = Read_UserChoice

                        if($userChoice -eq 'Y')
                        {

                            Write-Host "Deleting AzSK action groups..." 
                            $errorCount = 0
                            $actionGrps | ForEach-Object {
                                $actionGroupName = $_.Name;
	                            $actionGroup = $_;
	                            try
	                            {
		                            $success = Remove-AzResource -ResourceType "Microsoft.Insights/actiongroups" -ResourceGroupName  $azskRGName -Name $actionGroupName -Force    
                                    if(-not $success)
                                    {
                                        throw;
                                    }
	                            }
	                            catch
	                            {
		                            $errorCount += 1;
                                    $errorCollection += $actionGroup
	                            }
                            }

                            if($errorCount -gt 0)
                            {
                                Write-Host "Error occurred while deleting AzSK action groups." -ForegroundColor DarkYellow
                            }else{
                                Write-Host "Successfully deleted AzSK action groups." -ForegroundColor Green
                            }
                        }
                        else
                        {
                             $userSkippedResources += $actionGrps
                             Write-Host "Skipped deletion of AzSK alert action groups." -ForegroundColor Yellow
                        }
                        Write-Host "------------------------------------------------------"
                    }    

                    Write-Host "======================================================"

                    # Delete the SPN role assignment
                    if($azskRoleAssignments)
                    {
                        Write-Host "------------------------------------------------------"
                        Write-Host "`nDo you want to delete AzSK SPN role assignments: `n[Y]: Yes`n[N]: No" -ForegroundColor Cyan 
                        $azskRoleAssignments | Select-Object "RoleDefinitionName", "Scope" | Format-Table
                        $userChoice=""
                        $userChoice = Read_UserChoice

                        if($userChoice -eq 'Y')
                        {
                            try
                            {
                                Delete_RoleAssignments -AzskRoleAssignments $azskRoleAssignments
                                $roleAssignmentRemoved = $true
                            }
                            catch
                            {
                                Write-Host "ERROR: There was some error while removing role assignment for AzSK SPN." -ForegroundColor DarkYellow
                            }
                        }
                        else
                        {
                            Write-Host "Skipped deletion of role assignments." -ForegroundColor Yellow
                        }
                        Write-Host "------------------------------------------------------"
                    }

                    # Delete the AAD Application
                    if($aadApp)
                    {
                        Write-Host "------------------------------------------------------"
                        Write-Host "`nDo you want to delete AzSK CA SPN/Application: `n[Y]: Yes`n[N]: No" -ForegroundColor Cyan 
                        $aadApp | Select-Object DisplayName, ApplicationId | Format-Table
                        Write-host "WARNING: Before deleting SPN & AAD Application [$($caSPN.DisplayName)], please make sure that this AAD application & SPN is not used anywhere else." -ForegroundColor Yellow
                        
                        $userChoice=""
                        $userChoice = Read_UserChoice

                        if($userChoice -eq 'Y')
                        {
                            try
                            {
                                Delete_AADApplication -AadApp $aadApp
                                $aadAppDeleted = $true
                            }
                            catch
                            {
                                Write-Host "ERROR: There was an error while deleting the AAD application. You may not have 'Owner' permission on it." -ForegroundColor DarkYellow
                            }
                        }
                        else
                        {
                            Write-Host "Skipped deletion of AzSK CA SPN/Application." -ForegroundColor Yellow
                        }
                        Write-Host "------------------------------------------------------"
                    }
                    Write-Host "======================================================"
                                  
			        break
                }

            }
        
        }

        try
        {
            $allResources = Get-AzResource -ResourceGroupName $azskRGName

            if(($allResources | Measure-Object).Count -gt 0)
            {
                Write-Host "======================================================"
                $deleteAzSKRG = $false
                if($nonAzSKResources)
                {
                   Write-Host "`nFollowing Non-AzSK resources are present in AzSKRG, please move/delete these resources before deleting AzSKRG." -ForegroundColor Yellow
                   $nonAzSKResources | Select-Object Name, ResourceType | Format-Table
                }

                if($errorCollection){
                    Write-Host "`nError occurred while deleting following resources, please delete these resources manually from portal or contact support team." -ForegroundColor Red
                    $errorCollection | Select-Object Name, ResourceType | Format-Table
                }

                if($userSkippedResources){
                    Write-Host "`nFollowing AzSK resources were skipped from deletion based on your selection, AzSKRG will not be deleted." -ForegroundColor Yellow
                    $userSkippedResources | Select-Object Name, ResourceType | Format-Table
                }

            }
            else
            {
                $deleteAzSKRG = $true
            }
        }
        catch{
            $deleteAzSKRG = $false
        }
        
    }
    else{
        $deleteAzSKRG = $true
        Write-Host "No resources found in AzSKRG." -ForegroundColor Yellow
    }

    # Delete AzSKRG
    Write-Host "------------------------------------------------------"
    if($deleteAzSKRG)
    {
        try
        {
            Write-Host "Deleting AzSK resource group [$($azskRGName)] from subscription [$($SubscriptionId)]..."
            $success = Remove-AzResourceGroup -Name $azskRGName -Force
            if(-not $success)
            {
                throw;
            }
            $azskRGDeleted = $true
            Write-Host "Successfully deleted AzSK resource group [$($azskRGName)] from subscription [$($SubscriptionId)]" -ForegroundColor Green
        }
        catch
        {
           Write-Host "ERROR: Error occurred while deleting resource group [$($azskRGName)], please contact support team." -ForegroundColor Red
        }
        
    }
    else
    {
        Write-Host "WARNING: Deletion of AzSK resource group [$($azskRGName)] skipped." -ForegroundColor Yellow
    }
    Write-Host "======================================================" -ForegroundColor Cyan

    # Summary
    Write-Host "*** Summary ***" -ForegroundColor Cyan
    Write-Host "------------------------------------------------------"
    Write-Host "Following Azure resources were deleted:"
    $resourcesNotRemoved = $errorCollection + $userSkippedResources
    $deletedResources = Compare-Object -ReferenceObject $azskResources -DifferenceObject $resourcesNotRemoved -Property ReourceId -PassThru
    if($deletedResources)
    {
        $deletedResources | Select-Object Name, ResourceType | Format-Table
    }
    else
    {
        Write-Host "`n`tNo resources were deleted."
    }

    Write-Host "------------------------------------------------------"
    Write-Host "Following role assignments were removed:"
    
    if($roleAssignmentRemoved)
    {
        $azskRoleAssignments | Select-Object "RoleDefinitionName", "Scope" | Format-Table
    }
    else
    {
        Write-Host "`n`tNo role assignment removed."
    }

    Write-Host "------------------------------------------------------"
    Write-Host "Following AAD App & SPN were deleted:"
    
    if($aadAppDeleted)
    {
        $aadApp | Select-Object DisplayName, ApplicationId | Format-Table
    }
    else
    {
        Write-Host "`n`tNo AAD App & SPN deleted."
    }
    Write-Host "------------------------------------------------------"
    Write-Host "======================================================" -ForegroundColor Cyan

    # Next Steps
    Write-Host "*** Next steps ***" -ForegroundColor Cyan
    $success = $true
    if(-not $azskRGDeleted)
    {
        Write-Host "[$($azskRGName)] is not removed from subscription [$($SubscriptionId)], please look at the wanrings/errors listed above after step #3."
        Write-Host "`ta) If there is any Non-AzSK resources present in $($azskRGName), please remove/delete those resources using Azure portal."
        Write-Host "`tb) If there is any error occurred while deleting AzSK resources, please look at the error details to resolve or try deleting such resources from Azure portal."
        Write-Host "`tc) If you choose to skip deletion of selected resourecs then no further action needed."
        $success = $success -and $false
    }
    
    if($aadApp -and -not($aadAppDeleted))
    {
        Write-Host "AAD application [$($aadApp.DisplayName)] is not deleted."
        Write-Host "`ta) You may not have owner permission on the application, please request owner of the application to delete using Azure portal."
        Write-Host "`tb) If you choose to skip deletion of AAD Application then no further action needed."
        $success = $success -and $false
    }

    if($azskRoleAssignments -and -not($roleAssignmentRemoved))
    {
        Write-Host "Role assignment of AzSK CA SPN is not successfully removed."
        Write-Host "`ta) Please look at the error details above for more details or you can also remove role assignment using Azure portal." 
        Write-Host "`tb) If you choose to skip deletion of CA SPN's role assignments then no further action needed."
        $success = $success -and $false
    }

    if($success)
    {
        Write-Host "No further action needed." -ForegroundColor Green
    }

    Write-Host "======================================================" -ForegroundColor Cyan

}





