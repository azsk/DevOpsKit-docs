$TenantId = ""
$SubscriptionId = ""
$RGName = ""
$Location = ""
$UserAssignedIdentityName = ""
$TargetSubscriptionIds = @() # Add target subscriptionds in place of <SubIdx>
$DeploymentFilesPath = ""


Connect-AzAccount -Tenant $TenantId
Connect-AzureAD -TenantId $TenantId

# Unblock the files and point current path to extracted folder location. Then load the AzTS Setup script in session.
Get-ChildItem -Path $DeploymentFilesPath -Recurse |  Unblock-File 
CD  $DeploymentFilesPath
. ".\AzTSSetup.ps1"

# Note: Make sure you copy  '.' present at the start of line.


# Step 1.1: Set context to subscription where user-assigned managed identity needs to be created.
Set-AzContext -SubscriptionId $SubscriptionId

# Step 1.2: Create resource group where user-assigned MI resource will be created. 
New-AzResourceGroup -Name $RGName -Location $Location

# Step 1.3: Create user-assigned managed identity 
$UserAssignedIdentity = Get-AzUserAssignedIdentity -ResourceGroupName $RGName -Name $UserAssignedIdentityName -ErrorAction SilentlyContinue
if($UserAssignedIdentity -eq $null)
{
    $UserAssignedIdentity = New-AzUserAssignedIdentity -ResourceGroupName $RGName -Name $UserAssignedIdentityName
}

# Step 1.4: Grant User Identity Reader permission on target subscription(s).

 $TargetSubscriptionIds | % {
    New-AzRoleAssignment -ApplicationId $UserAssignedIdentity.ClientId -Scope "/subscriptions/$_" -RoleDefinitionName "Reader"
 }

# Step 1.5: Grant Graph Permission to the user-assigned managed identity.
# NOTE: In order to grant Graph API permission, the signed-in user must be a member of one of the following administrator roles: Global Administrator, Security Administrator, Security Reader or User Administrator.
Grant-AzSKGraphPermissionToUserAssignedIdentity -ScanIdentityObjectId $UserAssignedIdentity.PrincipalId -AppPermissionsRequired "PrivilegedAccess.Read.AzureResources"

# Set the context to hosting subscription
Set-AzContext -SubscriptionId $SubscriptionId

# Step 2: Run installation command.
$DeploymentResult = Install-AzSKTenantSecuritySolution `
                -SubscriptionId $SubscriptionId `
                -ScanHostRGName $RGName `
                -ScanIdentityId $UserAssignedIdentity.Id `
                -Location $Location `
                -SendUsageTelemetry:$true `
                -ScanIdentityHasGraphPermission:$false `
                -Verbose

Update-AzSKAzureADApplicationRegistration -SubscriptionId $SubscriptionId -DeploymentResult $DeploymentResult
Grant-AzSKPermissionToUIADApplications -SubscriptionId $SubscriptionId -DeploymentResult $DeploymentResult

$InternalIdentityName = $DeploymentResult.Outputs.internalMIName.Value
Grant-AzSKGraphPermissionToUserAssignedIdentity -SubscriptionId $SubscriptionId -ResourceGroupName $RGName -IdentityName $InternalIdentityName -AppPermissionsRequired @('User.ReadBasic.All', 'User.Read.All', 'Directory.Read.All')



# Disconnect-AzAccount
# Disconnect-AzureAD