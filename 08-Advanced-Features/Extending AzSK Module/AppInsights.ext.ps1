Set-StrictMode -Version Latest
    
# Class name must have Ext suffix. Class must be inherited from Feature class
class AppInsightsExt: AppInsights
{       
    AppInsightsExt([string] $subscriptionId, [SVTResource] $svtResource):
        Base($subscriptionId, $svtResource)
    { 
        $this.GetResourceObject();
    }

    hidden [ControlResult] CheckAIPricingPlan([ControlResult] $controlResult)
    {
        # Your function logic goes here.
        Write-Host("Checking AI pricing plan...")
        $ai = $this.ResourceObject
        if ($ai.PricingPlan -eq 'Limited Basic')
        {
            $controlResult.VerificationResult = [VerificationResult]::Failed
            $controlResult.AddMessage("AI: Use an enterprise grade pricing plan other than ‘Limited Basic’");
        }
        else {
            $controlResult.VerificationResult = [VerificationResult]::Passed
            $controlResult.AddMessage("AI: Non-basic plan is used per expectation!");
        }
        return $controlResult;
    }
} 