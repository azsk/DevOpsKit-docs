
 $subid = "<enter the subscription Id>"
 import-module AzSK

#=====================================================================
#AzSK PIM helper Commands : Refer https://github.com/azsk/DevOpsKit-docs/blob/master/01-Subscription-Security/Readme.md#azsk-privileged-identity-management-pim-helper-cmdlets-1
# There are two use cases for AzSK PIM commands: Admin and Owner
#--------------------------------------------------------
#For Admin
#--------------------------------------------------------
# To onboard a subscription to PIM, refer https://docs.microsoft.com/en-us/azure/active-directory/privileged-identity-management/pim-resource-roles-discover-resources#discover-resources

# Once the subscription/resource is onboarded you can assign PIM roles to users
    setpim -AssignRole -SubscriptionId $subid -RoleName 'Owner' -PrincipalName $userId -DurationInDays $days

# If you want to migrate existing permanent assignments for a particular role in the subscription, use the below command:
    setpim -AssignEligibleforPermanentAssignments -SubscriptionId $subid -RoleNames 'Owner' -DurationInDays $days 

# The above will only assign equivalent PIM role for permanent owners on the subscription. To remove those permanent assignments run the below command
    setpim -RemovePermanentAssignments -SubscriptionId $subid -RoleNames 'Owner' -RemoveAssignmentFor MatchingEligibleAssignments

# After the above assignments of PIM roles and removal of permanent assignments you can run the below commands to see PIM and permanent assignments
    getpim -ListPermanentAssignments -SubscriptionId $subid -RoleNames 'Owner'
    getpim -ListPIMAssignments -SubscriptionId $subid -RoleNames 'Owner'


# Extend the assignment duration by 'x' days for assignments that are going to expire in the next 'y' days
    setpim -ExtendExpiringAssignments -RoleNames 'Contributor' -SubscriptionId $subid -ExpiringInDays y -DurationInDays x # This  command works in interactive mode, add '-Force' switch to extend all assignments that are expiring in y days


#-------------------------------------------------------
# For users: 
#-------------------------------------------------------
# One can check the PIM assignments he has  by executing below
    getpim -ListMyEligibleRoles

# Once admin has set up the PIM users, they can activate their respective assignments by executing below
    setpim -ActivateMyRole -SubscriptionId $subid -RoleName 'Owner' -DurationInHours $days -Justification $justification

# User can deactivate their PIM assignments by executing the below command
    setpim -DeactivateMyRole -SubscriptionId $subid -RoleName 'Owner' 
