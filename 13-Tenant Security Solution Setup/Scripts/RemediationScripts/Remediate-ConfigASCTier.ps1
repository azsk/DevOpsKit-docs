function Pre_requisites
{
    <#
    .SYNOPSIS
    This command would check pre requisities modules.
    .DESCRIPTION
    This command would check pre requisities modules to perform remediation.
	#>

    Write-Host "Required modules are: Az.Resources, Az.Security, Az.Account" -ForegroundColor Cyan
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
    if($availableModules.Name -notcontains 'Az.Security')
    {
        Write-Host "Installing module Az.Security..." -ForegroundColor Yellow
        Install-Module -Name Az.Security -Scope CurrentUser
    }
    else
    {
        Write-Host "Az.Security module is available." -ForegroundColor Green
    }
}

function Remediate-ConfigASCTier
{
    <#
    .SYNOPSIS
    This command would help in remediating 'Azure_Subscription_Config_ASC_Tier' control.
    .DESCRIPTION
    This command would help in remediating 'Azure_Subscription_Config_ASC_Tier' control.
    .PARAMETER SubscriptionId
        Enter subscription id on which remediation need to perform.
    .PARAMETER PerformPreReqCheck
        Perform pre requisities check to ensure all required module to perform roll back operation is available.
    #>

    param (
        [string]
        [Parameter(Mandatory = $true, HelpMessage="Enter subscription id for remediation")]
        $SubscriptionId,

        [switch]
        $PerformPreReqCheck
    )

    Write-Host "======================================================"
    Write-Host "Starting to remediate config ASC tier for subscription [$($SubscriptionId)]..."
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
            Exit
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

    Write-Host "Metadata Details: `n SubscriptionId: [$($SubscriptionId)] `n AccountName: [$($currentSub.Account.Id)] `n AccountType: [$($currentSub.Account.Type)]"
    Write-Host "------------------------------------------------------"
    Write-Host "Starting with Subscription [$($SubscriptionId)]..."


    Write-Host "Step 1 of 3: Validating whether the current user [$($currentSub.Account.Id)] have the required permissions to run the script for Subscription [$($SubscriptionId)]..."

    # Safe Check: Checking whether the current account is of type User
    if($currentSub.Account.Type -ne "User")
    {
        Write-Host "Warning: This script can only be run by user account type." -ForegroundColor Yellow
        exit;
    }

    # Safe Check: Current user need to be either Contributor or Owner for the subscription
    $currentLoginRoleAssignments = Get-AzRoleAssignment -SignInName $currentSub.Account.Id -Scope "/subscriptions/$($SubscriptionId)";

    if(($currentLoginRoleAssignments | Where { $_.RoleDefinitionName -eq "Owner"  -or $_.RoleDefinitionName -eq 'Contributor' } | Measure-Object).Count -le 0)
    {
        Write-Host "Warning: This script can only be run by an Owner or Contributor of subscription [$($SubscriptionId)] " -ForegroundColor Yellow
        exit;
    }

    # Declaring required ASC type and pricing tier
    $reqASCTierResourceTypes = "VirtualMachines","SqlServers","AppServices","StorageAccounts","KubernetesService","ContainerRegistry","KeyVaults","SqlServerVirtualMachines";		
    $reqASCTier = "Standard";
    $reqProviderName = "Microsoft.Security"
    $isProviderRegister = $true

    # Checking IsProviderRegister with 'Microsoft.Security' provider
    $registeredProvider =  Get-AzResourceProvider -ListAvailable | Where-Object { $_.RegistrationState -eq "Registered" -and $_.ProviderNamespace -eq $reqProviderName }

    if($null -eq $registeredProvider)
    {
        # capture provider registration state
        $isProviderRegister = $false
        Write-Host "Found [$($reqProviderName)] provider is not registered."
        Write-Host "$reqProviderName registering [It takes 2-3 min to get registered]..."
        # Registering provider with required provider name, it will take 1-2 min for registration
        try 
        {
            Register-AzResourceProvider -ProviderNamespace $reqProviderName
            while((Get-AzResourceProvider -ListAvailable | Where-Object { $_.ProviderNamespace -eq $reqProviderName }).RegistrationState -ne "Registered")
            {
                Start-Sleep -Seconds 10
                Write-Host "$reqProviderName registering..." -ForegroundColor Yellow
            }    
        }
        catch 
        {
            Write-Host "Error Occured while registering $reqProviderName provider. ErrorMessage [$($_)]" -ForegroundColor Red
            exit
        }
        Write-Host "$reqProviderName provider successfully registered." -ForegroundColor Green
    }

    Write-Host "Step 2 of 3: Checking [$($reqASCTier)] pricing tier for [$($reqASCTierResourceTypes)] ASC type..."
    $nonCompliantASCTierResourcetype = @()
    $nonCompliantASCTierResourcetype = Get-AzSecurityPricing | Where-Object { $_.PricingTier -ne $reqASCTier -and $reqASCTierResourceTypes.Contains($_.Name) }

    $nonCompliantASCTypeCount = ($nonCompliantASCTierResourcetype | Measure-Object).Count

    Write-Host "Found [$($nonCompliantASCTypeCount)] ASC type without [$($reqASCTier)]"

    # Creating data object for ASC type without 'Standard' pricing tier to export into json, it will help while doing roll back opeartion. 
    $nonCompliantASCResource =  New-Object psobject -Property @{
            SubscriptionId = $SubscriptionId 
            IsProviderRegister = $isProviderRegister
        }
    $nonCompliantASCResource | Add-Member -Name 'NonCompliantASCType' -Type NoteProperty -Value $nonCompliantASCTierResourcetype

    # Creating the log file
    $folderPath = [Environment]::GetFolderPath("MyDocuments") 
    if (Test-Path -Path $folderPath)
    {
        $folderPath += "\AzTS\Remediation\Subscriptions\$($subscriptionid.replace("-","_"))\$((Get-Date).ToString('yyyyMMdd_hhmm'))\ConfigASCTier"
        New-Item -ItemType Directory -Path $folderPath | Out-Null
    }

    Write-Host "Step 3 of 3: Taking backup of ASC type without [Standard] tier and [$($reqProviderName)] provider registration status. Please do not delete this file. Without this file you wont be able to rollback any changes done through Remediation script." -ForegroundColor Cyan
    $nonCompliantASCResource | ConvertTo-json | out-file "$($folderpath)\NonCompliantASCType.json"  
    Write-Host "Path: $($folderpath)\NonCompliantASCType.json"     
    Write-Host "`n"

    # Performing remediation
    if($nonCompliantASCTypeCount -gt 0)
    {
        try 
        {
            Write-Host "Setting [$($reqASCTier)] pricing tier..."
            $nonCompliantASCTierResourcetype | ForEach-Object {
                (Set-AzSecurityPricing -Name $_.Name -PricingTier $reqASCTier) | Select-Object -Property Id, Name, PricingTier
            }
        }
        catch 
        {
            Write-Host "Error occurred while setting $reqASCTier pricing tier. ErrorMessage [$($_)]" -ForegroundColor Red 
            exit
        }
        Write-Host "Successfuly set [$($reqASCTier)] pricing tier for non compliant ASC type [$($nonCompliantASCTierResourcetype)]" -ForegroundColor Green
        Write-Host "======================================================"
    }
    else
    {
        Write-Host "Required ASC type compliant with [$($reqASCTier)] pricing tier." -ForegroundColor Green
        Write-Host "======================================================"
        exit   
    }
}


