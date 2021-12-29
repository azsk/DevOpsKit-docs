
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
    $userSelection = ""
    while ($userSelection -ne 'Y' -and $userSelection -ne 'N') {
        $userSelection = Read-Host "User choice"
        if (-not [string]::IsNullOrWhiteSpace($userSelection)) {
            $userSelection = $userSelection.Trim();
        }
    }
    return $userSelection;
}

function Delete_RoleAssignments {
    param ($AzskRoleAssignments)
    Write-Host "Deleting role assignments for AzSK CA SPNs..." 
    $azskRoleAssignments | Remove-AzRoleAssignment
}

function Remove-AzSKSPNAccess {
    <#
    .SYNOPSIS
    This command will remove access for AzSK/AzSDK deployed SPNs in subscription.Please make sure to confirm these SPNs are not used for other purpose prior to running this script.
    .DESCRIPTION
    This command will removing access for AzSK/AzSDK deployed SPNs in subscription.Please make sure to confirm these SPNs are not used for other purpose prior to running this script.
    .PARAMETER SubscriptionId
        Enter subscription id of the subscription for which access needs to be removed for AzSK/AzSDK SPNs.
    .PARAMETER Force
        Use this switch to avoid user confimration before deletion for role assignments.
    #>

    param (
        [string]
        [Parameter(Mandatory = $true, HelpMessage = "Enter subscription id for which AzSK SPN access to be removed")]
        $SubscriptionId,

        [switch]
        $force
    )

    Write-Host "======================================================"
    Write-Host "If you have access to the subscription using Privileged Identity Management(PIM), please make sure to elevate access before running the script." -ForegroundColor Yellow
    Write-Host "------------------------------------------------------"

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


    Write-Host "`nStep 1 of 3: Validating whether the current user [$($currentSub.Account.Id)] have the required permissions to run the script for Subscription [$($SubscriptionId)]..."

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

    # Declaring all AzSK and AzSDK SPN resources name/pattern
    $azskLocalSPNFormatString = "AzSK_CA_SPN_*"
    $azsdkLocalSPNFormatString = "AzSDK_CA_SPN_*"

    Write-Host "`nStep 2 of 3:Checking role assignments for subscription [$($SubscriptionId)] for AzSK SPNs..."
    # check subscription scope role assignments
    $azskSPNRoleAssignments = @()
    $azskSPNRoleAssignments += Get-AzRoleAssignment | Where-Object { ($_.DisplayName -Like $azskLocalSPNFormatString) -or ($_.DisplayName -Like $azsdkLocalSPNFormatString ) }
    
       
    if ($azskSPNRoleAssignments) {
        Write-Host "`tRole assignments for SPNs are:`n"
        $azskSPNRoleAssignments | Select-Object "DisplayName", "RoleDefinitionName", "Scope" | Format-Table
        Write-host "WARNING: Before deleting role assignments please make sure that AAD applications & SPNs are not used anywhere else." -ForegroundColor Yellow
        Write-Host "------------------------------------------------------"
        Write-Host "`nStep 3 of 3:Please confirm deletion of all above listed assignemnts: `n[Y]: Yes`n[N]: No" -ForegroundColor Cyan 
        $userChoice = ""
            
        $userChoice = Read_UserChoice
        if ($userChoice -eq 'Y') {
            try {
                Delete_RoleAssignments -AzskRoleAssignments $azskSPNRoleAssignments
                Write-Host "Successfully deleted role assignments for AzSK SPNs." -ForegroundColor Green
            }
            catch {
                Write-Host "ERROR: There was error while removing role assignments for AzSK SPNs." -ForegroundColor DarkYellow
            }
        }
        else {
            Write-Host "Skipped deletion for role assignments." -ForegroundColor Yellow
        }
    }
    else {
        Write-Host "No role assignemnts exists for AzSK SPNs." -ForegroundColor Green
    }        
}