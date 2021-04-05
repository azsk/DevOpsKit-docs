﻿function Pre_requisites
{
    Write-Host "Required modules are: Az.Resources, Az.Account" -ForegroundColor Cyan
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
}


function Remediate-DisableAnonymousAccessOnContainers
{
    param (
        [string]
        [Parameter(Mandatory = $true, HelpMessage="Json file path which contain failed controls detail to remediate")]
        $ControlFilePath,
        
        [switch]
        $PerformPreReqCheck
    )

    Write-Host "======================================================"
    Write-Host "Starting to disable anonymous access on containers of storage account for subscription: [$($SubscriptionId)]..."
    Write-Host "------------------------------------------------------"

    if($PerformPreReqCheck)
    {
       Write-Host "Checking for pre-requisites..."
       Pre_requisites
       Write-Host "------------------------------------------------------"
    }

    # Fetching failed controls details from given json file.
    $ControlIds = "Azure_Storage_AuthN_Dont_Allow_Anonymous"
    $controlForRemediation = Get-content -path $ControlFilePath | ConvertFrom-Json
    $SubscriptionId = $controlForRemediation.SubscriptionId

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
        $controls = $controlForRemediation.FailedControlSet
        $resourceDetails = $controls | Where-Object { $ControlIds -eq $controls.ControlId};
        $resourceContext = @()
        $resourceDetails.ResourceDetails | ForEach-Object { 
                              $resourceContext += Get-AzStorageAccount -Name $_.ResourceName -ResourceGroupName $_.ResourceGroupName    
                        }


        # Remediating

        try{
        if($resourceContext)
		{
            $ContainersWithAnonymousAccessOnStorage = @();
            $ContainersWithDisableAnonymousAccessOnStorage = @();
            $resourceContext | ForEach-Object{
                $flag = $true
                $allContainers = @();
                $containerWithAnonymousAccess = @();
				$context = $_.context;
	    		$allContainers += Get-AzStorageContainer -Context $context -ErrorAction Stop
                if($allContainers.Count -ne 0)
			    {
                    $containerWithAnonymousAccess += $allContainers | Where-Object { $_.PublicAccess -ne "Off"}
                    $containerWithAnonymousAccess | ForEach-Object {
                        try
                        {
                            Set-AzStorageContainerAcl -Name $_.Name -Permission Off -Context $context
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
                            ResourceGroupName = $_.ResourceGroupName
                            StorageAccountName = $_.StorageAccountName
                        }

                        $ContainersWithDisableAnonymousAccessOnStorage += $item
                    }
                    else
                    {
                    # Unable to disable containers anonymous access may be because of insufficient permission over storage account
                        $item =  New-Object psobject -Property @{  
                            StorageAccountName = $_.StorageAccountName
                            ResourceGroupName = $_.ResourceGroupName
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
        Write-Host "Error occured while remediating control. ErrorMessage [$($_)]" -ForegroundColor $([Constants]::MessageType.Error)
    }

    # Creating the log file
    $folderPath = [Environment]::GetFolderPath("MyDocuments") 
    if (Test-Path -Path $folderPath)
    {
        New-Item -ItemType Directory -Path $folderPath -Name 'DisableAnonymousAccessOnContainers\Subscriptions' | Out-Null
        $folderPath += '\DisableAnonymousAccessOnContainers\Subscriptions\'
    }

    Write-Host "------------------------------------------------------"
    if(($ContainersWithDisableAnonymousAccessOnStorage | Measure-Object).Count -ge 1)
      {
         Write-Host "Generating the log file containing details of all the storage account with disabled anonymous access on containers for Subscription: [$($SubscriptionId)]..."
         $ContainersWithDisableAnonymousAccessOnStorage | ConvertTo-Json | Out-File "$($folderPath)\ContainersWithDisableAnonymousAccessOnStorage_$($SubscriptionId.Replace("-","_")).json"
         Write-Host "Path: $($folderPath)ContainersWithDisableAnonymousAccessOnStorage_$($SubscriptionId.Replace("-","_")).json"
      }

    if(($ContainersWithAnonymousAccessOnStorage | Measure-Object).Count -ge 1)
      {
         Write-Host "`n"
         Write-Host "Generating the log file containing details of all the storage account in which remediating script unable to disable containers anonymous access due to in sufficient permission over storage account for Subscription: [$($SubscriptionId)]..."
         $ContainersWithAnonymousAccessOnStorage | ConvertTo-Json | Out-File "$($folderPath)\ContainersWithAnonymousAccessOnStorage_$($SubscriptionId.Replace("-","_")).json"
         Write-Host "Path: $($folderPath)ContainersWithAnonymousAccessOnStorage_$($SubscriptionId.Replace("-","_")).json"
         Write-Host "======================================================"
      }

}



# ***************************************************** #

# Function calling with parameters.
Remediate-DisableAnonymousAccessOnContainers -ControlFilePath "Enter json file containing failed storage accounts for remediation"
