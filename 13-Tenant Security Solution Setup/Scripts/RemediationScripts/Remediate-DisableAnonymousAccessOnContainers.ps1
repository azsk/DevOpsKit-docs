﻿function Pre_requisites
{
    Write-Host "Required modules are: Az.Account, Az.Resources, Az.Storage" -ForegroundColor Cyan
    Write-Host "Checking for required modules..."
    $availableModules = $(Get-Module -ListAvailable Az.Resources, Az.Accounts)
    
    # Checking if 'Az.Accounts' module is available or not.
    if($availableModules.Name -notcontains 'Az.Accounts')
    {
        Write-Host "Installing module Az.Accounts..." -ForegroundColor Yellow
        Install-Module -Name Az.Accounts -Scope CurrentUser
    }
    else
    {
        Write-Host "Az.Accounts module is available." -ForegroundColor Green
    }
    
    # Checking if 'Az.Storage' module is available or not.
    if($availableModules.Name -notcontains 'Az.Storage')
    {
        Write-Host "Installing module Az.Storage..." -ForegroundColor Yellow
        Install-Module -Name Az.Storage -Scope CurrentUser
    }
    else
    {
        Write-Host "Az.Storage module is available." -ForegroundColor Green
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
}


function Remediate-DisableAnonymousAccessOnContainers
{
    param (
        [string]
        [Parameter(Mandatory = $true, HelpMessage="Enter subscription id on which remediation need to perform")]
        $SubscriptionId,

        [string]
        [Parameter(Mandatory = $false, HelpMessage="Json file path which contain failed controls detail to remediate")]
        $ControlFilePath,

        [switch]
        $RemediateForAllStorageAccount,

        [switch]
        $PerformPreReqCheck
    )

    if($RemediateForAllStorageAccount -eq $false -and [string]::IsNullOrWhiteSpace($ControlFilePath))
    {
        Write-Host "Required Parameter not found to perform remediation." -ForegroundColor Red
        Write-Host "Please check for control file path otherwise use switch RemediateForAllStorageAccount as value 'true' to perform remediation on all storage account for Subscription [$($SubscriptionId)]" -ForegroundColor Red
        exit;
    }


    Write-Host "======================================================"
    Write-Host "Starting to disable anonymous access on containers of storage account for subscription."
    Write-Host "------------------------------------------------------"

    if($PerformPreReqCheck)
    {
       Write-Host "Checking for pre-requisites..."
       Pre_requisites
       Write-Host "------------------------------------------------------"
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

    # Safe Check: Checking whether the current account is of type User and also grant the current user as UAA for the sub to support fallback
    if($currentSub.Account.Type -ne "User")
    {
        Write-Host "Warning: This script can only be run by user account type." -ForegroundColor Yellow
        exit;
    }
    Write-Host "`n"
    Write-Host "*** To perform remediation for disabling anonymous access on containers user must have atleast contributor access on storage account of Subscription: [$($SubscriptionId)] on which remediation need to perform ***" -ForegroundColor Yellow
    Write-Host "`n"  
    #  Getting all storage account with anonymous access on containers of Subscription.
        
        Write-Host "Disabling anonymous access on all containers on storage...";
        Write-Host "------------------------------------------------------"
        
        # Array to store resource context
        $resourceContext = @()

        if($RemediateForAllStorageAccount)
        {
            $resourceContext = (Get-AzStorageAccount).context
        }
        else{
            if (-not (Test-Path -Path $ControlFilePath))
            {
                Write-Host "Error: Control file path is not found." -ForegroundColor Red
                exit;        
            }

            # Fetching failed controls details from given json file.
            $ControlIds = "Azure_Storage_AuthN_Dont_Allow_Anonymous"
            $controlForRemediation = Get-content -path $ControlFilePath | ConvertFrom-Json
            # $SubscriptionId = $controlForRemediation.SubscriptionId
            $controls = $controlForRemediation.FailedControlSet

            $resourceDetails = $controls | Where-Object { $ControlIds -eq $_.ControlId};

            if(($resourceDetails | Measure-Object).Count -eq 0)
            {
                Write-Host "No control found in input json file for remedition." -ForegroundColor Red
                exit;
            }
            $resourceDetails.ResourceDetails | ForEach-Object { 
                                $resourceContext += Get-AzStorageAccount -Name $_.ResourceName -ResourceGroupName $_.ResourceGroupName    
                            }
        }
        


        # Performing remediation

        try{
        if($resourceContext)
		{
            $ContainersWithAnonymousAccessOnStorage = @();
            $ContainersWithDisableAnonymousAccessOnStorage = @();
            $resourceContext | ForEach-Object{
                $flag = $true
                $allContainers = @();
                $containersWithAnonymousAccess = @();
                $anonymousAccessContainersNameAndPublicAccess = @();
				$context = $_.context;
	    		$allContainers += Get-AzStorageContainer -Context $context -ErrorAction Stop
                if($allContainers.Count -ne 0)
			    {
                    $containersWithAnonymousAccess += $allContainers | Where-Object { $_.PublicAccess -ne "Off"}
                    $containersWithAnonymousAccess | ForEach-Object {
                        try
                        {
                            Set-AzStorageContainerAcl -Name $_.Name -Permission Off -Context $context
                            
                            # Creating object with container name and type of public access
                            $item =  New-Object psobject -Property @{  
                                    Name = $_.Name                
                                    PublicAccess = $_.PublicAccess
                                }
                                $anonymousAccessContainersNameAndPublicAccess += $item

                        }
                        catch
                        {
                            $flag = $false
                            break;    
                        }
                        
			    	};
                
                    # Successfully disabled anonymous access on storage account.
                    if($flag)
                    {
                        Write-Host "Anonymous access has been disabled on all containers on storage [Name]: [$($_.StorageAccountName)] [ResourceGroupName]: [$($_.ResourceGroupName)]";
                        $item =  New-Object psobject -Property @{  
                            SubscriptionId = $SubscriptionId
                            ResourceGroupName = $_.ResourceGroupName
                            ResourceName = $_.StorageAccountName
                            ResourceId = $_.id
                            }

                            # Adding array of container name and public access
                            $item | Add-Member -Name 'ContainersWithAnonymousAccess' -Type NoteProperty -Value $anonymousAccessContainersNameAndPublicAccess;
                            $ContainersWithDisableAnonymousAccessOnStorage += $item
                    }
                    else
                    {
                    # Unable to disable containers anonymous access may be because of insufficient permission over storage account
                        $item =  New-Object psobject -Property @{
                            SubscriptionId = $SubscriptionId  
                            ResourceName = $_.StorageAccountName
                            ResourceGroupName = $_.ResourceGroupName
                            ResourceId = $_.id
                        }

                        $ContainersWithAnonymousAccessOnStorage += $item
                    }
                }
                else
			    {
                    Write-Host "There are no containers on storage account which have anonymous access enabled [Name]: [$($_.StorageAccountName)]";
			    }	
        }
    }
    else
		{
			Write-Host "Unable to fetch storage account";
		}
    }
    catch
    {
        Write-Host "Error occured while remediating control. ErrorMessage [$($_)]" -ForegroundColor Red
    }

    # Creating the log file
    $folderPath = [Environment]::GetFolderPath("MyDocuments") 
    if (Test-Path -Path $folderPath)
    {
        $folderPath += "\AzTS\Remediation\Subscriptions\$($subscriptionid.replace("-","_"))\$((Get-Date).ToString('yyyyMMdd_hhmm'))\DisableAnonymousAccessOnContainers"
        New-Item -ItemType Directory -Path $folderPath | Out-Null
    }

    Write-Host "------------------------------------------------------"
    if(($ContainersWithDisableAnonymousAccessOnStorage | Measure-Object).Count -ge 1)
      {
         Write-Host "Taking backup of storage account details for Subscription: [$($SubscriptionId)] on which remediation is successfully performed. Please do not delete this file. Without this file you wont be able to rollback any changes done through Remediation script." -ForegroundColor Cyan
         $ContainersWithDisableAnonymousAccessOnStorage | ConvertTo-Json -Depth 10| Out-File "$($folderPath)\ContainersWithDisableAnonymousAccessOnStorage.json"
         Write-Host "Path: $($folderPath)\ContainersWithDisableAnonymousAccessOnStorage.json"
      }

    if(($ContainersWithAnonymousAccessOnStorage | Measure-Object).Count -ge 1)
      {
         Write-Host "`n"
         Write-Host "Generating the log file containing details of all the storage account in which remediating script unable to disable containers anonymous access due to in sufficient permission over storage account for Subscription: [$($SubscriptionId)]..."
         $ContainersWithAnonymousAccessOnStorage | ConvertTo-Json -Depth 10 | Out-File "$($folderPath)\ContainersWithAnonymousAccessOnStorage.json"
         Write-Host "Path: $($folderPath)\ContainersWithAnonymousAccessOnStorage.json"
         Write-Host "======================================================"
      }

}



# ***************************************************** #

# Function calling with parameters.
Remediate-DisableAnonymousAccessOnContainers -SubscriptionId '<Sub_Id>' -ControlFilePath "Enter json file containing failed storage accounts for remediation" -RemediateForAllStorageAccount: $false -PerformPreReqCheck: $true

