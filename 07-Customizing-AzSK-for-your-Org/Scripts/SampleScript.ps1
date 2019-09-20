# Variables used
=============================================
$subId = ''#Enter the SubscriptionGuid id here
$oName = '' #Enter the name for your organization so that the policy name can use that
$depName = '' #Enter the name for your dept so that the policy name can use that
$policyFolder = "" # Enter the folder path where you want to keep org policy files 
$policyDownloadFolder = $policyFolder+'_Dwn' 


# 1) Setting up org policy: Refer https://github.com/azsk/DevOpsKit-docs/tree/master/07-Customizing-AzSK-for-your-Org#setting-up-org-policy for details
#==============================================================================================================
install-module AzSK -Scope CurrentUser -AllowClobber -Repository AzSKStaging -Force
import-Module $azSKModuleName
Write-Host "Import completed for [$azSKModuleName]!"
$azSKVer = (Get-Module $azSKModuleName).Version


<#-------------------------------------------------------------------------------------------------------------- 
  1a) If setting up new Org policy then follow the below steps:
----------------------------------------------------------------------------------------------------------------
  Below command will create a basic policy structure in your local machine and create following resources in the subscription (if they don't already exist):
	Resource Group: (AzSK-<OrgName>-<DepartmentName>-RG.
	Storage Account: azsk<OrgName><DepartmentName>sa.
	Application Insight: AzSK-<OrgName>-<DepartmentName>-AppInsight.
	Monitoring dashboard (DevOpsKitMonitoring (DevOps Kit Monitoring Dashboard [Contoso-IT]))
 #>
 	Install-AzSKOrganizationPolicy -SubscriptionId $subId -OrgName $oName -DepartmentName $depName -PolicyFolderPath $policyFolder

<# 1b) To set your current session with the above policy so that you can subscription with that policy execute the iwr emitted in Install-AzSKOrganizationPolicy command
---------------------------------------------------------------------------------------------------------------	
   1c) Execute the below command to perform Subscription Scan with org policy
#>
    Get-AzSKSubscriptionSecurityStatus -SubscriptionId $SubId #You can verify the org name in the yellow line that says "Running with $oName$DeptName policy..."	



#==============================================================================================================
#2) Customizing Org-Policy: Refer https://github.com/azsk/DevOpsKit-docs/tree/master/07-Customizing-AzSK-for-your-Org#modifying-and-customizing-org-policy
#===============================================================================================================
<#
   Below are few examples to get familiarization with org-policy customization	
#  **Note**: 1) If you don't have existing configured Org policy, you can download policy to your local machine with below command. 
	         2) It is recommended to use the below command before making any changes to the policy (while trying the below examples) and updating the existing policy changes by Update-AzSKOrganizationPolicy command.
             3) If you are following step by step sample and want cummulative policy changes copy only the required settings from downloaded sample files   
#>  
	 Get-AzSKOrganizationPolicy -SubscriptionId $subId -OrgName $oName -DepartmentName $depName -PolicyFolderPath $policyFolder

#---------------------------------------------------------------------------------------------------------------------
#Example 1: Changing the default 'Running AzSK using…' message
#-----------------------------------------------------------------------------------------------------------------------	
<#	Step 1:  Open the AzSk.json from your local org-policy folder i.e. "$policyFolder\Config\AzSK.JSON"
	Step 2:  Edit the value for "Policy Message" say by adding field by adding 3 '*' characters on each side of your org name
	Step 3:  Save the file and to get these changes reflect in your online policy run the below Update-AzSKOrganizationPolicy command
	Step 4:  Edit the ServerConfigMetadata.json file in the org-policy folder and create an entry for this file (if not already there)
#>
	Update-AzSKOrganizationPolicy -SubscriptionId $subId -OrgName $oName -DepartmentName $depName -PolicyFolderPath $policyFolder

<# Testing: To check the updated message follow the below steps:
	Step 1: Run "css" if you are working in the same powershell session but ff you have started a fresh one, run import-module AzSK and then run scan using below command
#>	
    grs -s $subId -ResourceTypeName Storage -ControlIds 'Azure_Storage_AuthN_Dont_Allow_Anonymous'# You should see updated message ""Running AzSK...**$oName-$deptName **..."  

#-----------------------------------------------------------------------------------------------------------------------	
#Example 2: Changing a control setting for specific controls
#-----------------------------------------------------------------------------------------------------------------------
<#	Step 1: Copy the ControlSettings.json from the AzSK installation to your org-policy folder "$policyFolder\Config\ControlSettings.json"
	Step 2: Remove everything except the "NoOfApprovedAdmins" line while keeping the JSON object hierarchy/structure intact 
	Step 3: Edit Number of Admins
	Step 4: Save the file
	Step 5: Edit the ServerConfigMetadata.json file in the org-policy folder and create an entry for this file (if not already there)
	Step 6: Run Update-AzSKOrganizationPolicy command as given below:
