function Pre_requisites
{
    Write-Host "Required modules are: Az.Resources, AzureAD, Az.Account" -ForegroundColor Cyan
    Write-Host "Checking for required modules..."
    $availableModules = $(Get-Module -ListAvailable Az.Resources, AzureAD, Az.Accounts)
    
    # Checking if 'Az.Accounts' module is available or not.
    if($availableModules.Name -notcontains 'Az.Accounts')
    {
        Write-Host "Installing module Az.Accounts..." -ForegroundColor Yellow
        Install-Module -Name Az.Accounts -Scope CurrentUser
    }
    else
    {
        Write-Host "Az.Resources module is available." -ForegroundColor Green
    }

    # Checking if 'Az.Resources' module is available or not.
    if($availableModules.Name -notcontains 'Az.Resources')
    {
        Write-Host "Installing module Az.Resources..." -ForegroundColor Yellow
        Install-Module -Name Az.Resources -Scope CurrentUser
    }
    else
    {
        Write-Host "Az.Resources module is available." -ForegroundColor Green
    }

    # Checking if 'AzureAD' module is available or not.
    if($availableModules.Name -notcontains 'AzureAD')
    {
        Write-Host "Installing module AzureAD..." -ForegroundColor Yellow
        Install-Module -Name AzureAD -Scope CurrentUser
    }
    else
    {
        Write-Host "AzureAD module is available." -ForegroundColor Green
    }
}


