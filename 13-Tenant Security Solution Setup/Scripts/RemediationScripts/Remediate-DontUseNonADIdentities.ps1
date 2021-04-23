function Pre_requisites
{
    <#
    .SYNOPSIS
    This command would check pre requisities modules.
    .DESCRIPTION
    This command would check pre requisities modules to perform remediation.
	#>

    Write-Host "Required modules are: Az.Resources, Az.Account" -ForegroundColor Cyan
    Write-Host "Checking for required modules..."
    $availableModules = $(Get-Module -ListAvailable Az.Resources, AzureAD, Az.Accounts)
    
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
}

function Remove-AzTSNonAADAccountsRBAC
{
    <#
    .SYNOPSIS
    This command would help in remediating 'Azure_Subscription_AuthZ_Dont_Use_NonAD_Identities' control.
    .DESCRIPTION
    This command would help in remediating 'Azure_Subscription_AuthZ_Dont_Use_NonAD_Identities' control.
    .PARAMETER SubscriptionId
        Enter subscription id on which remediation need to perform.
    .PARAMETER ObjectIds
        Enter objectIds of non ad identities.
    .Parameter Force
        Enter force parameter value to remove non ad identities
    .PARAMETER PerformPreReqCheck
        Perform pre requisities check to ensure all required module to perform rollback operation is available.
    #>

    param (
        [string]
        $SubscriptionId,

        [string[]]
        $ObjectIds,

        [switch]
        $Force,

        [switch]
        $PerformPreReqCheck
    )

    Write-Host "======================================================"
    Write-Host "Starting with removal of Non AAD Identities from subscriptions..."
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
            Write-Host "Error occured while checking pre-requisites. ErrorMessage [$($_)]" -ForegroundColor $([Constants]::MessageType.Error)    
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
    $currentSub = Set-AzContext -SubscriptionId $SubscriptionId

    Write-Host "Note: `n 1. Exclude check to remediate PIM assignment for external identities due to insufficient privilege. `n 2. Exclude check to remediate external identities at MG scope." -ForegroundColor Yellow
    Write-Host "------------------------------------------------------"

    Write-Host "Metadata Details: `n SubscriptionId: [$($SubscriptionId)] `n AccountName: [$($currentSub.Account.Id)] `n AccountType: [$($currentSub.Account.Type)]"
    Write-Host "------------------------------------------------------"
    Write-Host "Starting with Subscription [$($SubscriptionId)]..."


    Write-Host "Step 1 of 3: Validating whether the current user [$($currentSub.Account.Id)] have the required permissions to run the script for Subscription [$($SubscriptionId)]..."

    # Safe Check: Checking whether the current account is of type User and also grant the current user as UAA for the sub to support fallback
    if($currentSub.Account.Type -ne "User")
    {
        Write-Host "Warning: This script can only be run by user account type." -ForegroundColor Yellow
        break;
    }

    # Safe Check: Current user need to be either UAA or Owner for the subscription
    $currentLoginRoleAssignments = Get-AzRoleAssignment -SignInName $currentSub.Account.Id -Scope "/subscriptions/$($SubscriptionId)";

    if(($currentLoginRoleAssignments | Where { $_.RoleDefinitionName -eq "Owner"  -or $_.RoleDefinitionName -eq 'CoAdministrator' -or $_.RoleDefinitionName -eq "User Access Administrator" } | Measure-Object).Count -le 0)
    {
        Write-Host "Warning: This script can only be run by an Owner or User Access Administrator" -ForegroundColor Yellow
        break;
    }
    
    Write-Host "Step 2 of 3: Fetching all the role assignments for Subscription [$($SubscriptionId)]..."

    #  Getting all role assignments (ARM, Classic) of subscription.
    $currentRoleAssignmentList = Get-AzRoleAssignment -IncludeClassicAdministrators  

    # Excluding MG scoped role assignment
    $currentRoleAssignmentList = $currentRoleAssignmentList | Where-Object { !$_.Scope.Contains("/providers/Microsoft.Management/managementGroups/") }
    
    $distinctRoleAssignmentList = @();

    # Getting role assignment and filtering service principal object type
    if(($ObjectIds | Measure-Object).Count -eq 0)
    {
        $distinctRoleAssignmentList += $currentRoleAssignmentList | Where-Object { ![string]::IsNullOrWhiteSpace($_.SignInName) }
    }
    else
    {
        $ObjectIds | Foreach-Object {
          $objectId = $_;
           if(![string]::IsNullOrWhiteSpace($objectId))
            {
                $distinctRoleAssignmentList += Get-AzRoleAssignment -ObjectId $objectId | Where-Object { ![string]::IsNullOrWhiteSpace($_.SignInName) }
            }
            else
            {
                Write-Host "Warning: Dont pass empty string array in the ObjectIds param. If you dont want to use the param, just remove while executing the command" -ForegroundColor Yellow
                break;
            }  
        }
    }

    # Adding ARM API call to fetch eligible role assignment [Commenting this part because used ARM API is currently in preview state, we can officially start supporting once it is publicly available]
    <#
    try
    {
        # PIM api
        $resourceAppIdUri = "https://management.core.windows.net/"
        $rmContext = Get-AzContext
        [Microsoft.Azure.Commands.Common.Authentication.AzureSession]
        $authResult = [Microsoft.Azure.Commands.Common.Authentication.AzureSession]::Instance.AuthenticationFactory.Authenticate(
        $rmContext.Account,
        $rmContext.Environment,
        $rmContext.Tenant,
        [System.Security.SecureString] $null,
        "Never",
        $null,
        $resourceAppIdUri); 

        $header = "Bearer " + $authResult.AccessToken
        $headers = @{"Authorization"=$header;"Content-Type"="application/json";}
        $method = [Microsoft.PowerShell.Commands.WebRequestMethod]::Get

        # API to get eligible PIM assignment
        $armUri = "https://management.azure.com/subscriptions/$($SubscriptionId)/providers/Microsoft.Authorization/roleEligibilityScheduleInstances?api-version=2020-10-01-preview"
        $eligiblePIMRoleAssignments = Invoke-WebRequest -Method $method -Uri $armUri -Headers $headers -UseBasicParsing
        $res = ConvertFrom-Json $eligiblePIMRoleAssignments.Content

        # Exclude MG scope assignment
        $excludedMGScopeAssignment =  $res.value.properties | where-object { !$_.scope.contains("/providers/Microsoft.Management/managementGroups/") }
        $pimDistinctRoleAssignmentList += $excludedMGScopeAssignment.expandedProperties.principal | Where-Object { ![string]::IsNullOrWhiteSpace($_.email) }
        
        # Renaming property name
        $distinctRoleAssignmentList += $pimDistinctRoleAssignmentList | select @{N='SignInName'; E={$_.email}}, @{N='ObjectId'; E={$_.id}}, @{N='DisplayName'; E={$_.displayName}}, @{N='ObjectType'; E={$_.type }}
    }
    catch
    {
        Write-Host "Error occured while fetching eligible PIM role assignment. ErrorMessage [$($_)]" -ForegroundColor Red
    }
    #>
    
    # Defining regex to filter Non AAD Identities 
    $NonADIdentitiesPatterns = @( "(.)*#ext(.)*" )

    # Defining regex to filter allowed Non AAD Identities
    $ApprovedNonADIndentitiesPatterns = @( "(.)*_sas.msft.net#ext#@microsoft.onmicrosoft.com" )

    # Creating regex to filter Non AAD Account
    $NonADIdentitiesPattern = (('^' + (($NonADIdentitiesPatterns | foreach {[regex]::escape($_)}) -join '|') + '$')) -replace '[\\]',''

    # Filtering Non AAD Identities
    $liveAccountsRoleAssignments = [array]($distinctRoleAssignmentList | Where-Object {$_.SignInName -and $_.SignInName.ToLower() -imatch $NonADIdentitiesPattern} )

    # Exclude exempted patterns for non AAD identities
    if( ($liveAccountsRoleAssignments | Measure-Object).Count -gt 0 -and ($ApprovedNonADIndentitiesPatterns | Measure-Object).Count -ne 0)
    {
        $ApprovedNonADIndentitiesPattern = (('^' + (($ApprovedNonADIndentitiesPatterns | foreach {[regex]::escape($_)}) -join '|') + '$')) -replace '[\\]',''
        $liveAccountsRoleAssignments = [array]($liveAccountsRoleAssignments | Where-Object {$_.SignInName -and $_.SignInName.ToLower() -inotmatch $ApprovedNonADIndentitiesPattern} )
    }	

    # Safe Check: Check whether the current user accountId is part of Invalid AAD ObjectGuids List 
    if(($liveAccountsRoleAssignments | where { $currentLoginRoleAssignments.ObjectId -contains $_.ObjectId } | Measure-Object).Count -gt 0)
    {
        Write-Host "Warning: Current User account is found as part of the Non AAD Account. This is not expected behaviour. This can happen typically during Graph API failures. Aborting the operation. Reach out to aztssup@microsoft.com" -ForegroundColor Yellow
        break;
    }

    if(($liveAccountsRoleAssignments | Measure-Object).Count -le 0)
    {
        Write-Host "No Non AAD identities found for the subscription [$($SubscriptionId)]. Exiting the process." -ForegroundColor Cyan
        break;
    }
    else
    {
        Write-Host "Found [$(($liveAccountsRoleAssignments | Measure-Object).Count)] Non AAD role assignments for the subscription [$($SubscriptionId)]" -ForegroundColor Cyan
    }

    $folderPath = [Environment]::GetFolderPath("MyDocuments") 
    if (Test-Path -Path $folderPath)
    {
        $folderPath += "\AzTS\Remediation\Subscriptions\$($subscriptionid.replace("-","_"))\$((Get-Date).ToString('yyyyMMdd_hhmm'))\NonAADAccounts\"
        New-Item -ItemType Directory -Path $folderPath | Out-Null
    }

    # Safe Check: Taking backup of Non AAD identities    
    if ($liveAccountsRoleAssignments.length -gt 0)
    {
        Write-Host "Taking backup of role assignments for Non AAD identities that needs to be removed. Please do not delete this file. Without this file you wont be able to rollback any changes done through Remediation script." -ForegroundColor Cyan
        $liveAccountsRoleAssignments | ConvertTo-json -Depth 10 | out-file "$($folderpath)NonAADAccountsRoleAssignments.json"       
        Write-Host "Path: $($folderpath)NonAADAccountsRoleAssignments.json"
    }

    if(-not $Force)
    {
        Write-Host "Do you want to delete the above listed role assignment? " -ForegroundColor Yellow -NoNewline
        $UserInput = Read-Host -Prompt "(Y|N)"

        if($UserInput -ne "Y")
        {
            break;
        }
    }
   

    Write-Host "Step 3 of 3: Clean up Non AAD identities for Subscription [$($SubscriptionId)]..."
    
    # Start deletion of all Non AAD identities.
    Write-Host "Starting to delete role assignments for Non AAD identities..." -ForegroundColor Cyan
    
    $isRemoved = $true
    $liveAccountsRoleAssignments | ForEach-Object {
        try 
        {
            Remove-AzRoleAssignment $_
            $_ | Select-Object -Property "DisplayName", "SignInName", "Scope"
        }
        catch 
        {
            $isRemoved = $false
            Write-Host "Error occurred while removing role assignments for Non AAD identities. ErrorMessage [$($_)]" -ForegroundColor Red   
        }
    }

    if($isRemoved)
    {
        Write-Host "Completed deleting role assignments for Non AAD identities." -ForegroundColor Green
    }
    else 
    {
        Write-Host "`n"
        Write-Host "Not able to successfully delete role assignments for Non AAD identities." -ForegroundColor Red
    }    
}