#>
	Update-AzSKOrganizationPolicy -SubscriptionId $subId -OrgName $oName -DepartmentName $depName -PolicyFolderPath $policyFolder

<# Testing: 
    	Step 1: Run "css" if you are working in the same PowerShell session but ff you have started a fresh one, run import-module AzSK and then run scan using below command
#>	    
    gss -s $subId -ControlIds 'Azure_Subscription_AuthZ_Limit_Admin_Owner_Count'
<#	    Check detailed Logs to determine if control is passing or failing (see # of admins found)
    	Default threshold is '5' 
#>
#----------------------------------------------------------------------------------------------------------------------------------
#Example 3: Creating a custom control 'baseline' for your org. Refer https://github.com/azsk/DevOpsKit-docs/blob/master/07-Customizing-AzSK-for-your-Org/Readme.md#c-creating-a-custom-control-baseline-for-your-org
#--------------------------------------------------------------------------------------------
<#	Step 1: Open the ControlSettings.json from your org-policy folder "$policyFolder\Config\ControlSettings.json"
	Step 2: You can download sample ControlSettings.json from CustomizePolicy/EditBaseline/ControlSettings.json and copy its content to the ControlSettings.json file opened in Step1. You can use other controls of your choice.
	        Make sure the json format for defining Baseline controls is same as in the above referred sample.
	Step 3: Save the edited file and run Update-AzSKOrganizationPolicy command as given below:
	Step 4: Edit the ServerConfigMetadata.json file in the org-policy folder and create an entry for this file (if not already there)
#>
	Update-AzSKOrganizationPolicy -SubscriptionId $subId -OrgName $oName -DepartmentName $depName -PolicyFolderPath $policyFolder
<#  Testing: 
 	Step 1: Run "css" if you are working in the same PowerShell session but ff you have started a fresh one, run import-module AzSK and then run scan using below command
#>
	gss -s $subId -ubc #The scan should now evaluate the controls added in Baseline

#---------------------------------------------------------------------------------------------------------------------------------
#Example 4: Modify an SVT control json
#----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
<#	Step 1: Copy the Storage.json from the AzSK installation("$HOME\Documents\WindowsPowerShell\Modules\$azskmoduleName\$azskVer\Framework\Configurations\SVT\SubscriptionCore.json") to your org-policy folder "$policyFolder\Config"
	Step 2: Remove everything except the ControlId, the Id and the specific property to be modified. You can use sample from CustomizePolicy/EditSVTControlSample/SubscriptionCore.json where we have changed control description & severity
	Step 3: Save the updated SubscriptionCore.json file.
	Step 4: Edit the ServerConfigMetadata.json file in the org-policy folder and create an entry for this file (if not already there) and then run Update-AzSKOrganizationPolicy command as given below:	
#>	
    Update-AzSKOrganizationPolicy -SubscriptionId $subId -OrgName $oName -DepartmentName $depName -PolicyFolderPath $policyFolder

<# Testing: 
	Step1: Run "css" if you are working in the same PowerShell session but ff you have started a fresh one, run import-module AzSK and then run scan using below command
#>
	gss -s $subId -ControlId Azure_Subscription_AuthZ_Limit_Admin_Owner_Count #	The output csv should show updated description & Severity
#---------------------------------------------------------------------------------------------------------------------------------
#Example 5: Add Preview Baseline controls for your org
#--------------------------------------------------------
<#	Step 1: Copy the content of sample files present in /AddPreviewBaselineSample/ControlSettings.json to your org-policy folder ControlSettings file (present at "$policyFolder\Config\ControlSettings.json")
	       We have added one automated control for AppService (TLS), one manual control for Storage (key-rotate) and one automated control for sub (PIM)	
	Step 2: Save the edited ControlSettings.json file and run Update-AzSKOrganizationPolicy command as given below:
	Step 3: Edit the ServerConfigMetadata.json file in the org-policy folder and create an entry for this file (if not already there) and then run Update-AzSKOrganizationPolicy command as given below:	
#>	
	Update-AzSKOrganizationPolicy -SubscriptionId $subId -OrgName $oName -DepartmentName $depName -PolicyFolderPath $policyFolder
<#Testing: 
    Step 1: Run "css" if you are working in the same PowerShell session but ff you have started a fresh one, run import-module AzSK and then run scan using below command
#>	
    gss -s $subId -UsePreviewBaselineControls # The controls added in the PreviewBaseline list for SubscriptionCore should be scanned

