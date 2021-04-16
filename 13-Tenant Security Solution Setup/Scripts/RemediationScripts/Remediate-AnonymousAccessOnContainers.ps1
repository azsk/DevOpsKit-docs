function Pre_requisites
{
    <#
    .SYNOPSIS
    This command would check pre requisities modules.
    .DESCRIPTION
    This command would check pre requisities modules to perform remediation.
	#>

    Write-Host "Required modules are: Az.Account, Az.Resources, Az.Storage" -ForegroundColor Cyan
    Write-Host "Checking for required modules..."
    $availableModules = $(Get-Module -ListAvailable Az.Resources, Az.Accounts,Az.Storage)
    
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
    
    # Checking if 'Az.Storage' module with required version is available or not.
    if($availableModules.Name -notcontains 'Az.Storage')
    {
        Write-Host "Installing module Az.Storage..." -ForegroundColor Yellow
        Install-Module -Name Az.Storage -Scope CurrentUser -Repository 'PSGallery'
    }
    else
    {
        Write-Host "Az.Storage module is available." -ForegroundColor Green
        $currentModule = $availableModules | Where-Object { $_.Name -eq "Az.Storage" }
        $currentModuleVersion = ($currentModule.Version  | measure -Maximum).Maximum -as [string]
        if([version]('{0}.{1}.{2}' -f $currentModuleVersion.split('.')) -lt [version]('{0}.{1}.{2}' -f "3.5.0".split('.')))
        {
            Write-Host "Updating module Az.Storage..." -ForegroundColor Yellow
            Update-Module -Name "Az.Storage"
        }
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

function Remove-AnonymousAccessOnContainers
{
    <#
    .SYNOPSIS
    This command would help in remediating 'Azure_Storage_AuthN_Dont_Allow_Anonymous' control.
    .DESCRIPTION
    This command would help in remediating 'Azure_Storage_AuthN_Dont_Allow_Anonymous' control.
    .PARAMETER SubscriptionId
        Enter subscription id on which remediation need to perform.
    .PARAMETER RemediationType
        Select remediation type to perform from drop down menu.
    .PARAMETER Path
        Json file path which contain failed controls detail to remediate.
    #>

    param (
        [string]
        [Parameter(Mandatory = $true, HelpMessage="Enter subscription id for remediation")]
        $SubscriptionId,

        [Parameter(Mandatory = $true, HelpMessage = "Select remediation type")]
        [ValidateSet("DisableAllowBlobPublicAccessOnStorage", "DisableAnonymousAccessOnContainers")]
        [string]
		$RemediationType,

        [string]
        [Parameter(Mandatory = $false, HelpMessage="Json file path which contain storage account detail to remediate")]
        $Path
    )

    if($RemediationType -eq "DisableAnonymousAccessOnContainers" -and [string]::IsNullOrWhiteSpace($Path))
    {
        Write-Host "`n"
        Write-Host "Warning: Instead of disabling anonymous access on all containers of storage account, You can select to disable 'AllowBlobPublicAccess' at storage level." -ForegroundColor Yellow
        Write-Host "Please execute same command with 'DisableAllowBlobPublicAccessOnStorage' remediation type parameter to disable anonymous access at storage level."
        Write-Host $([Constants]::DoubleDashLine)
        break; 
    }
    Write-Host $([Constants]::DoubleDashLine)
    Write-Host "Starting to remediation anonymous access on containers of storage account from subscription [$($SubscriptionId)]..."
    Write-Host $([Constants]::SingleDashLine)
    
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
    
    # Connect to AzAccount
    $isContextSet = Get-AzContext
    if ([string]::IsNullOrEmpty($isContextSet))
    {       
        Write-Host "Connecting to AzAccount..."
        Connect-AzAccount
        Write-Host "Connected to AzAccount" -ForegroundColor $([Constants]::MessageType.Update)
    }

    # Setting context for current subscription.
    $currentSub = Set-AzContext -SubscriptionId $SubscriptionId -ErrorAction Stop -Force

    Write-Host "Metadata Details: `n SubscriptionId: [$($SubscriptionId)] `n AccountName: [$($currentSub.Account.Id)] `n AccountType: [$($currentSub.Account.Type)]"
    Write-Host $([Constants]::SingleDashLine)  
    Write-Host "Starting with Subscription [$($SubscriptionId)]..."

    Write-Host "`n"
    Write-Host "*** To perform remediation for disabling anonymous access on containers user must have atleast contributor access on storage account of Subscription: [$($SubscriptionId)] ***" -ForegroundColor $([Constants]::MessageType.Warning)
    Write-Host "`n" 

    Write-Host "Validating whether the current user [$($currentSub.Account.Id)] has valid account type [User] to run the script for Subscription [$($SubscriptionId)]..."
    Write-Host "`n"

    # Safe Check: Checking whether the current account is of type User
    if($currentSub.Account.Type -ne "User")
    {
        Write-Host "Warning: This script can only be run by user account type." -ForegroundColor $([Constants]::MessageType.Warning)
        break;
    }
    
    Write-Host "Fetching storage account from Subscription [$($SubscriptionId)]..."
    
    # Array to store resource context
    $resourceContext = @()
    $controlIds = "Azure_Storage_AuthN_Dont_Allow_Anonymous"
    
    # If json path not given fetch all storage account.
    if([string]::IsNullOrWhiteSpace($Path))
    {
        $resourceContext = Get-AzStorageAccount
    }
    else
    {
        if (-not (Test-Path -Path $Path))
        {
            Write-Host "Error: Json file containing storage account(s) detail not found for remediation." -ForegroundColor $([Constants]::MessageType.Error)
            break;        
        }

        # Fetching storage accounts details for remediation.
        $controlForRemediation = Get-content -path $Path | ConvertFrom-Json
        $controls = $controlForRemediation.FailedControlSet
        $resourceDetails = $controls | Where-Object { $controlIds -eq $_.ControlId};

        if(($resourceDetails | Measure-Object).Count -eq 0 -or ($resourceDetails.ResourceDetails | Measure-Object).Count -eq 0)
        {
            Write-Host "No storage account(s) found in input json file for remedition." -ForegroundColor $([Constants]::MessageType.Error)
            break
        }
        $resourceDetails.ResourceDetails | ForEach-Object { 
            try
            {
                $resourceContext += Get-AzStorageAccount -Name $_.StorageAccountName -ResourceGroupName $_.ResourceGroupName
                $resourceContext | Add-Member -NotePropertyName AnonymousAccessContainer -NotePropertyValue $_.ContainersWithAnonymousAccess -ErrorAction SilentlyContinue
            }
            catch
            {
                Write-Host "Valid resource group and resource name not found in input json file. ErrorMessage [$($_)]" -ForegroundColor $([Constants]::MessageType.Error)
                break
            }
        }
    }

    $totalStorageAccount = ($resourceContext | Measure-Object).Count
    if($totalStorageAccount -eq 0)
    {
        Write-Host "Unable to fetch storage account." -ForegroundColor $([Constants]::MessageType.Error);
        Write-Host $([Constants]::DoubleDashLine)
        break;
    }

    switch ($RemediationType)
    {
        "DisableAllowBlobPublicAccessOnStorage"
        {
            try
            {
                $stgWithEnableAllowBlobPublicAccess = @()
                $stgWithDisableAllowBlobPublicAccess = @()
                $resourceContext | ForEach-Object {
                    if(($null -eq $_.allowBlobPublicAccess) -or ($_.allowBlobPublicAccess))
                    {
                        
                        $stgWithEnableAllowBlobPublicAccess += $_ | select -Property "StorageAccountName", "ResourceGroupName", "Id"
                    }
                    else
                    {
                        $stgWithDisableAllowBlobPublicAccess += $_
                    }   
                }
    
                $totalStgWithEnableAllowBlobPublicAccess = ($stgWithEnableAllowBlobPublicAccess | Measure-Object).Count
                $totalStgWithDisableAllowBlobPublicAccess = ($stgWithDisableAllowBlobPublicAccess | Measure-Object).Count
    
                Write-Host "Total storage account: [$($totalStorageAccount)]"
                Write-Host "Storage account with enabled 'Allow Blob Public Access': [$($totalStgWithEnableAllowBlobPublicAccess)]"
                Write-Host "Storage account with disabled 'Allow Blob Public Access': [$($totalStgWithDisableAllowBlobPublicAccess)]"
                Write-Host "`n"

                # Start remediation storage account with 'Allow Blob Public Access' enabled.
                if ($totalStgWithEnableAllowBlobPublicAccess -gt 0)
                {
                    # Creating the log file
                    $folderPath = [Environment]::GetFolderPath("MyDocuments") 
                    if (Test-Path -Path $folderPath)
                    {
                        $folderPath += "\AzTS\Remediation\Subscriptions\$($subscriptionid.replace("-","_"))\$((Get-Date).ToString('yyyyMMdd_hhmm'))\DisableAnonymousAccessOnContainers"
                        New-Item -ItemType Directory -Path $folderPath | Out-Null
                    }
    
                    Write-Host "Taking backup of storage account with enabled 'Allow Blob Public Access'. Please do not delete this file. Without this file you wont be able to rollback any changes done through Remediation script." -ForegroundColor $([Constants]::MessageType.Info)
                    $stgWithEnableAllowBlobPublicAccess | ConvertTo-json | out-file "$($folderpath)\DisabledAllowBlobPublicAccess.json"  
                    Write-Host "Path: $($folderpath)\DisabledAllowBlobPublicAccess.json"     
                    Write-Host "`n"
                    Write-Host "Disabling 'Allow Blob Public Access' on [$($totalStgWithEnableAllowBlobPublicAccess)] storage account(s) from Subscription [$($SubscriptionId)]..."
                    $stgWithEnableAllowBlobPublicAccess | ForEach-Object {
                        try
                        {
                            Set-AzStorageAccount -ResourceGroupName $_.ResourceGroupName -Name $_.StorageAccountName -AllowBlobPublicAccess $false | Out-Null
                            Write-Host "Disabled 'Allow Blob Public Access' of [Name]: [$($_.StorageAccountName)] [ResourceGroupName]: [$($_.ResourceGroupName)]" -ForegroundColor $([Constants]::MessageType.Update)
                        }
                        catch
                        {
                            Write-Host "Skipping to disable 'Allow Blob Public Access' due to insufficient access [Name]: [$($_.StorageAccountName)] [ResourceGroupName]: [$($_.ResourceGroupName)]" -ForegroundColor $([Constants]::MessageType.Warning)
                        }
                    }
                    Write-Host $([Constants]::DoubleDashLine)
                }
                else
                {
                    Write-Host "No storage account found with enabled 'Allow Blob Public Access'." -ForegroundColor $([Constants]::MessageType.Update)
                    Write-Host $([Constants]::DoubleDashLine)
                    break
                }
            }
            catch{
                Write-Host "Error occured while remediating changes. ErrorMessage [$($_)]" -ForegroundColor $([Constants]::MessageType.Error)
                break
            }
        }
        "DisableAnonymousAccessOnContainers" 
        {
            Write-Host "Found [$($totalStorageAccount)] storage account(s)..."
            Write-Host "`n"
            Write-Host "Warning: Selected remediation type will disable anonymous access for specific containers, provided in input json file." -ForegroundColor $([Constants]::MessageType.Warning)
            Write-Host "`n"
           
            Write-Host "Disabling anonymous access on containers of storage account from Subscription [$($SubscriptionId)]..."

            # Performing remediation
            try
            {
                $ContainersWithAnonymousAccessOnStorage = @();
                $ContainersWithDisableAnonymousAccessOnStorage = @();
                $resourceContext | ForEach-Object{
                    $flag = $true
                    $allContainers = @();
                    $containersWithAnonymousAccess = @();
                    $anonymousAccessContainersNameAndPublicAccess = @();
                    $context = $_.context;

                    # Taking containers details from input json file for remediation
                    $allContainers += Get-AzStorageContainer -Context $context -ErrorAction Stop
                    if((($allContainers | Measure-Object).Count -gt 0) -and (($null -ne $_.AnonymousAccessContainer) -and ($_.AnonymousAccessContainer | Measure-Object).Count -gt 0))
                    {
                        $containersToRemediate = $_.AnonymousAccessContainer;
                        $containersWithAnonymousAccess += $allContainers | Where-Object { $_.Name -in $containersToRemediate }
                        if(($containersWithAnonymousAccess | Measure-Object).Count -gt 0)
                        {
                            $containersWithAnonymousAccess | ForEach-Object {
                                try
                                {
                                    Set-AzStorageContainerAcl -Name $_.Name -Permission Off -Context $context | Out-Null
                                    
                                    # Creating objects with container name and public access type, It will help while doing roll back operation.
                                    $item =  New-Object psobject -Property @{  
                                            Name = $_.Name                
                                            PublicAccess = $_.PublicAccess
                                        }
                                        $anonymousAccessContainersNameAndPublicAccess += $item
                                }
                                catch
                                {
                                    # If not able to remove container public access due to insufficient permission or exception occured.
                                    $flag = $false
                                    break;    
                                }
                            };
                        
                            # If successfully removed anonymous access from storage account's containers.
                            if($flag)
                            {
                                Write-Host "Anonymous access has been disabled on containers of storage account [Name]: [$($_.StorageAccountName)] [ResourceGroupName]: [$($_.ResourceGroupName)]" -ForegroundColor $([Constants]::MessageType.Update); 
                                $item =  New-Object psobject -Property @{  
                                        SubscriptionId = $SubscriptionId
                                        ResourceGroupName = $_.ResourceGroupName
                                        StorageAccountName = $_.StorageAccountName
                                        ResourceType = "Microsoft.Storage/storageAccounts"
                                        ResourceId = $_.id
                                    }

                                    # Adding array of container name and public access type
                                    $item | Add-Member -Name 'ContainersWithAnonymousAccess' -Type NoteProperty -Value $anonymousAccessContainersNameAndPublicAccess;
                                    $ContainersWithDisableAnonymousAccessOnStorage += $item
                            }
                            else
                            {
                                # Unable to disable containers anonymous access may be because of insufficient permission over storage account or exception occured.
                                Write-Host "Skipping to disable anonymous access on containers of storage account due to insufficient access [Name]: [$($_.StorageAccountName)] [ResourceGroupName]: [$($_.ResourceGroupName)]" -ForegroundColor $([Constants]::MessageType.Warning);
                                $item =  New-Object psobject -Property @{
                                        SubscriptionId = $SubscriptionId  
                                        ResourceGroupName = $_.ResourceGroupName
                                        StorageAccountName = $_.StorageAccountName
                                        ResourceType = "Microsoft.Storage/storageAccounts"
                                        ResourceId = $_.id
                                    }

                                $ContainersWithAnonymousAccessOnStorage += $item
                            }
                        }
                        else {
                            Write-Host "There are no containers on storage account which have anonymous access enabled [Name]: [$($_.StorageAccountName)] [ResourceGroupName]: [$($_.ResourceGroupName)]" -ForegroundColor $([Constants]::MessageType.Update);
                        }
                    }
                    else
                    {
                        Write-Host "No container(s) found to disable anonymous access for storage account [Name]: [$($_.StorageAccountName)] [ResourceGroupName]: [$($_.ResourceGroupName)]" -ForegroundColor $([Constants]::MessageType.Update) ;
                    }	
                }
            }
            catch
            {
                Write-Host "Error occured while remediating control. ErrorMessage [$($_)]" -ForegroundColor $([Constants]::MessageType.Error)
                break
            }

            # Creating the log file
            $folderPath = [Environment]::GetFolderPath("MyDocuments") 
            if (Test-Path -Path $folderPath)
            {
                $folderPath += "\AzTS\Remediation\Subscriptions\$($subscriptionid.replace("-","_"))\$((Get-Date).ToString('yyyyMMdd_hhmm'))\DisableAnonymousAccessOnContainers"
                New-Item -ItemType Directory -Path $folderPath | Out-Null
            }

            if(($ContainersWithDisableAnonymousAccessOnStorage | Measure-Object).Count -gt 0)
            {
                Write-Host "Taking backup of storage account details for Subscription: [$($SubscriptionId)] on which remediation is successfully performed. Please do not delete this file. Without this file you wont be able to rollback any changes done through remediation script." -ForegroundColor $([Constants]::MessageType.Info)
                $ContainersWithDisableAnonymousAccessOnStorage | ConvertTo-Json -Depth 10| Out-File "$($folderPath)\ContainersWithDisableAnonymousAccess.json"
                Write-Host "Path: $($folderPath)\ContainersWithDisableAnonymousAccess.json"
                Write-Host $([Constants]::DoubleDashLine)
            }

            if(($ContainersWithAnonymousAccessOnStorage | Measure-Object).Count -gt 0)
            {
                Write-Host "`n"
                Write-Host "Generating the log file containing details of all the storage account on which remediating script unable to disable containers with anonymous access due to error occurred or insufficient permission over storage account for Subscription: [$($SubscriptionId)]..." -ForegroundColor $([Constants]::MessageType.Info)
                $ContainersWithAnonymousAccessOnStorage | ConvertTo-Json -Depth 10 | Out-File "$($folderPath)\ContainersWithAnonymousAccessOnStorage.json"
                Write-Host "Path: $($folderPath)\ContainersWithAnonymousAccessOnStorage.json"
                Write-Host $([Constants]::DoubleDashLine)
            }
        }
        Default {

            Write-Host "No valid remediation type selected." -ForegroundColor $([Constants]::MessageType.Error)
            break;
        }
    }
}

# Script to Roll back changes done by remediation script
function Set-AnonymousAccessOnContainers
{
    <#
    .SYNOPSIS
    This command would help in performing roll back operation for 'Azure_Storage_AuthN_Dont_Allow_Anonymous' control.
    .DESCRIPTION
    This command would help in performing roll back operation for 'Azure_Storage_AuthN_Dont_Allow_Anonymous' control.
    .PARAMETER SubscriptionId
        Enter subscription id on which roll back operation need to perform.
    .PARAMETER RollBackType
        Select rollback type to perform roll back operation from drop down menu.
    .PARAMETER Path
        Json file path which containing remediation log to perform roll back operation.
    #>
    param (
        [string]
        [Parameter(Mandatory = $true, HelpMessage="Enter subscription id to perform roll back operation")]
        $SubscriptionId,

        [Parameter(Mandatory = $true, HelpMessage = "Select rollback type")]
        [ValidateSet("EnableAllowBlobPublicAccessOnStorage", "EnableAnonymousAccessOnContainers")]
        [string]
		$RollBackType,

        [string]
        [Parameter(Mandatory = $true, HelpMessage="Json file path which contain logs generated by remediation script to roll back remediation changes")]
        $Path
    )

    Write-Host $([Constants]::DoubleDashLine)
    Write-Host "Starting roll back operation to enable anonymous access on containers of storage account from subscription [$($SubscriptionId)]...."
    Write-Host $([Constants]::SingleDashLine)

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
    Write-Host $([Constants]::SingleDashLine) 
    Write-Host "Starting with Subscription [$($SubscriptionId)]..."

    Write-Host "`n"
    Write-Host "*** To perform roll back operation for enabling anonymous access on containers user must have atleast contributor access on storage account of Subscription: [$($SubscriptionId)] ***" -ForegroundColor $([Constants]::MessageType.Warning)
    Write-Host "`n" 
    Write-Host "Validating whether the current user [$($currentSub.Account.Id)] have valid account type [User] to run the script for Subscription [$($SubscriptionId)]..."

    # Safe Check: Checking whether the current account is of type User
    if($currentSub.Account.Type -ne "User")
    {
        Write-Host "Warning: This script can only be run by user account type." -ForegroundColor $([Constants]::MessageType.Warning)
        break;
    }
    
    Write-Host "`n"
    Write-Host "Fetching remediation log to perform roll back operation on containers of storage account from Subscription [$($SubscriptionId)]..."
 
    # Array to store resource context
    $resourceContext = @()
    if (-not (Test-Path -Path $Path))
    {
        Write-Host "Error: Control file path is not found." -ForegroundColor $([Constants]::MessageType.Error)
        break;        
    }

    switch ($RollBackType) 
    {
        "EnableAllowBlobPublicAccessOnStorage" 
        {  
            # Fetching remediated log for 'DisableAllowBlobPublicAccessOnStorage' remediation type.
            $remediatedResourceLog = Get-content -path $Path | ConvertFrom-Json
    
            Write-Host "Performing roll back operation to enable 'Allow Blob Public Access' for storage account of Subscription [$($SubscriptionId)]..."
        
            # Performing roll back operation
            try
            {
                if(($remediatedResourceLog | Measure-Object).Count -gt 0)
                {
                    Write-Host "Enabling 'Allow Blob Public Access' on [$(($remediatedResourceLog| Measure-Object).Count)] storage account of Subscription [$($SubscriptionId)]..."
                    $remediatedResourceLog | ForEach-Object {
                        try
                        {
                            Set-AzStorageAccount -ResourceGroupName $_.ResourceGroupName -StorageAccountName $_.StorageAccountName -AllowBlobPublicAccess $true | Out-Null
                            Write-Host "Successfully performed rollback opeartion: Enabled 'Allow Blob Public Access' on storage account [Name]: [$($_.StorageAccountName)] [ResourceGroupName]: [$($_.ResourceGroupName)]" -ForegroundColor $([Constants]::MessageType.Update)
                        }
                        catch
                        {
                            Write-Host "Skipping to enable 'Allow Blob Public Access' due to insufficient access or exception occured [Name]: [$($_.StorageAccountName)] [ResourceGroupName]: [$($_.ResourceGroupName)]" -ForegroundColor $([Constants]::MessageType.Warning)
                        }
                    }
                    Write-Host $([Constants]::DoubleDashLine)
                }
                else 
                {
                    Write-Host "No storage account found in remediation log to perform roll back operation." -ForegroundColor $([Constants]::MessageType.Update)
                    Write-Host $([Constants]::DoubleDashLine)
                    break
                }
            }   
            catch
            {
                Write-Host "Error occured while performing roll back opeartion for remediating changes. ErrorMessage [$($_)]" -ForegroundColor $([Constants]::MessageType.Error)
                break
            }
        }
        "EnableAnonymousAccessOnContainers" 
        {  
            # Fetching remediated log for 'DisableAnonymousAccessOnContainers' remediation type.
            $remediatedResourceLog = Get-content -path $Path | ConvertFrom-Json
            try
            {
                $remediatedResourceLog | ForEach-Object { 
                            $resourceContext += Get-AzStorageAccount -Name $_.StorageAccountName -ResourceGroupName $_.ResourceGroupName    
                            $resourceContext | Add-Member -NotePropertyName AnonymousAccessContainer -NotePropertyValue $_.ContainersWithAnonymousAccess -ErrorAction SilentlyContinue
                        }
            }
            catch
            {
                Write-Host "Input json file is not valid as per selected roll back type. ErrorMessage [$($_)]" -ForegroundColor $([Constants]::MessageType.Error)
                break
            }

            $totalResourceToRollBack = ($resourceContext | Measure-Object).Count
            Write-Host "Found [$($totalResourceToRollBack)] storage account to perform roll back operation."
            Write-Host "Performing roll back operation to enable anonymous access on containers of storage account from Subscription [$($SubscriptionId)]..."
        

            # Performing roll back
            try{
                if($totalResourceToRollBack -gt 0)
                {
                    $resourceContext | ForEach-Object{
                        $flag = $true
                        $context = $_.context;
                        $containerWithAnonymousAccess = @();
                        $containerWithAnonymousAccess += $_.AnonymousAccessContainer

                        # Checking 'Allow Blob Public Access' is enabled or not at storage level. If found enabled then we can roll back access otherwise not permitted.
                        if(($null -eq $_.AllowBlobPublicAccess) -or $_.AllowBlobPublicAccess)
                            {
                                if(($containerWithAnonymousAccess | Measure-Object).Count -gt 0)
                                {
                                    $containerWithAnonymousAccess | ForEach-Object {
                                        try
                                        {
                                            Set-AzStorageContainerAcl -Name $_.Name -Permission $_.PublicAccess -Context $context | Out-Null
                                        }
                                        catch
                                        {
                                            $flag = $false
                                            break;
                                        }
                                    };

                                    if($flag)
                                    {
                                        Write-Host "Successfully performed rollback opeartion: Anonymous access has been enabled on containers of storage [Name]: [$($_.StorageAccountName)] [ResourceGroupName]: [$($_.ResourceGroupName)]" -ForegroundColor $([Constants]::MessageType.Update)s;
                                    }
                                    else 
                                    {
                                        Write-Host "Skipping to enable anonymous access on containers of storage [Name]: [$($_.StorageAccountName)] [ResourceGroupName]: [$($_.ResourceGroupName)]" -ForegroundColor $([Constants]::MessageType.Warning);
                                    }
                                }
                                else
                                {
                                    Write-Host "No containers found with enabled anonymous access [Name]: [$($_.StorageAccountName)] [ResourceGroupName]: [$($_.ResourceGroupName)]" -ForegroundColor $([Constants]::MessageType.Update);
                                }	
                            }
                            else 
                            {
                                Write-Host "Public access is not permitted on this storage account [Name]: [$($_.StorageAccountName)] [ResourceGroupName]: [$($_.ResourceGroupName)]" -ForegroundColor $([Constants]::MessageType.Warning);
                            }
                    }
                    Write-Host $([Constants]::DoubleDashLine)
                }
                else
                {
                    Write-Host "Unable to fetch storage account." -ForegroundColor $([Constants]::MessageType.Error);
                    break
                }
            }
            catch
            {
                Write-Host "Error occured while performing roll back operation for remediating changes. ErrorMessage [$($_)]" -ForegroundColor $([Constants]::MessageType.Error)
                break
            }
        }
        Default 
        {
            Write-Host "No valid roll back type selected." -ForegroundColor $([Constants]::MessageType.Error)
            break;
        }
    } 
}

class Constants
{
    static [Hashtable] $MessageType = @{
        Error = [System.ConsoleColor]::Red
        Warning = [System.ConsoleColor]::Yellow
        Info = [System.ConsoleColor]::Cyan
        Update = [System.ConsoleColor]::Green
	    Default = [System.ConsoleColor]::White
    }

    static [string] $DoubleDashLine    = "================================================================================"
    static [string] $SingleDashLine    = "--------------------------------------------------------------------------------"
}

<#
# ***************************************************** #

# Function calling with parameters for remediation.
Remove-AnonymousAccessOnContainers -SubscriptionId '<Sub_Id>' -RemediationType '<DisableAnonymousAccessOnContainers>, <DisableAllowBlobPublicAccessOnStorage>'  -Path '<Json file path containing storage account detail>'

# Function calling with parameters to roll back remediation changes.
Set-AnonymousAccessOnContainers -SubscriptionId '<Sub_Id>' -RollBackType '<EnableAnonymousAccessOnContainers>, <EnableAllowBlobPublicAccessOnStorage>'  -Path '<Json file path containing Remediated log>'

#>