function Restore-AzTSNonAADAccountsRBAC
{
    <#
    .SYNOPSIS
    This command would help in performing rollback operation for 'Azure_Subscription_AuthZ_Dont_Use_NonAD_Identities' control.
    .DESCRIPTION
    This command would help in performing rollback operation for 'Azure_Subscription_AuthZ_Dont_Use_NonAD_Identities' control.
    .PARAMETER SubscriptionId
        Enter subscription id on which rollback operation need to perform.
    .PARAMETER RollbackFilePath
        Json file path which containing remediation log to perform rollback operation.
    .PARAMETER PerformPreReqCheck
        Perform pre requisities check to ensure all required module to perform rollback operation is available.
	#>

    param (
        [string]
        $SubscriptionId,       

        [string]
        $RollbackFilePath,
        
        [switch]
        $PerformPreReqCheck
    )

    Write-Host "======================================================"
    Write-Host "Starting with restore role assignments for Non AAD identities from subscriptions..."
    Write-Host "------------------------------------------------------"
    
    if($PerformPreReqCheck)
    {
        try 
        {
            Write-Host "Checking for pre-requisites..."
            Pre_requisites
            Write-Host $([Constants]::SingleDashLine)    
        }
        catch 
        {
            Write-Host "Error occured while checking pre-requisites. ErrorMessage [$($_)]" -ForegroundColor $([Constants]::MessageType.Error)    
            break
        }    
    }

    $isContextSet = Get-AzContext
    if ([string]::IsNullOrEmpty($isContextSet))
    {       
        Write-Host "Connecting to AzAccount..."
        Connect-AzAccount
        Write-Host "Connected to AzAccount" -ForegroundColor Green
    }

    # Setting context for current subscription.
    $currentSub = Set-AzContext -SubscriptionId $SubscriptionId

    Write-Host "Metadata Details: `n SubscriptionId: [$($SubscriptionId)] `n AccountName: [$($currentSub.Account.Id)] `n AccountType: [$($currentSub.Account.Type)]"
    Write-Host "------------------------------------------------------"
    Write-Host "Starting with Subscription [$($SubscriptionId)]..."


    Write-Host "Step 1 of 3: Validating whether the current user [$($currentSub.Account.Id)] have the required permissions to run the script for Subscription [$($SubscriptionId)]..."

    # Safe Check: Checking whether the current account is of type User and also grant the current user as UAA for the sub to support fallback
    if($currentSub.Account.Type -ne "User")
    {
        Write-Host "Warning: This script can only be run by user account type." -ForegroundColor Yellow
        break;
    }

    # Safe Check: Current user need to be either UAA or Owner for the subscription
    $currentLoginRoleAssignments = Get-AzRoleAssignment -SignInName $currentSub.Account.Id -Scope "/subscriptions/$($SubscriptionId)";

    if(($currentLoginRoleAssignments | Where { $_.RoleDefinitionName -eq "Owner"  -or $_.RoleDefinitionName -eq 'CoAdministrator' -or $_.RoleDefinitionName -eq "User Access Administrator" } | Measure-Object).Count -le 0)
    {
        Write-Host "Warning: This script can only be run by an Owner/CoAdministrator/User Access Administrator." -ForegroundColor Yellow
        break;
    }

    Write-Host "Step 2 of 3: Check for presence of rollback file for Subscription: [$($SubscriptionId)]..."

    if (-not (Test-Path -Path $RollbackFilePath))
    {
        Write-Host "Warning: Rollback file is not found. Please check if the initial Remediation script has been run from the same machine. Exiting the process" -ForegroundColor Yellow
        break;        
    }
    $backedUpRoleAssingments = Get-Content -Raw -Path $RollbackFilePath | ConvertFrom-Json     

    Write-Host "Step 3 of 3: Restore role assignments [$($SubscriptionId)]..."
    
    $isRestored = $true
    
    $backedUpRoleAssingments | ForEach-Object {
        try
        {
            $roleAssignment = $_;
            New-AzRoleAssignment -ObjectId $roleAssignment.ObjectId -Scope $roleAssignment.Scope -RoleDefinitionName $roleAssignment.RoleDefinitionName -ErrorAction SilentlyContinue | Out-Null;    
            $roleAssignment | Select-Object -Property "DisplayName", "SignInName", "Scope"
        }
        catch 
        {
            $isRestored = $false
            Write-Host "Error occurred while restoring role assignments for Non AAD identities. ErrorMessage [$($_)]" -ForegroundColor Red
        }
    }
    
    if($isRestored)
    {
        Write-Host "Completed restoring role assignments for Non AAD identities." -ForegroundColor Green
    }
    else 
    {
        Write-Host "`n"
        Write-Host "Not able to successfully restore role assignments for Non AAD identities." -ForegroundColor Red   
    }
}

# ***************************************************** #
<#
Function calling with parameters.
Remove-AzTSNonAADAccountsRBAC -SubscriptionId '<Sub_Id>' -ObjectIds @('<Object_Ids>')  -Force:$false -PerformPreReqCheck: $true

Function to rollback role assignments as per input remediated log
Restore-AzTSNonAADAccountsRBAC -SubscriptionId '<Sub_Id>' -RollbackFilePath "<user Documents>\AzTS\Remediation\Subscriptions\<subscriptionId>\<JobDate>\NonAADAccounts\NonAADAccountsRoleAssignments.json"
Note: You can only rollback valid role assignments.
#>