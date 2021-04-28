
#****************** Prerequisite *****************

# *** 1 of 6. Validate prerequisites on machine
    #Ensure that you are using Windows OS and have PowerShell version 5.0 or higher

    $PSVersionTable

# *** 2 of 6. Installing Az Modules
    # Install Az Modules
    Install-Module -Name Az.Accounts -AllowClobber -Scope CurrentUser -repository PSGallery
    Install-Module -Name Az.Resources -AllowClobber -Scope CurrentUser -repository PSGallery
    Install-Module -Name Az.Storage -AllowClobber -Scope CurrentUser -repository PSGallery
    Install-Module -Name Az.ManagedServiceIdentity -AllowClobber -Scope CurrentUser -repository PSGallery
    Install-Module -Name Az.Monitor -AllowClobber -Scope CurrentUser -repository PSGallery

# **** 3 of 6. Download and extract deployment template

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

# *** 4 of 6. Setting up scanning identity   
        #Before creating user-assigned managed identity, please connect to AzureAD and AzAccount with the tenant Id where you want to use AzTS solution.
        
        # Clear existing login, if any
        Disconnect-AzAccount
        Disconnect-AzureAD

        # Connect to AzureAD and AzAccount
        Connect-AzAccount -Tenant <TenantId>
        Connect-AzureAD -TenantId <TenantId>

        # i) You can create user-assigned managed identity (MI) with below PowerShell command 

            # Subscription id in which scanner MI needs to be created.
            $MIHostingSubId = "<MIHostingSubId>"
            
            # Resource group name in which scanner MI needs to be created.
            $MIHostingRGName = "<MIHostingRGName>"
            
            # Location in which scanner MI needs to be created.
            # Note: For better performance, we recommend hosting the MI and resources setup using AzTS Soln installation command in one location.
            $Location = "<Location>"
            
            # Name of the scanner MI.
            $MIName = "<USER ASSIGNED IDENTITY NAME>"
            
            # List of target subscription(s) that needs to be scanned by AzTS.
            # This command assigns 'Reader' access to user-assigned managed identity on target subscriptions. Add target subscriptionds in place of <SubIdx>
            $TargetSubscriptionIds = @("<SubId1>","<SubId2>","<SubId3>")
            
            # Step 1: Create user-assigned managed identity
            $UserAssignedIdentity = Set-AzSKTenantSecuritySolutionScannerIdentity -SubscriptionId $MIHostingSubId `
                                                                                    -ResourceGroupName $MIHostingRGName `
                                                                                    -Location $Location `
                                                                                    -UserAssignedIdentityName $MIName `
                                                                                    -TargetSubscriptionIds $TargetSubscriptionIds
            
            # Step 2: Save resource id and principal Id generated for user identity using below command. This will be used in AzTS Soln installation. 
            
            $UserAssignedIdentity.Id
            $UserAssignedIdentity.PrincipalId

        # ii) Grant user-assigned managed identity read access to Privileged Identity Management APIs for Azure resources.
           
            # Grant Graph Permission to the user-assigned managed identity.
            # NOTE: This step requires admin consent. Therefore, the signed-in user must be a member of one of the following administrator roles:
            # Required Permission: Global Administrator, Privileged Role Administrator, Application Administrator or Cloud Application Administrator.
            Grant-AzSKGraphPermissionToUserAssignedIdentity -ScanIdentityObjectId $UserAssignedIdentity.PrincipalId -AppPermissionsRequired @("PrivilegedAccess.Read.AzureResources", "Directory.Read.All")

            # If you do not have the permission required to complete this step, please contact your administrator.
            # To proceed without this step, set the value of "-ScanIdentityHasGraphPermission" parameter to false in AzTS installation command. Example: -ScanIdentityHasGraphPermission:$false.
            # By setting '-ScanIdentityHasGraphPermission' to $false, you are choosing to disable features dependent on Graph API.
            # Read more about this under the section "Step 4 of 6. Setting up scanning identity" in GitHub doc.

# *** 5 of 6. Setup Azure AD application for AzTS UI and API
           
        # Step 1: Setup AD application for AzTS UI and API

            # OPTION 1: Use following command to use an existing AD application or provide a custom name for Azure AD application.
            # Name of the Azure AD application to be used by AzTS API
            $WebAPIAzureADAppName  = "<WebAPIAzureADAppName>" 

            # Name of the Azure AD application to be used by AzTS UI
            $UIAzureADAppName = "<UIAzureADAppName>"

            $ADApplicationDetails = Set-AzSKTenantSecurityADApplication -WebAPIAzureADAppName $WebAPIAzureADAppName -UIAzureADAppName $UIAzureADAppName
            
            
            # OPTION 2: Use the default naming convention.
            # Subscription id in which Azure Tenant Security Solution needs to be installed.
            $HostSubscriptionId = "<HostSubscriptionId>" 

            # Resource group name in which Azure Tenant Security Solution needs to be installed.
            $HostResourceGroupName = "<HostResourceGroupName>"

            $ADApplicationDetails = Set-AzSKTenantSecurityADApplication -SubscriptionId $HostSubscriptionId -ScanHostRGName $HostResourceGroupName
         
        # Step 2: Save WebAPIAzureADAppId and UIAzureADAppId generated for Azure AD application using below command. This will be used in AzTS Soln installation. 
        
        $ADApplicationDetails.WebAPIAzureADAppId
        $ADApplicationDetails.UIAzureADAppId  

            
# *** 6 of 6. Set context and validate you have 'Owner' access on subscrption where solution needs to be installed ****

        # Run Setup Command
        # i) Set the context to hosting subscription
        $HostSubscriptionId = "<HostSubscriptionId>"

        Set-AzContext -SubscriptionId  $HostSubscriptionId

        # Provide resource group name where resources will be created
        $ScanHostRGName = "<ResourceGroupName>"  #RG name where solution needs to be installed 
        $Location = "<ResourceLocation>"  # eg. EastUS2
        $EmailIds =  @('<EmailId1>', '<EmailId2>', '<EmailId3>') # Comma-separated list of user email ids who should be sent the monitoring email.

        # ii) Run install solution command 
        $DeploymentResult = Install-AzSKTenantSecuritySolution `
                        -SubscriptionId $HostSubscriptionId `
                        -ScanHostRGName $ScanHostRGName `
                        -ScanIdentityId $UserAssignedIdentity.Id `
                        -Location $Location `
                        -WebAPIAzureADAppId $ADApplicationDetails.WebAPIAzureADAppId `
                        -UIAzureADAppId $ADApplicationDetails.UIAzureADAppId `
                        -SendUsageTelemetry:$true `
                        -ScanIdentityHasGraphPermission:$false `
                        -SendAlertNotificationToEmailIds $EmailIds `
                        -Verbose

        # iii) Save internal user-assigned managed identity name generated using below command. This will be used to grant Graph permission to internal MI.
        $InternalIdentityName = $DeploymentResult.Outputs.internalMIName.Value

        # iv) Grant internal MI 'User.Read.All' permission.

        # **Note:** To complete this step, signed-in user must be a member of one of the following administrator roles: </br>
        # Required Permission: Global Administrator, Privileged Role Administrator, Application Administrator or Cloud Application Administrator. 
        # If you do not have the required permission, please contact your administrator.
        # Read more about this under the section "Step 6 of 6. Run Setup Command" in GitHub doc.

        Grant-AzSKGraphPermissionToUserAssignedIdentity `
                          -SubscriptionId $HostSubscriptionId `
                          -ResourceGroupName $ScanHostRGName `
                          -IdentityName $InternalIdentityName `
                          -AppPermissionsRequired @('User.Read.All')

