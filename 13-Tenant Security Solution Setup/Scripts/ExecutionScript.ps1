
#****************** Prerequisite *****************

# *** 1. Install required modules ***

    # Install Az Modules
    Install-Module -Name Az -AllowClobber -Scope CurrentUser -repository PSGallery

    # Install managed identity service module
    Install-Module -Name Az.ManagedServiceIdentity -AllowClobber -Scope CurrentUser -repository PSGallery

# *** 2. Create central scanning identity and assign reader role to subscriptions on which scan needs to be performed   

    # Step 1: Set context to subscription where central scan user-assigned managed identity needs to be created
    # Login to Azure  
    Connect-AzAccount
    
    Set-AzContext -SubscriptionId  "<MIHostingSubId>"

    # Step 2: Create User Identity 
    $UserAssignedIdentity = New-AzUserAssignedIdentity -ResourceGroupName "<MIHostingRG>" -Name "<USER ASSIGNED IDENTITY NAME>"

    # Step 3: Keep resource id generated for user identity using below command. This will be used in AzTS Soln installation

    $UserAssignedIdentity.Id

    # Step 4: Assign user identity with reader role on all the subscriptions which needs to be scanned. 
    # Below command help to assign access to single subscription or MG. 
    # You need to repeat below step for all subscription or assign role at MG level

    New-AzRoleAssignment -ApplicationId $UserAssignedIdentity.ClientId `
    -Scope "<SubscriptionScope or ManagedGroupScope>" `
    -RoleDefinitionName "Reader"


# *** 3. Set context and validate you have 'Owner' access on subscrption where solution needs to be installed ****

    # Set the context to hosting subscription
    $HostSubscriptionId = "<HostSubscriptionId>"

    Set-AzContext -SubscriptionId  $HostSubscriptionId

    # Validate your id is listed as Owner on subscription 
    Get-AzRoleAssignment | Where-Object {$_.RoleDefinitionName -eq "Owner" -and $_.Scope -eq "/subscriptions/$HostSubscriptionId" } `
    | select DisplayName, SignInName

# **** 4. Download and extract deployment template

    # Download deployment from link: https://aka.ms/DevOpsKit/AzTS/DeploymentTemplate
    
    # Extract zip into local folder 


    # Set extracted folder path
    $DeploymentTemplateFolderPath = "<ExtractedFolderPath>"

    # Unblock files
    Get-ChildItem -Path $DeploymentTemplateFolderPath -Recurse |  Unblock-File 


#****************** Prerequisite Completed ***************** 
   


#****************** Setup Start *****************


# ****1. Point current path to extracted folder location and load setup script from deploy folder 

    CD "$DeploymentTemplateFolderPath"

    . ".\AzTSSetup.ps1"


# ****2. Run installation command. 

    # Provide resource group name where resources will be created
    $ResourceGroupName = "<ResourceGroupName>"  #Provider 
    $Location = "<ResourceLocation>"  # eg. EastUS2

    # Run install solution command 
    Install-AzSKTenantSecuritySolution `
                    -SubscriptionId $HostSubscriptionId `
                    -ScanHostRGName $ResourceGroupName `
                    -ScanIdentityId $UserAssignedIdentity.Id `
                    -Location $Location `
                    -Verbose
