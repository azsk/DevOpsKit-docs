Set-StrictMode -Version Latest

# Class name must be SubscriptionCoreExt. Class must be inherited from SubscriptionCore class
class SubscriptionCoreExt: SubscriptionCore
{
    SubscriptionCoreExt([string] $subscriptionId):
    Base($subscriptionId)
    {       
        
    }

    hidden [ControlResult] CheckSubscriptionAdminCountExtension([ControlResult] $controlResult)
    {
        # Your function logic goes here.
        return $controlResult;
    }
}
