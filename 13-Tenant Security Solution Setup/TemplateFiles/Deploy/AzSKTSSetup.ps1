
function Install-AzSKTenantSecuritySolution
{
    <#
	.SYNOPSIS
	This command would help in installing Automation Account in your subscription to setup Continuous Assurance feature of AzSK 
	.DESCRIPTION
	This command will install an Automation Account (Name: AzSKContinuousAssurance) which runs security scan on subscription and resource groups which are specified during installation.
	Security scan results will be populated in Log Analytics workspace which is configured during installation. Also, detailed logs will be stored in storage account (Name: azskyyyyMMddHHmmss format).  
	
	.PARAMETER SubscriptionId
		Subscription id in which Automation Account needs to be installed.
	.PARAMETER ScanHostRGName
		Location of resource group which contains Automation Account. This is optional. Default location is EastUS2.
	.PARAMETER Location
		Name of ResourceGroup where AutomationAccount will be installed.
	.PARAMETER ScanIdentityId
		Name of AutomationAccount. Default value is AzSKContinuousAssurance.
	.PARAMETER ManagementGroupId
        Comma separated Application resource group names on which security scan should be performed by Automation Account.
    .PARAMETER TemplateFilePath
        Comma separated Application resource group names on which security scan should be performed by Automation Account.
     .PARAMETER TemplateParameters
        Comma separated Application resource group names on which security scan should be performed by Automation Account.
     .PARAMETER EnableScaleOutRule
        Comma separated Application resource group names on which security scan should be performed by Automation Account.
    .NOTES
	

	.LINK
	https://aka.ms/azskossdocs 

	#>
    Param(
        
        [string]
        [Parameter(Mandatory = $true, HelpMessage="Comma separated values of target subscriptionIds that will be monitored through CA from a central subscription.")]
        $SubscriptionId,

        [string]
		[Parameter(Mandatory = $true, HelpMessage="Comma separated values of target subscriptionIds that will be monitored through CA from a central subscription.")]
		$ScanHostRGName,

        [string]
        [Parameter(Mandatory = $true)]
        $Location,

        [string]
        [Parameter(Mandatory = $true)]
        $ScanIdentityId,

        [string]
        [Parameter(Mandatory = $false)]
        $ManagementGroupId,

        [string]
        [Parameter(Mandatory = $false)]
        $TemplateFilePath = ".\AzSKTSDeploymentTemplate.json",

        [Hashtable]
        [Parameter(Mandatory = $false)]
        $TemplateParameters = @{},

        [switch]
        [Parameter(Mandatory = $false)]
        $EnableScaleOutRule
        )

        Begin
        {
            $currentContext = $null
            $contextHelper = [ContextHelper]::new()
            $currentContext = $contextHelper.SetContext($SubscriptionId)
            if(-not $currentContext)
            {
                return;
            }
        }

        Process
        {
            Write-Host $([Constants]::DoubleDashLine)
            Write-Host "Running Tenant Security Solution setup...`n" -ForegroundColor $([Constants]::MessageType.Info)
            Write-Host $([Constants]::InstallSolutionInstructionMsg ) -ForegroundColor $([Constants]::MessageType.Info)
            Write-Host $([Constants]::SingleDashLine)
            
            Write-Host "Note: This Tenant Security Solution setup is currently under preview..." -ForegroundColor $([Constants]::MessageType.Warning)
            
            
            Write-Host "`r`nStarted setting up Tenant Security Solution. This may take a while..." -ForegroundColor $([Constants]::MessageType.Info)
           
            # Create resource group if not exist
            try
            {
                Write-Verbose "$(Get-TimeStamp)Checking resource group for deployment..." #-ForegroundColor $([Constants]::MessageType.Info)
                $rg = Get-AzResourceGroup -Name $ScanHostRGName -ErrorAction SilentlyContinue
                if(-not $rg)
                {
                    Write-Verbose "$(Get-TimeStamp)Creating resource group for deployment..." #-ForegroundColor $([Constants]::MessageType.Info)
                    $rg = New-AzResourceGroup -Name $ScanHostRGName -Location $Location -ErrorAction Stop
                }
                else{
                    Write-Verbose "$(Get-TimeStamp)Resource group already exists." #-ForegroundColor $([Constants]::MessageType.Info)
                }
                
            }
            catch
            {  
                Write-Host "`n`rFailed to create resource group for deployment." -ForegroundColor $([Constants]::MessageType.Error)
                return;
            }
                        
	        # start arm template deployment
            try
            {
                # if($TemplateParameters.Count -eq 0)
                # {
                #     Write-Host "`n`rPlease enter the parameter required for template deployment:" -ForegroundColor $([Constants]::MessageType.Info)   
                #     Write-Host "Note: Alternatively you can use '-TemplateParameters' to pass these parameters.`n`r"  -ForegroundColor $([Constants]::MessageType.Warning)   
                # }

                $TemplateParameters.Add("MIResourceId", $ScanIdentityId)
                $TemplateParameters.Add("TenantId",$currentContext.Tenant.Id)
                if(!$ManagementGroupId)
                {
                    $ManagementGroupId = $currentContext.Tenant.Id
                }
                $TemplateParameters.Add("ManagementGroupId",$ManagementGroupId)
                Write-Verbose "$(Get-TimeStamp)Checking resource deployment template..." #-ForegroundColor $([Constants]::MessageType.Info)
                $validationResult = Test-AzResourceGroupDeployment -Mode Incremental -ResourceGroupName $ScanHostRGName -TemplateFile $TemplateFilePath -TemplateParameterObject $TemplateParameters 
                if($validationResult)
                {
                    Write-Host "`n`rTemplate deployment validation returned following errors:" -ForegroundColor $([Constants]::MessageType.Error)
                    $validationResult | FL Code, Message;
                    return;
                }
                else
                {
                    # Deploy template
                    $deploymentName = "tdenvironmentsetup-$([datetime]::Now.ToString("yyyymmddThhmmss"))"
                    $deploymentResult = New-AzResourceGroupDeployment -Name $deploymentName -Mode Incremental -ResourceGroupName $ScanHostRGName -TemplateFile $TemplateFilePath -TemplateParameterObject $TemplateParameters  -ErrorAction Stop #-verbose 
                    Write-Verbose "$(Get-TimeStamp)Completed resources deployment for tenant security solution."
                }                
            }
            catch
            {
                Write-Host "`rTemplate deployment returned following errors: [$($_)]." -ForegroundColor $([Constants]::MessageType.Error)
                return;
            }

            # Post deployment steps
            Write-Verbose "$(Get-TimeStamp)Starting post deployment environment steps.." 
            try
            {
                # Check if queue exist; else create new queue
                $storageAccountName = [string]::Empty;
                $storageQueueName = [string]::Empty;
                Write-Verbose "$(Get-TimeStamp)Creating Storage queue to queue the subscriptions for scan.." #-ForegroundColor $([Constants]::MessageType.Info)
                if( $deploymentResult.Outputs.ContainsKey('storageId') -and $deploymentResult.Outputs.ContainsKey('storageQueueName'))
                {
                    $storageAccountName = $deploymentResult.Outputs.storageId.Value.Split("/")[-1]
                    $storageQueueName = $deploymentResult.Outputs.storageQueueName.Value
                    $storageAccountKey = Get-AzStorageAccountKey -ResourceGroupName $ScanHostRGName -Name $storageAccountName -ErrorAction Stop
                    if(-not $storageAccountKey)
                    {
                        throw [System.ArgumentException] ("Unable to fetch 'storageAccountKey'. Please check if you have the access to read storage key.");
                    }
                    else
                    {
                        $storageAccountKey = $storageAccountKey.Value[0]
                    }

                    $storageContext = New-AzStorageContext -StorageAccountName $storageAccountName  -StorageAccountKey $storageAccountKey -ErrorAction Stop
                    $storageQueue = Get-AzStorageQueue -Name $storageQueueName -Context $storageContext -ErrorAction SilentlyContinue
                    if(-not $storageQueue)
                    {   
                        $storageQueue = New-AzStorageQueue -Name $storageQueueName -Context $storageContext -ErrorAction Stop
                    }

                    
                }
                else
                {
                    Write-Host "Failed to create Storage queue." -ForegroundColor $([Constants]::MessageType.Error)
                    return
                }

                if($EnableScaleOutRule)
                {
                    Write-Verbose "$(Get-TimeStamp)Creating auto scale rule.." #-ForegroundColor $([Constants]::MessageType.Info)
                    #Get input parameters from output result
                    $autoScaleInputParameters = @{}
                    $deploymentResult.Outputs.Keys | % {$autoScaleInputParameters.Add($_, $deploymentResult.Outputs.$_.Value ) };

                    $validationResult = Test-AzResourceGroupDeployment -Mode Incremental -ResourceGroupName $ScanHostRGName -TemplateFile "AutoScaleRule.json" -TemplateParameterObject $autoScaleInputParameters 
                    if($validationResult)
                    {
                        Write-Host "`n`rAuto scale template deployment validation returned following errors:" -ForegroundColor $([Constants]::MessageType.Error)
                        $validationResult | FL Code, Message;
                        return;
                    }
                    else
                    {
                        # Deploy template
                        $deploymentName = "tdautoscalrulesetup-$([datetime]::Now.ToString("yyyymmddThhmmss"))"
                        $deploymentResult = New-AzResourceGroupDeployment -Name $deploymentName -Mode Incremental -ResourceGroupName $ScanHostRGName -TemplateFile "AutoScaleRule.json" -TemplateParameterObject $autoScaleInputParameters -ErrorAction Stop 
                        Write-Verbose "$(Get-TimeStamp)Completed auto scale rule creation." #-ForegroundColor $([Constants]::MessageType.Update)
                    }      
                }

                Write-Host "`rCompleted installation for Tenant Security Solution." -ForegroundColor $([Constants]::MessageType.Update)
                Write-Host "$([Constants]::DoubleDashLine)" #-ForegroundColor $([Constants]::MessageType.Info)
                Write-Host "$([Constants]::NextSteps)" -ForegroundColor $([Constants]::MessageType.Info)
                Write-Host "$([Constants]::DoubleDashLine)"
            }
            catch
            {
                Write-Host "Error occured while executing post deployment steps. ErrorMessage [$($_)]" -ForegroundColor $([Constants]::MessageType.Error)
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

    static [string] $InstallSolutionInstructionMsg = "This command will perform 3 important operations. It will:`r`n`n" + 
					"   [1] Create resources needed to support Tenant security scan `r`n" +
                    "   [2] Deploy three jobs to app services `r`n" +
                    "       (a) Inventory Job: Collects subscription, management group inventory `r`n" +
                    "       (b) WorkItem processor Job: Push subscription list to queue `r`n" +
                    "       (c) Subscription processor Job: Read subscriptions from queue and scan resources`r`n" +
					"   [3] Schedule daily subscription scan `r`n`n" +
                    "More details about resources created can be found in the link: http://aka.ms/DevOpsKit/TenantSecuritySetup `r`n"
    static [string] $DoubleDashLine    = "================================================================================"
    static [string] $SingleDashLine    = "--------------------------------------------------------------------------------"
    
    static [string] $NextSteps = "** Next steps **`r`n" + 
    "        a) Tenant security scan will start on scheduled time (UTC 00:00).`r`n" +
    "        b) After scan completion, All security control results will be sent to LA workspace and Storage account present in central scan RG.`r`n" +
    "        c) You can create compliance monitoring Power BI dashboard using link: http://aka.ms/DevOpsKit/TenantSecurityDashboard .`r`n" +
    "        d) For any feedback contact us at: azsksupext@microsoft.com .`r`n"
}

class ContextHelper
{

    $currentContext = $null;

    [PSObject] SetContext([string] $SubscriptionId)
    {
            $this.currentContext = $null
            if(-not $SubscriptionId)
            {

                Write-Host "The argument 'SubscriptionId' is null. Please specify a valid subscription id." -ForegroundColor $([Constants]::MessageType.Error)
                return $null;
            }

            # Login to Azure and set context
            try
            {
                if(Get-Command -Name Get-AzContext -ErrorAction Stop)
                {
                    $this.currentContext = Get-AzContext -ErrorAction Stop
                    $isLoginRequired = (-not $this.currentContext) -or (-not $this.currentContext | GM Subscription) -or (-not $this.currentContext | GM Account)
                    
                    # Request login if context is empty
                    if($isLoginRequired)
                    {
                        Write-Host "No active Azure login session found. Initiating login flow..." -ForegroundColor $([Constants]::MessageType.Warning)
                        $this.currentContext = Connect-AzAccount -ErrorAction Stop # -SubscriptionId $SubscriptionId
                    }
            
                    # Switch context if the subscription in the current context does not the subscription id given by the user
                    $isContextValid = ($this.currentContext) -and ($this.currentContext | GM Subscription) -and ($this.currentContext.Subscription | GM Id)
                    if($isContextValid)
                    {
                        # Switch context
                        if($this.currentContext.Subscription.Id -ne $SubscriptionId)
                        {
                            $this.currentContext = Set-AzContext -SubscriptionId $SubscriptionId -ErrorAction Stop
                        }
                    }
                    else
                    {
                        Write-Host "Invalid PS context. ErrorMessage [$($_)]" -ForegroundColor $([Constants]::MessageType.Error)
                    }
                }
                else
                {
                    Write-Host "Az command not found. Please run the following command 'Install-Module Az -Scope CurrentUser -Repository 'PSGallery' -AllowClobber -SkipPublisherCheck' to install Az module." -ForegroundColor $([Constants]::MessageType.Error)
                }
            }
            catch
            {
                Write-Host "Error occured while logging into Azure. ErrorMessage [$($_)]" -ForegroundColor $([Constants]::MessageType.Error)
                return $null;
            }

            return $this.currentContext;
    
    }
    
}

function Get-TimeStamp {
    return "{0:h:m:s tt} - " -f (Get-Date)
}