#-------------------------------------------------------------------------------------------------------------------
#Example 6: Customizing Severity Labels for you org. Refer: https://github.com/azsk/DevOpsKit-docs/blob/master/07-Customizing-AzSK-for-your-Org/Readme.md#e-customizing-severity-labels
#------------------------------------------------------------------------------------------------------------------
<#  Step 1: Copy the content of sample files present in /SeveritySample/ControlSettings.json to your org-policy folder ControlSettings file ("$policyFolder\Config\ControlSettings.json")
    Step 2: Save the edited ControlSettings.json file and run Update-AzSKOrganizationPolicy command as given below:
	Step 3: Edit the ServerConfigMetadata.json file in the org-policy folder and create an entry for this file (if not already there) and then run Update-AzSKOrganizationPolicy command as given below:	
#>	
	Update-AzSKOrganizationPolicy -SubscriptionId $subId -OrgName $oName -DepartmentName $depName -PolicyFolderPath $policyFolder
<#Testing: 
	Step 1: Run "css" if you are working in the same PowerShell session but ff you have started a fresh one, run import-module AzSK and then run scan using below command
#>
	gss -s $subId -Severity 'FixItNow' #if you have used some other values you can supply them in comma separated format to Severity parameter.
#	The above should scan critical control which would now have 'FixItNow' severity. You can check the severity column in output SecurityReport.csv 

#---------------------------------------------------------------------------------------------------------------
#=================================================================================================================
#3) Extending AzSK SVT
#-----------------------------------------------------------------------------------------------------------------
# 3a) Extend existing control or Modify existing logic. Refer https://github.com/azsk/DevOpsKit-docs/tree/master/07-Customizing-AzSK-for-your-Org/Extending%20AzSK%20Module#b-extending-a-gss-svt
#-----------------------------------------------------------------------------------------------------------------
<#	Step 1: Download the sample Storage.ext.ps1 file from /ExtendingAzSKModule/Sample/ExtendingExistingGRSControl and save it to your local policy folder "$policyFolder\Config"
	Step 2: Download the sample Storage.ext.json file from /ExtendingAzSKModule/Sample/ExtendingExistingGRSControl and save it to your local policy folder "$policyFolder\Config"
	Step 3: Ensure the ControlSettings.json has ExemptedHttpsRegions setting, if it is not present you can get copy the setting from ExtendingAzSKModule/Sample/ExtendingExistingGRSControl/ControlSettings.json and paste them in
		your local policy ControlSettings.json file
	Step 4: Edit the ServerConfigMetadata.json file in the org-policy folder and create an entry for this file (if not already there) and then run Update-AzSKOrganizationPolicy command as given below:	

#>	
    Update-AzSKOrganizationPolicy -SubscriptionId $subId -OrgName $oName -DepartmentName $depName -PolicyFolderPath $policyFolder

<# Testing: 
	Step 1: Run "css" if you are working in the same PowerShell session but ff you have started a fresh one, run import-module AzSK and then run scan using below command
#>
	grs -s $subId -ResourceTypeName Storage -ControlIds 'Azure_Storage_DP_Encrypt_In_Transit'# The scan should pass the storage account which don’t have HTTPS enabled but present in exempted region 
	
#---------------------------------------------------------------------------------------------------------------
# 3b) New control for a resource. Refer https://github.com/azsk/DevOpsKit-docs/tree/master/07-Customizing-AzSK-for-your-Org/Extending%20AzSK%20Module#b-extending-a-grs-svt	
#---------------------------------------------------------------------------------------------------------------	
<#  Step 1: Download the sample Storage.ext.ps1 file from /ExtendingAzSKModule/Sample/NewGRSControl and save it to your local policy folder "$policyFolder\Config"
	Step 2: Download the sample Storage.ext.json file from /ExtendingAzSKModule/Sample/NewGRSControl and save it to your local policy folder "$policyFolder\Config"
	Step 3: Ensure the ControlSettings.json has ExemptedHttpsRegions setting, if it is not present you can get copy the setting from ExtendingAzSKModule/Sample/ExtendingExistingGRSControl/ControlSettings.json and paste them in
		    your local policy ControlSettings.json file
	Step 4: Edit the ServerConfigMetadata.json file in the org-policy folder and create an entry for this file (if not already there) and then run Update-AzSKOrganizationPolicy command as given below:	

#>
	Update-AzSKOrganizationPolicy -SubscriptionId $subId -OrgName $oName -DepartmentName $depName -PolicyFolderPath $policyFolder

<#Testing: 
	Step 1: Run "css" if you are working in the same PowerShell session but ff you have started a fresh one, run import-module AzSK and then run scan using below command
#>
    grs -s $subId -ResourceTypeName Storage -ControlIds 'Azure_Storage_Create_In_Approved_Regions' # The scan should pass the storage account that are in 'eastus2' region
    grs -s $subId -ResourceTypeName Storage -ControlIds 'Azure_Storage_Create_In_Approved_Regions' -rgns 'AzSKRG'# The scan should pass the storage account in AzSK 
	
#---------------------------------------------------------------------------------------------------------------

#=================================================================================================================