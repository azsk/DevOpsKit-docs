
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

function Delete_RoleAssignments
{
    param ($AzskRoleAssignments)

    Write-Host "Deleting role assignments of AzSK CA SPN..." 
    $azskRoleAssignments | Remove-AzRoleAssignment
    Write-Host "Successfully deleted role assignment of AzSK CA SPN." -ForegroundColor Green
}



function Remove-AzSKSPNAccess
{
    <#
    .SYNOPSIS
    This command would help in removing access for AzSK deployed SPNs in subscription.Please make sure to confirm these SPNs are not used for other purpose prior to running this script.
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
    [Parameter(Mandatory = $true, HelpMessage="Enter subscription id for which AzSK SPN access to be removed")]
    $SubscriptionId,

    [switch]
    $PerformPreReqCheck,

    [switch]
    $Force
    )

    Write-Host "======================================================"
    Write-Host "If you have access to the subscription using Privileged Identity Management(PIM), please make sure to elevate access before running the script." -ForegroundColor Yellow
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
    $azskLocalSPNFormatString = "AzSK_CA_SPN_*"

    Write-Host "`nStep 2 of 3:Checking role assignments for subscription [$($SubscriptionId)] for AzSK SPNs..."
    # check subscription scope 'reader' role assignment
    $azskSPNRoleAssignments += Get-AzRoleAssignment |Where-Object -Property DisplayName -Like $azskLocalSPNFormatString 

       
        if($azskSPNRoleAssignments)
        {
            Write-Host "`tRole assignments for SPN:"
            $azskSPNRoleAssignments | Select-Object "DisplayName", "RoleDefinitionName", "Scope" | Format-Table
            Write-host "WARNING: Before deleting role assignments please make sure that this AAD application & SPN is not used anywhere else." -ForegroundColor Yellow
            Write-Host "------------------------------------------------------"
            Write-Host "`nPlease confirm deletion of all above assignemnts: `n[Y]: Yes`n[N]: No" -ForegroundColor Cyan 
             $userChoice=""
             if($force)
                    {
                        $userChoice="Y" # No further user consent required as 'Force' switch is enabled
                    }
                    else
                    {
                        $userChoice = Read_UserChoice
                    }
                        if($userChoice -eq 'Y')
                        {
                            try
                            {
                                Delete_RoleAssignments -AzskRoleAssignments $azskSPNRoleAssignments
                                $roleAssignmentRemoved = $true
                            }
                            catch
                            {
                                Write-Host "ERROR: There was some error while removing role assignment for AzSK SPNs." -ForegroundColor DarkYellow
                            }
                        }
                        else
        {
            Write-Host "Skipped deletion for role assignments." -ForegroundColor Yellow
        }

        }
        else
        {
            Write-Host "No role assignemnts exists for AzSK deployed SPNs." -ForegroundColor Green
        }

        
}