function RollBack-ConfigASCTier
{
    <#
    .SYNOPSIS
    This command would help in remediating 'Azure_Subscription_Config_ASC_Tier' control.
    .DESCRIPTION
    This command would help in remediating 'Azure_Subscription_Config_ASC_Tier' control.
    .PARAMETER SubscriptionId
        Enter subscription id on which remediation need to perform.
    .PARAMETER PerformPreReqCheck
        Perform pre requisities check to ensure all required module to perform roll back operation is available.
    #>

    param (
        [string]
        [Parameter(Mandatory = $true, HelpMessage="Enter subscription id to perform roll back operation")]
        $SubscriptionId,

        [string]
        [Parameter(Mandatory = $true, HelpMessage="Json file path which contain logs generated by remediation script to roll back remediation changes")]
        $Path,

        [switch]
        $PerformPreReqCheck
    )

    Write-Host "======================================================"
    Write-Host "Starting to roll back operation to config ASC tier for subscription [$($SubscriptionId)]..."
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
            Exit
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

    

    Write-Host "Metadata Details: `n SubscriptionId: [$($SubscriptionId)] `n AccountName: [$($currentSub.Account.Id)] `n AccountType: [$($currentSub.Account.Type)]"
    Write-Host "------------------------------------------------------"
    Write-Host "Starting with Subscription [$($SubscriptionId)]..."


    Write-Host "Step 1 of 3: Validating whether the current user [$($currentSub.Account.Id)] have the required permissions to run the script for Subscription [$($SubscriptionId)]..."

    # Safe Check: Checking whether the current account is of type User
    if($currentSub.Account.Type -ne "User")
    {
        Write-Host "Warning: This script can only be run by user account type." -ForegroundColor Yellow
        exit;
    }

    # Safe Check: Current user need to be either Contributor or Owner for the subscription
    $currentLoginRoleAssignments = Get-AzRoleAssignment -SignInName $currentSub.Account.Id -Scope "/subscriptions/$($SubscriptionId)";

    if(($currentLoginRoleAssignments | Where { $_.RoleDefinitionName -eq "Owner"  -or $_.RoleDefinitionName -eq 'Contributor' } | Measure-Object).Count -le 0)
    {
        Write-Host "Warning: This script can only be run by an Owner or Contributor of subscription [$($SubscriptionId)] " -ForegroundColor Yellow
        exit;
    }

    Write-Host "`n"
    Write-Host "Step 2 of 3: Fetching remediation log to perform roll back operation to config ASC tier for Subscription [$($SubscriptionId)]..."
 
    # Array to store resource context
    if (-not (Test-Path -Path $Path))
    {
        Write-Host "Warning: Rollback file is not found. Please check if the initial Remediation script has been run from the same machine. Exiting the process" -ForegroundColor Yellow
        exit;        
    }

    # Declaring required ASC type and pricing tier
    $reqASCTier = "Standard";
    $reqProviderName = "Microsoft.Security"
    $remediatedLog = Get-Content -Raw -Path $Path | ConvertFrom-Json

    Write-Host "Step 3 of 3: Performing roll back operation to config ASC tier for subscription [$($SubscriptionId)]..."
        
    # Performing roll back operation
    try
    {
        if(($remediatedLog | Measure-Object).Count -gt 0)
        {
            Write-Host "Configuring ASC tier as per remediation log on subscription [$($SubscriptionId)]..."
            
            # Checking current registration state of provider i.e. 'Microsoft.Security' on subscription.
            $isProviderRegister = (Get-AzResourceProvider -ListAvailable | Where-Object { $_.ProviderNamespace -eq $reqProviderName }).RegistrationState -ne "Registered"

            if($remediatedLog.IsProviderRegister -eq $isProviderRegister)
            {
                Write-Host "[$($reqProviderName)] provider registration state is same as before executing remediation script is same. No Action required to roll back." -ForegroundColor Green
                Write-Host "======================================================"
            }
            else 
            {
                # when current provider registration state and before executing remediation script is not same.
                # That means while doing remediation it got registered, to perform roll back we need to unregister it
                Write-Host "$reqProviderName provider name was registered before executing remediation script, performing roll back."
                Write-Host "$reqProviderName unregistering..."
                try 
                {
                    Unregister-AzResourceProvider -ProviderNamespace $reqProviderName
                }
                catch 
                {
                    Write-Host "Error Occured while unregistering $reqProviderName provider. ErrorMessage [$($_)]" -ForegroundColor Red
                }
                Write-Host "$reqProviderName provider successfully unregistered." -ForegroundColor Green
                Write-Host "======================================================"
            }

            if($null -ne $remediatedLog.NonCompliantASCType -and ($remediatedLog.NonCompliantASCType | Measure-Object).Count -gt 0)
            {
                try 
                {
                    $remediatedLog.NonCompliantASCType | ForEach-Object {
                        (Set-AzSecurityPricing -Name $_.Name -PricingTier $_.PricingTier) | Select-Object -Property Id, Name, PricingTier
                    }    
                }
                catch 
                {
                    Write-Host "Error occurred while performing roll back operation to configure ASC tier. ErrorMessage [$($_)]" -ForegroundColor Red 
                    exit      
                }

                Write-Host "Roll back operation successfully performed." -ForegroundColor Green
                Write-Host "======================================================"
            }
            else 
            {
                Write-Host "Non compliant ASC type not found to perform roll back operation." -ForegroundColor Green
                exit
                Write-Host "======================================================"
            }
        }
        else 
        {
            Write-Host "ASC tier details not found to perform roll back operation."
            Write-Host "======================================================"
            exit
        }
    }
    catch
    {
        Write-Host "Error occurred while performing roll back operation to configure ASC tier. ErrorMessage [$($_)]" -ForegroundColor Red 
        exit
    }
}

<#
# ***************************************************** #
# Function calling with parameters for remediation.
Remediate-ConfigASCTier -SubscriptionId '<Sub_Id>' -PerformPreReqCheck: $true

# Function calling with parameters to roll back remediation changes.
RollBack-ConfigASCTier -SubscriptionId '<Sub_Id>' -Path '<Json file path containing Remediated log>' -PerformPreReqCheck: $true
#>


