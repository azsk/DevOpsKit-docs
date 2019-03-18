Set-StrictMode -Version Latest
class AppInsights: SVTBase
{
    hidden [PSObject] $ResourceObject;

    AppInsights([string] $subscriptionId, [SVTResource] $svtResource):
        Base($subscriptionId, $svtResource)
    {
        $this.GetResourceObject();
    }

    hidden [PSObject] GetResourceObject()
    {
        if (-not $this.ResourceObject)
        {
            # Get resource details from AzureRm
            $this.ResourceObject = Get-AzureRmApplicationInsights -Name $this.ResourceContext.ResourceName -ResourceGroupName $this.ResourceContext.ResourceGroupName -Full 

            if(-not $this.ResourceObject)
            {
                throw ([SuppressedException]::new(("Resource '$($this.ResourceContext.ResourceName)' not found under Resource Group '$($this.ResourceContext.ResourceGroupName)'"), [SuppressedExceptionType]::InvalidOperation))
            }
            
        }

        return $this.ResourceObject;
    }
}