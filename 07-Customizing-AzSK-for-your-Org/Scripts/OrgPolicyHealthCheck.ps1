Param(

[string]
[Parameter(Mandatory = $true)]
 $SubscriptionId,

[string]
[Parameter(Mandatory = $true)]
$PolicyResourceGroupName 
)

  #Constants 
  $ModuleName = "AzSK"
  $BlankSubId = "00000000-0000-0000-0000-000000000000"
  $RepoName = "PSGallery"
  #Login and Set context to policy subscription
    function Login
    {
        $currentContext = Get-AzureRMContext 
        if((-not $currentContext) -or ($currentContext -and ((-not $currentContext.Subscription -and ($this.SubscriptionContext.SubscriptionId -ne $BlankSubId)) `
				    -or -not $currentContext.Account)))
            {
                WriteMessage "No active Azure login session found. Initiating login flow..."

			    if($this.SubscriptionContext.SubscriptionId -ne $BlankSubId)
			    {
				    $rmLogin = Add-AzureRmAccount -SubscriptionId $SubscriptionId
			    }
			    else
			    {
				    $rmLogin = Add-AzureRmAccount
			    }
            
			    if($rmLogin)
			    {
				    $currentContext = $rmLogin.Context;
			    }
            }

        if($currentContext -and $currentContext.Subscription -and $currentContext.Subscription.Id)
	    {
		    if(($currentContext.Subscription.Id -ne $SubscriptionId) -and ($this.SubscriptionContext.SubscriptionId -ne $BlankSubId))
		    {
			    $currentContext = Set-AzureRmContext -SubscriptionId $SubscriptionId -ErrorAction Stop   
        
				    
			    # $currentContext will contain the desired subscription (or $null if id is wrong or no permission)
			    if ($null -eq $currentContext)
			    {
				    throw [SuppressedException] ("Invalid Subscription Id [" + $this.SubscriptionContext.SubscriptionId + "]") 
			    }
		    }
	    }
}
  #Login End

function GetSubString($CotentString, $Pattern )
{
    return  $result = [regex]::match($CotentString, $pattern).Groups[1].Value
}

function IsStringEmpty($String)
{
    if([string]::IsNullOrEmpty($String))
    {
        return "Not Available"
    }
    else 
    {
        return $String
    }
}


enum MessageType
{
    Error
    Warning
    Info
    Update
	Default
}

function WriteMessage([string] $message,[string] $messageType)
{
    if(-not $message)
    {
        return;
    }
        
    $colorCode = [System.ConsoleColor]::White

    switch($messageType)
    {
        ([MessageType]::Error) {
            $colorCode = [System.ConsoleColor]::Red             
        }
        ([MessageType]::Warning) {
            $colorCode = [System.ConsoleColor]::Yellow              
        }
        ([MessageType]::Info) {
            $colorCode = [System.ConsoleColor]::Cyan
        }  
        ([MessageType]::Update) {
            $colorCode = [System.ConsoleColor]::Green
        }           
		([MessageType]::Default) {
            $colorCode = [System.ConsoleColor]::White
        }           
    }		
    Write-Host $message -ForegroundColor $colorCode		
}





  WriteMessage "================================================================================" $([MessageType]::Info)
  WriteMessage "Running Org policy check..." $([MessageType]::Info)
  WriteMessage "================================================================================" $([MessageType]::Info)
  Login
  [PSObject] $PolicyScanOutput = @{}
  $PolicyScanOutput.Resources = @{}
  

  #Check 01: Presence of Org policy resources
  WriteMessage "Check 01: Presence of Org policy resources." $([MessageType]::Info)

  #a. Validate presense of policy resource group
  $policyResourceGroup= Get-AzureRmResourceGroup -Name $PolicyResourceGroupName -ErrorAction SilentlyContinue  
  if(-not $policyResourceGroup)
  {
    WriteMessage "`t Missing: Policy resource group" $([MessageType]::Error)
    $PolicyScanOutput.Resources.ResourceGroup = $false
    return
  }
  else
  {
    $PolicyScanOutput.Resources.ResourceGroup = $true
  }

  #b. Validate presense of policy resources storage, app insight and monitoring dashboard
  $policyResources= Find-AzureRmResource -ResourceGroupName $policyResourceGroupName
  #Check if poliy store  is present 
  $policyStore = $policyResources  | Where-Object {$_.ResourceType -eq "Microsoft.Storage/storageAccounts" }
  if(($policyStore | Measure-Object).Count -eq 0)
  {
    WriteMessage "`t Missing: Policy storage account" $([MessageType]::Error)
    $PolicyScanOutput.Resources.PolicyStore = $false
  }
  else
  {
    $PolicyScanOutput.Resources.PolicyStore = $true
  }
  
  #Check if app insight is present
  $appInsight = $policyResources  | Where-Object {$_.ResourceType -eq "Microsoft.Insights/components" }
  if(($appInsight | Measure-Object).Count -eq 0)
  {
    WriteMessage "`t Missing: Policy app insight" $([MessageType]::Error)
    $PolicyScanOutput.Resources.AppInsight = $false
  }
  else
  {
    $PolicyScanOutput.Resources.AppInsight = $true
  }

  #Check if monitoring dashboard is present
  $monitoringDashboard = $policyResources  | Where-Object {$_.ResourceType -eq "Microsoft.Portal/dashboards" }
  if(($monitoringDashboard | Measure-Object).Count -eq 0)
  {
   WriteMessage "`t Missing: Monitoring dashboard" $([MessageType]::Error)
    $PolicyScanOutput.Resources.MonitoringDashboard = $false
  }
  else
  {
    $PolicyScanOutput.Resources.MonitoringDashboard = $true
  }

  if($PolicyScanOutput.Resources.PolicyStore -and $PolicyScanOutput.Resources.AppInsight -and $PolicyScanOutput.Resources.MonitoringDashboard)
  {
    WriteMessage "Status:   OK. Found all policy resources." $([MessageType]::Update)
    $PolicyScanOutput.Resources.Status = $true
  }
  else
  {
    WriteMessage "Status:   Failed." $([MessageType]::Error)
    $PolicyScanOutput.Resources.Status = $false
  }
  WriteMessage  "--------------------------------------------------------------------------------" $([MessageType]::Info)

  #Check 02: Presence of mandatory policies
  WriteMessage "Check 02: Presence of mandatory policies." $([MessageType]::Info)
  $PolicyScanOutput.Policies = @{}
  if($PolicyScanOutput.Resources.PolicyStore)
  {
    $PolicyStoragekey = Get-AzureRmStorageAccountKey -ResourceGroupName $policyStore.ResourceGroupName  -Name $policyStore.Name 
    $currentContext = New-AzureStorageContext -StorageAccountName $policyStore.Name  -StorageAccountKey $PolicyStoragekey[0].Value -Protocol Https    
    $containerList = Get-AzureStorageContainer -Context $currentContext
  
    $policyTempFolder = $env:TEMP + "\" + $ModuleName + "\Policies\";				
    if(-not (Test-Path "$policyTempFolder"))
    {
	    mkdir -Path "$policyTempFolder" -ErrorAction Stop | Out-Null
    }
    else
    {
	    Remove-Item -Path "$policyTempFolder\*" -Force -Recurse 
    }
    
    #Validate presense of installer
    $Installer = Get-AzureStorageBlobContent -Container "installer" -Blob "$($ModuleName)-EasyInstaller.ps1" -Context $currentContext -Destination $policyTempFolder -Force -ErrorAction SilentlyContinue
    $InstallerPath = $policyTempFolder + "$($ModuleName)-EasyInstaller.ps1"
    if(($Installer | Measure-Object).Count -eq 0)
    {
        WriteMessage "`t Missing: Installer" $([MessageType]::Error)
        $PolicyScanOutput.Policies.Installer = $false
    }
    else
    {
        $PolicyScanOutput.Policies.Installer = $true
    }    

    #Validate presense of AzSK.Pre.json
    $AzSKPre = Get-AzureStorageBlobContent -Container "policies" -Blob "1.0.0/AzSK.Pre.json" -Context $currentContext -Destination $policyTempFolder -Force -ErrorAction SilentlyContinue
    if(($AzSKPre | Measure-Object).Count -eq 0)
    {
        WriteMessage "`t Missing: AzSKPre Config" $([MessageType]::Error)
        $PolicyScanOutput.Policies.AzSKPre = $false
    }
    else
    {
        $PolicyScanOutput.Policies.AzSKPre = $true
    }

    $RunbookCoreSetup = Get-AzureStorageBlobContent -Container "policies" -Blob "1.0.0/RunbookCoreSetup.ps1" -Context $currentContext -Destination $policyTempFolder -Force -ErrorAction SilentlyContinue
    if(($RunbookCoreSetup | Measure-Object).Count -eq 0)
    {
        WriteMessage "`t Missing: RunbookCoreSetup" $([MessageType]::Error)
        $PolicyScanOutput.Policies.RunbookCoreSetup = $false
    }
    else
    {
        $PolicyScanOutput.Policies.RunbookCoreSetup = $true
    }

    $RunbookScanAgent = Get-AzureStorageBlobContent -Container "policies" -Blob "1.0.0/RunbookScanAgent.ps1" -Context $currentContext -Destination $policyTempFolder -Force -ErrorAction SilentlyContinue
    if(($RunbookScanAgent | Measure-Object).Count -eq 0)
    {
        WriteMessage "`t Missing: RunbookScanAgent" $([MessageType]::Error)
        $PolicyScanOutput.Policies.RunbookScanAgent = $false
    }
    else
    {
        $PolicyScanOutput.Policies.RunbookScanAgent = $true
    }


    $AzSKConfig = Get-AzureStorageBlobContent -Container "policies" -Blob "3.1803.0/AzSK.json" -Context $currentContext -Destination $policyTempFolder -Force -ErrorAction SilentlyContinue
    if(($AzSKConfig | Measure-Object).Count -eq 0)
    {
        WriteMessage "`t Missing: RunbookScanAgent" $([MessageType]::Error)
        $PolicyScanOutput.Policies.AzSKConfig = $false
    }
    else
    {
        $PolicyScanOutput.Policies.AzSKConfig = $true
    }

    $ServerConfigMetadata = Get-AzureStorageBlobContent -Container "policies" -Blob "3.1803.0/ServerConfigMetadata.json" -Context $currentContext -Destination $policyTempFolder -Force -ErrorAction SilentlyContinue
    if(($ServerConfigMetadata | Measure-Object).Count -eq 0)
    {
        WriteMessage "`t Missing: ServerConfigMetadata" $([MessageType]::Error)
        $PolicyScanOutput.Policies.ServerConfigMetadata = $false
    }
    else
    {
        $PolicyScanOutput.Policies.ServerConfigMetadata = $true
    }
    
    if($PolicyScanOutput.Policies.Installer -and $PolicyScanOutput.Policies.AzSKPre -and $PolicyScanOutput.Policies.RunbookCoreSetup -and $PolicyScanOutput.Policies.RunbookScanAgent -and $PolicyScanOutput.Policies.AzSKConfig -and $PolicyScanOutput.Policies.ServerConfigMetadata)
    {
        WriteMessage "Status:   OK. Found all mandatory policies." $([MessageType]::Update)
        $PolicyScanOutput.Policies.Status = $true
    }
    else
    {
        WriteMessage "Status:   Failed." $([MessageType]::Error)
        $PolicyScanOutput.Policies.Status = $false
    }
  }
  else 
  {
    WriteMessage "Status:   Skipped. Policy store not found." $([MessageType]::Info)
    $PolicyScanOutput.Policies.Status = $false
  }

WriteMessage  "--------------------------------------------------------------------------------" $([MessageType]::Info)
 
#Check 03: Validate installer file 
WriteMessage "Check 03: Check Installer configurations." $([MessageType]::Info)
$PolicyScanOutput.Configurations = @{}
$PolicyScanOutput.Configurations.Installer = @{}
$InstallOutput = $PolicyScanOutput.Configurations.Installer
if($PolicyScanOutput.Policies.Installer)
{
   $InstallerContent =  Get-Content -Path $InstallerPath   

   #Validate OnlinePolicyStoreUrl
   $pattern = 'OnlinePolicyStoreUrl = "(.*?)"'
    $InstallerPolicyUrl = GetSubString $InstallerContent $pattern   
    $policyContainerUrl= $AzSKConfig.ICloudBlob.Container.Uri.AbsoluteUri  
    if($InstallerPolicyUrl -like "*$policyContainerUrl*" )
    {
        $InstallOutput.PolicyUrl = $true
    }
    else
    {
        $InstallOutput.PolicyUrl = $false
        WriteMessage "`t Missing Configuration: OnlinePolicyStoreUrl" $([MessageType]::Error)
        WriteMessage "`t Actual: $(IsStringEmpty($InstallerPolicyUrl))  `n`t Expected base Url: $(IsStringEmpty($policyContainerUrl))" $([MessageType]::Error)
    }
    
    #Validate AutoUpdateCommand command 
    $pattern = 'AutoUpdateCommand = "(.*?)"'
    $autoUpdateCommandUrl = GetSubString $InstallerContent $pattern   
    $installerUrl = $Installer.ICloudBlob.Uri.AbsoluteUri  

    if($autoUpdateCommandUrl -like "*$installerUrl*" )
    {
        $InstallOutput.AutoUpdateCommandUrl = $true
    }
    else
    {
        $InstallOutput.AutoUpdateCommandUrl = $false
        WriteMessage "`t Missing Configuration: AutoUpdateCommand" $([MessageType]::Error)
        WriteMessage "`t Actual: $(IsStringEmpty($autoUpdateCommandUrl))  `n`t Expected base Url: $(IsStringEmpty($installerUrl))" $([MessageType]::Error)
    } 

    #Validate AzSKConfigURL
    $pattern = 'AzSKConfigURL = "(.*?)"'
    $InstallerAzSKPreUrl = GetSubString $InstallerContent $pattern   
    $AzSKPreUrl = $AzSKPre.ICloudBlob.Uri.AbsoluteUri  

    if($InstallerAzSKPreUrl -like "*$AzSKPreUrl*" )
    {
        $InstallOutput.AzSKPreUrl = $true
    }
    else
    {
        $InstallOutput.AzSKPreUrl = $false
        WriteMessage "`t Missing Configuration: AzSKPreConfigUrl" $([MessageType]::Error)
        WriteMessage "`t Actual: $(IsStringEmpty($InstallerAzSKPreUrl))  `n`t Expected Substring Url: $(IsStringEmpty($AzSKPreUrl))" $([MessageType]::Error)
    }

    if($InstallOutput.PolicyUrl -and $InstallOutput.AutoUpdateCommandUrl -and $InstallOutput.AzSKPreUrl)
    {
        WriteMessage "Status:   OK." $([MessageType]::Update)
        $InstallOutput.Status = $true
    }
    else
    {
        WriteMessage "Status:   Failed." $([MessageType]::Error)
        $InstallOutput.Status = $false   
    }
}
else
{
      WriteMessage "Status:   Skipped. Installer not found." $([MessageType]::Info)
      $InstallOutput.Status = $false   
}

WriteMessage  "--------------------------------------------------------------------------------" $([MessageType]::Info)

#Check 04: Validate AzSKPre
$PolicyScanOutput.Configurations.AzSKPre = @{}
WriteMessage "Check 04: Check AzSKPre configurations." $([MessageType]::Info)
if($PolicyScanOutput.Policies.AzSKPre)
{
   $AzSKPreConfigPath = $policyTempFolder + "1.0.0\AzSK.Pre.json"
   $AzSKPreConfigContent =  Get-Content -Path $AzSKPreConfigPath | ConvertFrom-Json   

   #Validate CurrentVersionForOrg
   $LatestAzSKVersion = Find-Module $ModuleName -Repository $RepoName
    if($AzSKPreConfigContent.CurrentVersionForOrg -eq $LatestAzSKVersion.Version.ToString()  )
    {
        $PolicyScanOutput.Configurations.AzSKPre.CurrentVersionForOrg = $true
    }
    else
    {
        $PolicyScanOutput.Configurations.AzSKPre.CurrentVersionForOrg = $true
        WriteMessage "`t You are running on older AzSK version" $([MessageType]::Warning)
        WriteMessage "`t CurrentVersion: $(IsStringEmpty($($AzSKPreConfigContent.CurrentVersionForOrg)))  `n`t LatestVersion: $(IsStringEmpty($($LatestAzSKVersion.Version.Tostring())))" $([MessageType]::Warning)
    }
    
    if($PolicyScanOutput.Configurations.AzSKPre.CurrentVersionForOrg)
    {
        WriteMessage "Status:   OK." $([MessageType]::Update)
        $PolicyScanOutput.Configurations.AzSKPre.Status = $true
    }
    else
    {
         WriteMessage "Status:   Failed." $([MessageType]::Error)
         $PolicyScanOutput.Configurations.AzSKPre.Status = $false
    }    
}
else
{
      WriteMessage "Status:   Skipped. AzSKPreConfig not found." $([MessageType]::Info) 
      $PolicyScanOutput.Configurations.AzSKPre.Status = $false  
}

WriteMessage  "--------------------------------------------------------------------------------" $([MessageType]::Info)

#Check 05: Validate CoreSetup 
$PolicyScanOutput.Configurations.RunbookCoreSetup = @{}
WriteMessage "Check 05: Check RunbookCoreSetup configurations." $([MessageType]::Info)
if($PolicyScanOutput.Policies.RunbookCoreSetup)
{
   $RunbookCoreSetupPath = $policyTempFolder + "1.0.0\RunbookCoreSetup.ps1"
   $RunbookCoreSetupContent =  Get-Content -Path $RunbookCoreSetupPath     

    #Validate AzSkVersionForOrgUrl command 
    $pattern = 'azskVersionForOrg = "(.*?)"'
    $coreSetupAzSkVersionForOrgUrl = GetSubString $RunbookCoreSetupContent $pattern   
    $AzSkVersionForOrgUrl = $AzSKPre.ICloudBlob.Uri.AbsoluteUri  

    if($coreSetupAzSkVersionForOrgUrl -like "*$AzSkVersionForOrgUrl*" )
    {
        $PolicyScanOutput.Configurations.RunbookCoreSetup.AzSkVersionForOrgUrl = $true
    }
    else
    {
        $PolicyScanOutput.Configurations.RunbookCoreSetup.AzSkVersionForOrgUrl = $false
        WriteMessage "`t Missing Configuration: AzSkVersionForOrgUrl" $([MessageType]::Error)
        WriteMessage "`t Actual: $(IsStringEmpty($coreSetupAzSkVersionForOrgUrl))  `n`t Expected base Url: $(IsStringEmpty($AzSkVersionForOrgUrl))" $([MessageType]::Error)
    }
    
     if($PolicyScanOutput.Configurations.RunbookCoreSetup.AzSkVersionForOrgUrl)
    {
        WriteMessage "Status:   OK." $([MessageType]::Update)
        $PolicyScanOutput.Configurations.RunbookCoreSetup.Status = $true
    }
    else
    {
         WriteMessage "Status:   Failed." $([MessageType]::Error)
         $PolicyScanOutput.Configurations.RunbookCoreSetup.Status = $false
    }       
}
else
{
      WriteMessage "Status:   Skipped. RunbookCoreSetup not found." $([MessageType]::Info)
      $PolicyScanOutput.Configurations.RunbookCoreSetup.Status = $false
}

WriteMessage  "--------------------------------------------------------------------------------" $([MessageType]::Info)

#Check 06: Validate AzSKConfig
$PolicyScanOutput.Configurations.AzSKConfig = @{}
WriteMessage "Check 06: Check AzSKConfig configurations." $([MessageType]::Info)
$AzSKConfiguOutput = $PolicyScanOutput.Configurations.AzSKConfig
if($PolicyScanOutput.Policies.AzSKConfig)
{
   $AzSKConfigPath = $policyTempFolder + "3.1803.0\AzSK.json" #TODO:Constant
   $AzSKConfigContent =  Get-Content -Path $AzSKConfigPath | ConvertFrom-Json

   #Validate CurrentVersionForOrg     
   $RunbookCoreSetupUrl =  $RunbookCoreSetup.ICloudBlob.Uri.AbsoluteUri
    if($AzSKConfigContent.CASetupRunbookURL -and $AzSKConfigContent.CASetupRunbookURL -like "*$RunbookCoreSetupUrl*")
    {
        $AzSKConfiguOutput.CASetupRunbookUrl = $true
    }
    else
    {
        $AzSKConfiguOutput.CASetupRunbookUrl = $false
        WriteMessage "`t Missing Configuration: CASetupRunbookUrl" $([MessageType]::Error)
        WriteMessage "`t Actual: $(IsStringEmpty($($AzSKConfigContent.CASetupRunbookURL)))  `n`t Expected base Url: $(IsStringEmpty($($RunbookCoreSetupUrl)))" $([MessageType]::Error)
    } 
    
    #Validate ControlTelemetryKey 
    $appInsightResource= Get-AzureRMApplicationInsights -ResourceGroupName $appInsight.ResourceGroupName -Name $appInsight.Name
    $InstrumentationKey =  $appInsightResource.InstrumentationKey

    if($AzSKConfigContent.ControlTelemetryKey -and $AzSKConfigContent.ControlTelemetryKey -eq $InstrumentationKey)
    {
        $AzSKConfiguOutput.ControlTelemetryKey = $true
    }
    else
    {
        $AzSKConfiguOutput.ControlTelemetryKey = $false
        WriteMessage "`t Missing Configuration: ControlTelemetryKey" $([MessageType]::Error)
        WriteMessage "`t Actual: $(IsStringEmpty($($AzSKConfigContent.ControlTelemetryKey)))  `n`t Expected base Url: $(IsStringEmpty($($InstrumentationKey)))" $([MessageType]::Error)
    } 
    
    # Validate InstallationCommand     
    $installerUrl = $Installer.ICloudBlob.Uri.AbsoluteUri 
    if($AzSKConfigContent.InstallationCommand -and $AzSKConfigContent.InstallationCommand -like "*$installerUrl*") 
    {
        $AzSKConfiguOutput.InstallationCommand = $true
    }
    else
    {
        $AzSKConfiguOutput.InstallationCommand = $false
        WriteMessage "`t Missing Configuration: InstallationCommand" $([MessageType]::Error)
        WriteMessage "`t Actual: $(IsStringEmpty($($AzSKConfigContent.InstallationCommand)))  `n`t Expected base Url: $(IsStringEmpty($($installerUrl)))" $([MessageType]::Error)
    }


    # Validate PolicyOrgName    
    if($AzSKConfigContent.PolicyOrgName -and -not [string]::IsNullOrEmpty($AzSKConfigContent.PolicyOrgName) )
    {
        $PolicyScanOutput.Configurations.AzSKConfig.PolicyOrgName = $true
    }
    else
    {
        $AzSKConfiguOutput.PolicyOrgName = $false
        WriteMessage "`t Missing Configuration: PolicyOrgName" $([MessageType]::Error)
    }

    # Validate AzSKPre Url     
    $azSKPreUrl = $AzSKPre.ICloudBlob.Uri.AbsoluteUri 
    if($AzSKConfigContent.AzSKConfigURL -and $AzSKConfigContent.AzSKConfigURL -like "*$azSKPreUrl*")
    {
        $AzSKConfiguOutput.AzSKPreConfigURL = $true
    }
    else
    {
        $AzSKConfiguOutput.AzSKPreConfigURL = $false
        WriteMessage "`t Missing Configuration: AzSKPreConfigURL" $([MessageType]::Error)
        WriteMessage "`t Actual: $(IsStringEmpty($($AzSKConfigContent.AzSKConfigURL)))  `n`t Expected base Url: $(IsStringEmpty($($azSKPreUrl)))" $([MessageType]::Error)
    }
    
    if($AzSKConfiguOutput.CASetupRunbookUrl -and $AzSKConfiguOutput.ControlTelemetryKey -and $AzSKConfiguOutput.InstallationCommand -and $AzSKConfiguOutput.PolicyOrgName -and $AzSKConfiguOutput.AzSKPreConfigURL ) 
    {
        WriteMessage "Status:   OK." $([MessageType]::Update)
        $AzSKConfiguOutput.Status = $true
    }
    else
    {
        WriteMessage "Status:   Failed." $([MessageType]::Error)
        $AzSKConfiguOutput.Status = $false
    }           
}
else
{
      WriteMessage "Status:   Skipped. AzSKConfig not found." $([MessageType]::Info) 
      $AzSKConfiguOutput.Status = $false  
}

if(-not $PolicyScanOutput.Resources.Status -or $PolicyScanOutput.Policies.Status -or $InstallOutput.Status -or $PolicyScanOutput.Configurations.AzSKPre.Status -or  -not $PolicyScanOutput.Configurations.RunbookCoreSetup.Status -or  -not $AzSKConfiguOutput.Status)
{
    WriteMessage  "--------------------------------------------------------------------------------" $([MessageType]::Warning)
    WriteMessage "Found that Org policy configuration is not correctly setup.`nReview the failed check and follow the remedy suggested at FAQ: https://aka.ms/devopskit/orgpolicy/healthcheck" $([MessageType]::Warning) 
    WriteMessage  "--------------------------------------------------------------------------------" $([MessageType]::Warning)
}
else
{
     WriteMessage  "--------------------------------------------------------------------------------" $([MessageType]::Info)
     WriteMessage "Org policy configuration is in healthy state. `nFor other details, please follow FAQ: https://aka.ms/devopskit/orgpolicy/healthcheck" $([MessageType]::Info) 
     WriteMessage  "--------------------------------------------------------------------------------" $([MessageType]::Info)
}
WriteMessage "================================================================================" $([MessageType]::Info)


