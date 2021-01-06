
#****************** Prerequisite *****************

# *** 1. Validate prerequisites on machine
    #Ensure that you are using Windows OS and have PowerShell version 5.0 or higher

    $PSVersionTable

# *** 2. Installing Az Modules
    # Install Az Modules
    Install-Module -Name Az.Accounts -AllowClobber -Scope CurrentUser -repository PSGallery
    Install-Module -Name Az.Resources -AllowClobber -Scope CurrentUser -repository PSGallery
    Install-Module -Name Az.Storage -AllowClobber -Scope CurrentUser -repository PSGallery
    Install-Module -Name Az.ManagedServiceIdentity -AllowClobber -Scope CurrentUser -repository PSGallery

# *** 3. Setting up scanning identity   
        #Before creating user-assigned managed identity, please connect to AzureAD and AzAccount with the tenant Id where you want to use AzTS solution.
        Connect-AzAccount -Tenant <TenantId>
        Connect-AzureAD -TenantId <TenantId>

    # i) You can create user-assigned managed identity with below PowerShell command 
            # Step 1: Set context to subscription where user-assigned managed identity needs to be created
            Set-AzContext -SubscriptionId "<MIHostingSubId>"

            # Step 2: Create resource group where user-assigned MI resource will be created. 
            New-AzResourceGroup -Name "<MIHostingRGName>" -Location "<Location>"

            # Step 3: Create user-assigned managed identity 
            $UserAssignedIdentity = New-AzUserAssignedIdentity -ResourceGroupName "<MIHostingRGName>" -Name "<USER ASSIGNED IDENTITY NAME>"

            # Step 4: Save resource id generated for user identity using below command. This will be used in AzTS Soln installation. 

            $UserAssignedIdentity.Id

    # ii) Assign reader access to user-assigned managed identity on target subscriptions to be scanned.

            # Add target subscriptionds in place of <SubIdx>
            $TargetSubscriptionIds = @("<SubId1>","<SubId2>","<SubId3>")

            $TargetSubscriptionIds | % {
            New-AzRoleAssignment -ApplicationId $UserAssignedIdentity.ClientId -Scope "/subscriptions/$_" -RoleDefinitionName "Reader"
            }


# *** 3. Set context and validate you have 'Owner' access on subscrption where solution needs to be installed ****

    # Set the context to hosting subscription
    $HostSubscriptionId = "<HostSubscriptionId>"

    Set-AzContext -SubscriptionId  $HostSubscriptionId


# **** 4. Download and extract deployment template

    # i) Download deployment package zip from link (https://aka.ms/DevOpsKit/AzTS/DeploymentTemplate) to your local machine. 
    
    # ii) Extract zip to local folder location

    # iii) Unblock the content. Below command will help to unblock files.

        # Set extracted folder path
        $DeploymentTemplateFolderPath = "<ExtractedFolderPath>"

        # Unblock files
        Get-ChildItem -Path $DeploymentTemplateFolderPath -Recurse |  Unblock-File 

    # iv) Point current path to deployment folder and load AzTS setup script

        # Point current path to extracted folder location and load setup script from deploy folder 

            CD "$DeploymentTemplateFolderPath"

        # Load AzTS Setup script in session

            . ".\AzTSSetup.ps1"


# **** 5. Run Setup Command
    # Set the context to hosting subscription
        Set-AzContext -SubscriptionId "<HostingSubId>"


    # Provide resource group name where resources will be created
    $ScanHostRGName = "<ResourceGroupName>"  #RG name where  
    $Location = "<ResourceLocation>"  # eg. EastUS2

    # Run install solution command 
    Install-AzSKTenantSecuritySolution `
                    -SubscriptionId $HostSubscriptionId `
                    -ScanHostRGName $ScanHostRGName `
                    -ScanIdentityId $UserAssignedIdentity.Id `
                    -Location $Location `
                    -Verbose
