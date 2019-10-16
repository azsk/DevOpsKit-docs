 

 $subid = '<enter the subscription Id>'
 import-module AzSK 

 

#===================================================================== 

# AzSK PIM helper Commands : Refer https://github.com/azsk/DevOpsKit-docs/blob/master/01-Subscription-Security/Readme.md#azsk-privileged-identity-management-pim-helper-cmdlets-1 

# There are two use cases for AzSK PIM commands: Admin and Owner 

#-------------------------------------------------------- 

# For Admins 

#-------------------------------------------------------- 

# To onboard a subscription to PIM, refer https://docs.microsoft.com/en-us/azure/active-directory/privileged-identity-management/pim-resource-roles-discover-resources#discover-resources 

# Assuming the subscription/resource is onboarded you can assign PIM roles to users 

    $days = <desiredDurationInDays> 
    $userId = <targetUserUPN> 
    setpim -AssignRole -SubscriptionId $subid -RoleName 'Owner' -PrincipalName $userId -DurationInDays $days 
 

# If it is likely that you have a lot of permanent assignments and you need to migrate those users to PIM-based model. 
# This can be achieve in 2 steps... first 'mirror' the permanent memberships as PIM assignments and then remove permanent ones 

# Step-1: To mirror existing permanent assignments for a particular role in the subscription, use the below command: 

    setpim -AssignEligibleforPermanentAssignments -SubscriptionId $subid -RoleNames 'Owner' -DurationInDays $days   

# Step-2: To remove those permanent assignments (that should now have matching PIM assignments) run the below command 

    setpim -RemovePermanentAssignments -SubscriptionId $subid -RoleNames 'Owner' -RemoveAssignmentFor MatchingEligibleAssignments  

# You can validate expected changes by checking the current state of PIM and permanent assignments as below: 

    getpim -ListPermanentAssignments -SubscriptionId $subid -RoleNames 'Owner' 

    getpim -ListPIMAssignments -SubscriptionId $subid -RoleNames 'Owner' 

# Note that the commands above can in general be used to check permanend and PIM-assigned members for various scopes and roles. 
 

# Once you have assigned members, periodically, their assignments will near expiry (or may expire) and will need renewal. 

# This can be done by using appropriate values below (extend by 'x' days assignments that are going to expire in the next 'y' days) for the given role and scope 

    setpim -ExtendExpiringAssignments -RoleNames 'Contributor' -SubscriptionId $subid -ExpiringInDays y -DurationInDays x # Use '-Force' switch to extend all assignments without interactive workflow 

 

# See the DevOps Kit PIM docs (links above) for more. 
 

#------------------------------------------------------- 

# For End Users:  

#------------------------------------------------------- 

# As a user you can check your current PIM assignments by using: 

    getpim -ListMyEligibleRoles 

 

# Activating and deactivating assigned roles is a snap. To activate, you can use a command such as: 

    setpim -ActivateMyRole -SubscriptionId $subid -RoleName 'Owner' -DurationInHours $days -Justification $justification 

 

# The above assignment can be deactivated using: 

    setpim -DeactivateMyRole -SubscriptionId $subid -RoleName 'Owner' 