function RemoveInvalidAADAccounts
{
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
    Write-Host "Starting with removal of invalid AAD object guids from subscriptions..."
    Write-Host "------------------------------------------------------"

    if($PerformPreReqCheck)
    {
       Write-Host "Checking for pre-requisites..."
       Pre_requisites
       Write-Host "------------------------------------------------------"
    }

    # Setting context for current subscription.
    $currentSub = Set-AzContext -SubscriptionId $SubscriptionId

    

    Write-Host "Metadata Details: `n SubscriptionId: [$($SubscriptionId)] `n AccountName: [$($currentSub.Account.Id)] `n AccountType: [$($currentSub.Account.Type)]"
    Write-Host "------------------------------------------------------"
    Write-Host "Starting with Subscription [$($SubscriptionId)]..."


    Write-Host "Step 1 of 6: Validating whether the current user [$($currentSub.Account.Id)] have the required permissions to run the script for Subscription [$($SubscriptionId)]..."

    # Safe Check: Checking whether the current account is of type User and also grant the current user as UAA for the sub to support fallback
    if($currentSub.Account.Type -ne "User")
    {
        Write-Host "Warning: This script can only be run by user account type." -ForegroundColor Yellow
        exit;
    }

    # Safe Check: Current user need to be either UAA or Owner for the subscription
    $currentLoginRoleAssignments = Get-AzRoleAssignment -SignInName $currentSub.Account.Id -Scope "/subscriptions/$($SubscriptionId)";

    if(($currentLoginRoleAssignments | Where { $_.RoleDefinitionName -eq "Owner"  -or $_.RoleDefinitionName -eq 'CoAdministrator' -or $_.RoleDefinitionName -eq "User Access Administrator" } | Measure-Object).Count -le 0)
    {
        Write-Host "Warning: This script can only be run by an Owner or User Access Administrator" -ForegroundColor Yellow
        exit;
    }

    #  Safe Check: saving the current login user object id to ensure we dont remove this during the actual removal
    $currentLoginUserObjectIdArray = @()
    $currentLoginUserObjectId = "";
    $currentLoginUserObjectIdArray += $currentLoginRoleAssignments | select ObjectId -Unique
    if(($currentLoginUserObjectIdArray | Measure-Object).Count -gt 0)
    {
        $currentLoginUserObjectId = $currentLoginUserObjectIdArray[0].ObjectId;
    }
        
    Write-Host "Step 2 of 6: Fetching all the role assignments for Subscription [$($SubscriptionId)]..."

    #  Getting all role assignments of subscription.
    $currentRoleAssignmentList = Get-AzRoleAssignment -IncludeClassicAdministrators  
    $distinctObjectIds = @();

    if(($ObjectIds | Measure-Object).Count -eq 0)
    {
        $currentRoleAssignmentList | select -Unique -Property 'ObjectId' | ForEach-Object { $distinctObjectIds += $_.ObjectId}
    }
    else
    {
        $distinctObjectIds += $ObjectIds
    }

    Write-Host "Step 3 of 6: Resolving all the AAD ObjectGuids against Tenant. Number of distinctObjectGuids [$($distinctObjectIds.Count)]..."
    # Connect to Azure Active Directory.
    Write-Host "Connecting to Azure AD..."
    Connect-AzureAD

    # Batching object ids in count of 900.
    $activeIdentities = @();
    for( $i = 0; $i -lt $distinctObjectIds.Length; $i = $i + 900)
    {
        if($i + 900 -lt $distinctObjectIds.Length)
        {
            $endRange = $i + 900
        }
        else
        {
            $endRange = $distinctObjectIds.Length -1;
        }

        $subRange = $distinctObjectIds[$i..$endRange]

        # Getting active identities from Azure Active Directory.
        $subActiveIdentities = Get-AzureADObjectByObjectId -ObjectIds $subRange
        # Safe Check 
        if(($subActiveIdentities | Measure-Object).Count -le 0)
        {
            #if the active identities count has come as Zero, then API might have failed.  Print Warning and abort the execution
            Write-Host "Warning: Graph API hasnt returned any active account. Current principal dont have access to Graph or Graph API is throwing error. Aborting the operation. Reach out to aztssup@microsoft.com" -ForegroundColor Yellow
            exit;
        }
        $activeIdentities += $subActiveIdentities.ObjectId
    } 

    $folderPath = [Environment]::GetFolderPath("MyDocuments") 
    if (Test-Path -Path $folderPath)
    {
        New-Item -ItemType Directory -Path $folderPath -Name 'InvalidAADAccounts\Subscriptions'
        $folderPath += '\InvalidAADAccounts\Subscriptions\'
    }
    Write-Host "Step 4 of 6: Taking backup of current role assignments at [$($folderPath)]..."
    # Safe Check: Taking backup of active identities    
    if ($activeIdentities.Length -gt 0)
    {
        $activeIdentities | ConvertTo-Json | Out-File "$($folderPath)\RoleAssignments_$($SubscriptionId.Replace("-","_")).json"
        Write-Host "Following identities are present in Azure Active Directory: "
        $activeIdentities | Select SignInName, DisplayName, RoleDefinitionName, ObjectType, ObjectId, Scope | FT | Out-String
        Write-Host "Excluding above active identities from invalid AAD account identities..." -ForegroundColor "Yellow"
    }

    $invalidAADObjectIds = $distinctObjectIds | Where-Object { $_ -notin $activeIdentities}

    # Get list of all invalidAADObject guid assignments followed by object ids.
    $invalidAADObjectRoleAssignments = $currentRoleAssignmentList | Where-Object {  $invalidAADObjectIds -contains $_.ObjectId}

    #checking the RBAC permissions for current user. Current users need to be Owner/UAA/Co-admin to delete role assignments.
    $currentRole = @()
    $currentRole = $currentRoleAssignmentList | Where-Object { $_.SignInName -eq $currentSub.Account -and $_.Scope -eq "/subscriptions/$($SubscriptionId)"} | Select-Object RoleDefinitionName

    Write-Host "List of invalid AAD Object Guid accounts:" -ForegroundColor Cyan
    $invalidAADObjectRoleAssignments | Select SignInName, DisplayName, RoleDefinitionName, ObjectType, ObjectId, Scope | FT | Out-String

    if(-not $Force)
    {
        Write-Host "Do you want to delete the above listed role assignment? " -ForegroundColor Yellow -NoNewline
        $UserInput = Read-Host -Prompt "(Y|N)"

        if($UserInput -ne "Y")
        {
            exit;
        }
    }

    # Safe Check: Check whether the current user accountId is part of Invalid AAD ObjectGuids List 
    if(($invalidAADObjectIds | where { $_.ObjectId -eq $currentLoginUserObjectId} | Measure-Object).Count -gt 0)
    {
        Write-Host "Warning: Current User account is found as part of the Invalid AAD ObjectGuids collection. This is not expected behaviour. This can happen typically during Graph API failures. Aborting the operation. Reach out to aztssup@microsoft.com" -ForegroundColor Yellow
        exit;
    }
    Write-Host "Step 5 of 6: Clean up invalid object guids for Subscription [$($SubscriptionId)]..."
    # Start deletion of all Invalid AAD ObjectGuids.
    Write-Host "Starting to delete invalid AAD object guid role assignments..." -ForegroundColor Cyan
    $invalidAADObjectRoleAssignments | Remove-AzRoleAssignment -Verbose
    Write-Host "Completed deleting Invalid AAD ObjectGuids role assignments." -ForegroundColor Green

    Write-Host "Step 6 of 6: Generating the log file with all the cleaned up invalid object guids for Subscription [$($SubscriptionId)]..."
        # Safe Check: Taking backup of Invalid AAD ObjectGuids Roleassignments 
    $invalidAADObjectRoleAssignments | ConvertTo-Json | Out-File "$($folderPath)\InvalidAADObjectRoleAssignments_$($SubscriptionId.Replace("-","_")).json"
}

# ***************************************************** #

# Function calling with parameters.
RemoveInvalidAADAccounts -SubscriptionId '<Sub Id>' -ObjectIds @('<List of obj ids>')  -Force:$false 
