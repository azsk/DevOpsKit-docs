Set-StrictMode -Version Latest

# Listener class name must have Ext suffix
# Listener class must be inherited from ListenerBase 
class ListenerNameExt: ListenerBase 
{

	# default constructor
    hidden ListenerNameExt() 
	{
    }

    hidden static [ListenerNameExt] $Instance = $null;

	# Create instance of class
    static [ListenerNameExt] GetInstance() 
	{
        if ( $null  -eq [ListenerNameExt]::Instance) 
		{
            [ListenerNameExt]::Instance = [ListenerNameExt]::new();
        }
        return [ListenerNameExt]::Instance
    }

    [void] RegisterEvents() 
	{
	
        $this.UnregisterEvents();

		# Below event will be triggered only once per execution when the run identifier is generated. The run identifier is unique for each scan. 
        $this.RegisterEvent([AzSKRootEvent]::GenerateRunIdentifier, {
            $currentInstance = [ListenerNameExt]::GetInstance();
            try
            {
				$runIdentifier = [AzSKRootEventArgument] ($Event.SourceArgs | Select-Object -First 1)
                $currentInstance.SetRunIdentifier($runIdentifier);
            }
            catch
            {
                $currentInstance.PublishException($_);
            }
        });
		

		# uncomment below code if the listener should handle CommandStarted event of SVTEvent 
		# $this.RegisterEvent([SVTEvent]::CommandStarted, {
			 # $currentInstance = [ListenerNameExt]::GetInstance();
			# try
			# {				
			# }
			# catch
			# {
				# $currentInstance.PublishException($_);
			# }
		# });
		
		
		# uncomment below code if the listener should handle CommandCompleted event of SVTEvent 
		# $this.RegisterEvent([SVTEvent]::CommandCompleted, {
            # $currentInstance = [ListenerNameExt]::GetInstance();
            # try 
            # {
			
            # }
            # catch 
            # {
                # $currentInstance.PublishException($_);
            # }
        # });
		
		
		# uncomment below code if the listener should handle CommandError event of SVTEvent
		# $this.RegisterEvent([SVTEvent]::CommandError, {
            # $currentInstance = [ListenerNameExt]::GetInstance();
            # try
            # {

            # }
            # catch
            # {
            # }
        # });
		
		
		# uncomment below code if the listener should handle EvaluationStarted event of SVTEvent 
		# $this.RegisterEvent([SVTEvent]::EvaluationStarted, {
            # $currentInstance = [ListenerNameExt]::GetInstance();
            # try 
            # {
				
            # }
            # catch 
            # {
                # $currentInstance.PublishException($_);
            # }
        # });
		
		
		# uncomment below code if the listener should handle EvaluationCompleted event of SVTEvent
		# $this.RegisterEvent([SVTEvent]::EvaluationCompleted, {
			# $currentInstance = [ListenerNameExt]::GetInstance();
			# try
			# {
				
			# }
			# catch
			# {
				# $currentInstance.PublishException($_);
			# }
		# });
		

		# uncomment below code if the listener should handle EvaluationError event of SVTEvent
		# $this.RegisterEvent([SVTEvent]::EvaluationError, {
            # $currentInstance = [ListenerNameExt]::GetInstance();
            # try
            # {

            # }
            # catch
            # {
            # }
        # });
		
		
		# uncomment below code if the listener should handle ControlStarted event of SVTEvent
		# $this.RegisterEvent([SVTEvent]::ControlStarted, {
            # $currentInstance = [WriteDetailedLog]::GetInstance();
            # try 
            # {
                
            # }
            # catch 
            # {
                # $currentInstance.PublishException($_);
            # }
        # });


		# uncomment below code if the listener should handle ControlCompleted event of SVTEvent
        # $this.RegisterEvent([SVTEvent]::ControlCompleted, {
            # $currentInstance = [WriteDetailedLog]::GetInstance();     
            # try 
            # {

            # }
            # catch 
            # {
                # $currentInstance.PublishException($_);
            # }
        # });

		
		# uncomment below code if the listener should handle ControlError event of SVTEvent
		# $this.RegisterEvent([SVTEvent]::ControlError, {
            # $currentInstance = [ListenerNameExt]::GetInstance();
            # try
            # {

            # }
            # catch
            # {
            # }
		# });
		
		
		# uncomment below code if the listener should handle CommandProcessing event of AzSKRootEvent
		# $this.RegisterEvent([AzSKRootEvent]::CommandProcessing, {
            # $currentInstance = [WriteDetailedLog]::GetInstance();
            # try 
            # {
				
			# }
            # catch 
            # {
                # $currentInstance.PublishException($_);
            # }
        # });
		
		
		# uncomment below code if the listener should handle PublishCustomData event of AzSKRootEvent
		# $this.RegisterEvent([AzSKRootEvent]::PublishCustomData, {
            # $currentInstance = [ListenerNameExt]::GetInstance();
            # try
            # {
			
            # }
            # catch
            # {
                # $currentInstance.PublishException($_);
            # }
        # });
		

		# uncomment below code if the listener should handle Exception event of AzSKGenericEvent
		# $this.RegisterEvent([AzSKGenericEvent]::Exception, {
            # $currentInstance = [ListenerNameExt]::GetInstance();
            # try
            # {
				
            # }
            # catch
            # {
            # }
        # });
		

		# uncomment below code if the listener should handle CommandError event of AzSKRootEvent
		# $this.RegisterEvent([AzSKRootEvent]::CommandError, {
            # $currentInstance = [ListenerNameExt]::GetInstance();
            # try
            # {
				
            # }
            # catch
            # {
            # }
        # });
		
		
		# uncomment below code if the listener should handle UnsupportedResources event of AzSKRootEvent
		# $this.RegisterEvent([AzSKRootEvent]::UnsupportedResources, {
			# $currentInstance = [ListenerNameExt]::GetInstance();
			# try 
			# {
				
			# }
			# catch 
			# {
				# $currentInstance.PublishException($_);
			# }
        # });

		
		# uncomment below code if the listener should handle WriteCSV event of AzSKRootEvent
		# $this.RegisterEvent([AzSKRootEvent]::WriteCSV, {
            # $currentInstance = [ListenerNameExt]::GetInstance();
            # try 
            # {
				
            # }
            # catch 
            # {
                # $currentInstance.PublishException($_);
            # }
        # });
		
    }
}
