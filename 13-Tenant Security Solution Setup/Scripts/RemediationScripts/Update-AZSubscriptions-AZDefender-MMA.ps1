<#
.SYNOPSIS

Updates an Azure Subscription for Azure Defender and MMA.

.DESCRIPTION

This script should be used to update Azure Subscriptions to enable Azure Defender and MMA.

.PARAMETER interactiveMode
Specifies whether this should be executed in interactive mode. (prompting for user action on individual subscriptions)

Accepted vaules are: 1, true, yes, on, enabled.
If not provided, it will executes in unattended mode.

.EXAMPLE

PS> .\Update-AZSubscriptions-AZDefender-MMA.ps1

or

PS> .\Update-AZSubscriptions-AZDefender-MMA.ps1 -interactiveMode yes

for interactive mode.
#>

Param (
            [parameter(position=0)] [string]$interactiveMode
)

# Check for valid regex patterns in a string and cast it into a boolean.
switch -regex ($interactiveMode.Trim())
{
    "^(1|true|yes|on|enabled)$" { [bool]$interactiveMode = $true }
     default { [bool]$interactiveMode = $false }
}

$subscriptions = @();
$subscriptions += Get-AzSubscription

if(($subscriptions | Measure-Object).Count -gt 0)
{
    foreach($sub in $subscriptions)
    {        
        Write-Host "============================================="; 
        Write-Host "Started for SubscriptionId [$($sub)]" -ForegroundColor Cyan
        if($interactiveMode)
        {
            $response = Read-Host "Do you want to continue with the Sub: [$($sub)] ? (Y/N)"
            if($response -eq "N")
            {
                Write-Host "Skipped for SubscriptionId [$($sub)]" -ForegroundColor Yellow
                continue;                
            }
        }        
        Write-Host "--------------------------------------------"; 
        Write-Host "`tStarting with updating defender plans to Standard" -ForegroundColor Cyan
        
        # Get current pricing tier 
        $ascpricing = Get-AzSecurityPricing 
        if(($ascpricing | Measure-Object).Count -gt 0)
        {                        
            $ascpricing | Where-Object { $_.PricingTier -ne "Standard" } | ForEach-Object { Set-AzSecurityPricing -Name $_.Name -PricingTier Standard }
            Write-Host "`tCompleted updating defender plans to Standard" -ForegroundColor Green
        }
        else
        {
            Write-Host "`tNot able to fetch the ASC Pricing details" -ForegroundColor Red
        }
        Write-Host "--------------------------------------------"; 
        # 2)  Set auto provisioning for extensions in Azure Security Center. This script will set a single subscription for the current context
        Write-Host "`tStarting to update auto-provision settings to On" -ForegroundColor Cyan
        Set-AzSecurityAutoProvisioningSetting -Name "default" -EnableAutoProvision
        Write-Host "`tCompleted updating auto-provision settings to On" -ForegroundColor Green

        Write-Host "Completed updating for SubscriptionId [$($sub)]" -ForegroundColor Green

    }
    Write-Host "============================================="; 
}
else
{
    Write-Host "No subscription(s) found." -ForegroundColor Red
}