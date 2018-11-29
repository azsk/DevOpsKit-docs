Set-StrictMode -Version Latest 

# Class name must have Ext suffix. Class must be inherited from Feature class
class FeatureExt: Feature
{       
    FeatureExt([string] $subscriptionId, [SVTResource] $svtResource): 
        Base($subscriptionId, $svtResource) 
    { 
        $this.GetResourceObject();
    }
   

    hidden [ControlResult] FunctionToExtend([ControlResult] $controlResult)
    {
		# Your function logic goes here.
		return $controlResult;
    }
}
