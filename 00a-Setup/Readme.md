# Installation Guide
> <h4><font color="blue">IMPORTANT:</font></h4> If you are from CSE, please install the AzSK via instructions at https://aka.ms/devopskit/onboarding so that CSE-specific policies are configured for your installation. <u>Do not</u> use the installation instructions on this page.


 <!-- **Release Version: AzSDK 2.11.xx <=> AzSK 3.0.x ** -->
>**Pre-requisites**:
> - PowerShell 5.0 or higher. 
	
1. First verify that prerequisites are already installed:  
    Ensure that you have PowerShell version 5.0 or higher by typing **$PSVersionTable** in the PowerShell ISE console window and looking at the PSVersion in the output as shown below.) 
 If the PSVersion is older than 5.0, update PowerShell from [here](https://www.microsoft.com/en-us/download/details.aspx?id=54616).  
   ![PowerShell Version](../Images/00_PS_Version.PNG)   

2. Install the Secure DevOps Kit for Azure (AzSK) PS module:  
	  
```PowerShell
  Install-Module AzSK -Scope CurrentUser
```

Note: You may need to use `-AllowClobber` and `-Force` options with the Install-Module command 
above if you have a different version of AzureRM modules installed on your machine. 
AzSK depends on specific version of different AzureRM service modules and installs that during the installation above.
Run command 'Find-Module AzSK -includedependencies' to see all dependencies.  

------------------------------------------------
### Backward compatibility
As Azure features evolve and add more security controls, "Secure DevOpsKit for Azure" also evolve every month respecting the latest security features.
It is always recommended to run on the latest devops kit module to scan your subscription with the latest rules. 

Users who are still using older modules of devops kit continue to work only until N-2 version w.r.t production version e.g. If the current production version is 3.2.x, 
then teams can continue to use 3.0.x and 3.1.x. As the version 3.3.x becomes available, automatically 3.0.x would stop working. 

More details on how it impacts each stage of DevOps are shared below:

**Adhoc Scans:**
Users running the devops kit scan using N-3 version from their local machine, will start getting an error asking to upgrade as shown below:
![Install_OlderVersionWarning](../Images/00_Install_OlderVersionWarning.PNG) 
> **Note:** This restriction has been put in place from AzSDK version 2.8.x and applicable for all future releases.

**Continuous Assurance(CA) Scans:**
No impact to CA as it would automatically upgrade to latest version. 
Before every scan it checks whether there has been a latest release of the devops kit and upgrade itself.
All the further scans would happen using the latest version.

**AzSK CICD Extension:**
No impact to default behavior of CICD. It always runs the scan with the latest version available in the PS Gallery. 
If teams have overridden the default behavior by specifying a version number during the build, then the same restriction of N-2 applies here as well.

### Auto Update
It is always recommended to scan your subscription with the latest devops kit module and thus by ensuring to evaluate latest security controls that are available through the module.
"Secure DevOps kit for Azure" module provide different auto update capabilities w.r.t different stages of devops. More details are below:

**Adhoc Scans:**
Users running the older version of AzSK scan from their local machine will get a warning as shown in the image below.
It would also provide the user with required instructions to upgrade the module.
![Install_Autoupdate](../Images/00_Install_Autoupdate.PNG) 

In a scenario where an organization has setup its own instance of "Secure DevOpsKit for Azure", the users can leverage 
the auto update feature which has been introduced from the AzSDK version 2.8.x.
As shown in the image above, user can either sign up for Autoupdate or go with manual update by running the command below:

```PowerShell
  Set-AzSKPolicySettings -AutoUpdate On|Off
```

User needs to close and reopen a fresh session once the command is run.
Going forward, if the latest version of devops kit is released, then during execution of any devops kit command it would start the auto update workflow automatically 
as shown in the image below:
![Install_Autoupdate_Workflow](../Images/00_Install_Autoupdate_Workflow.PNG)

Step 1: It would take user consent before it starts the auto update workflow. (1 in the image above) <br/>
Step 2: User need to close all the displayed PS sessions. Typically open PS sessions would lock the module and fail the installation. (2 in the image above) <br/>
Step 3: Even the current session must be closed. It would again take the user consent before it starts the auto update flow to avoid the loss of any unsaved work. (3 in the image above) 


**Continuous Assurance(CA) Scans:**
The devops kit module running the scans through CA, auto updates itself. Every scan would initially check if any new version has been released and auto-upgrade the installed module to the latest version.
No action is required from the user.

Users can also run the command below to confirm the same:

```PowerShell
  Get-AzSKContinuousAssurance -SubscriptionId '<subscriptionId>'
```

**AzSK CICD Extension**
AzSK CICD extension will always run the scan using latest module of AzSK from the gallery. This is the default behavior in the case of both hosted and non-hosted agents. 

You could find more details about CICD [here.](../03-Security-In-CICD/Readme.md)
 
------------------------------------------------
### FAQs
#### Should I run PowerShell ISE as administrator or regular user?
Please run PowerShell ISE as a regular user. The AzSK has been thoroughly tested to run in normal user (non-elevated) mode. As much as possible, please do not launch your PS sessions in "Administrator" mode. There is nothing that the AzSK does that needs elevated privileges on the local system. Even the installation command itself uses a '-Scope CurrentUser' parameter internally.  

#### Error message: "Running scripts is disabled on this system..."
This is an indication that PowerShell script loading and execution is disabled on your machine. You will need to enable it before the AzSK installation script (which itself is a PowerShell script) can run. 
```PowerShell
Get-ExecutionPolicy -Scope CurrentUser
```
If you run above command in the PS console, you will likely see that the policy level is either 'Restricted' or 'Undefined'. For AzSK cmdlets to run, it needs to be set to 'RemoteSigned'.
To resolve this issue run the following command in your PS console:
```PowerShell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```
The execution policy setting will be remembered and all future PS consoles opened in non-Admin (CurrentUser) mode will apply the 'RemoteSigned' execution policy.

#### Error message: "PackageManagement\Install-Package: cannot process argument transformation on parameter 'InstalledModuleInfo'..."


If you have installed AzureRM PowerShell using Azure SDK in your machine, it typically get installed in Program Files. You could run the below command to confirm
```PowerShell
 Get-Module -Name AzureRM* -ListAvailable 
```
If this is the case, then you need to remove the Azure PowerShell modules installed through Azure SDK completely from the Program Files. You could also take back up in case if you need. 
AzSK also need AzureRM modules. But it would download from PSGallery instead of from Azure SDK. This downloading of AzureRM modules from PS Gallery would conflict with AzureRM modules installed through Azure SDK. 
After cleanup, If you again the run the below command, it would fetch AzureRM version 5.2.0 by default into the current user scope instead of in Program Files. 
```PowerShell
Install-Module AzSK -Scope CurrentUser -AllowClobber 
```
In case you still need to use the other version of AzureRm (that you removed), you can install it from PS Gallery using the command below: 
```PowerShell
Install-Module AzureRM -Scope CurrentUser -AllowClobber -RequiredVersion <versionNumber e.g. “3.8.0” >
```
> Note: If *"-AllowClobber"* option is not available in your version of PS, then replace that with *"-Force"*

If you happen to have multiple versions of AzureRM, then it depends on which version of the module loads first in the PS session. In that case, to avoid confusion, close the installer PS session and in a new PS session run the following first:
```PowerShell
Import-Module AzSK
```
Then you can run one or more AzSK commands or other AzureRm commands. The *"Import-Module"* ensures that the right version of AzureRM gets loaded into the current session.

#### Error message: "WARNING: The version '3.x.y' of module 'AzureRM.Profile' is currently in use. Retry the operation after closing..."
If you see multiple warning such as the above during setup, it is likely that one or more PowerShell instances are running and have AzureRm modules loaded which are conflicting with the AzSK installation. In such as case, it is best to ensure that all PS sessions (including the current one) are closed and start the installer in a fresh PS ISE session.
In dire circumstances, you may need to close/kill all instances of PowerShell sessions running on your system (including VS if you have PS plugin installed). In that case, make sure you have saved any work in those sessions and then run the following in a Windows Cmd console:
```PowerShell
taskkill /im PowerShell_ise.exe & taskkill /im PowerShell.exe & taskkill /im PowerShellToolsProcessHost.exe
```  
#### Error message: "The property 'Id' cannot be found on this object. Verify that the property exists..."
This is typically caused by a version mis-match for underlying AzureRm PowerShell modules that are used by AzSK! The AzSK installation process will typically install AzureRm modules corresponding to the version that it depends on. However, it is possible that you also have a previous version of AzureRm on your machine.  

PowerShell works with the concept of 'sessions'. Each PowerShell ISE or command prompt window is its own independent session. By default, when any cmdlet is run, PS will load the corresponding module (code) in the memory for that session. After that, subsequent references to cmdlets in that module will use the loaded module. Usually, the module loading follows a particular heuristic (based on version number, PS module path order, admin v. non-admin PS launch mode, etc.)  

The above error message is an indication that an AzSK cmdlet is being run in a PowerShell session that already had an older version of AzureRm loaded in memory (which may be due to something as simple as doing a Login-AzureRmAccount and *then* installing AzSK in that session). In most circumstances, one of the following remedies should work:
- Close the PS session and open a new one. In the new session, do an "*Import-Module AzureRm -RequiredVersion 5.2.0*" before running anything else (e.g., Login-AzureRmAccount)
- Close the PS session and open a new one. In the new session, do an "*Import-Module AzSK*" before running anything else. (This will force-load the correct version of AzureRm that AzSK needs.). 
  - If you suspect that you may have multiple versions of AzSK itself installed, then use "*Import-Module AzSK -RequiredVersion 2.5.0*" (August release).  

#### Message: "Warning : Microsoft Azure PowerShell collects data about how users use PowerShell cmdlets..."
The AzSK depends upon AzureRm PowerShell modules. AzureRm modules are created/maintained by the Azure product team and provide the core PowerShell libraries to interact with different Azure services. For example, you'd use the AzureRm Storage module to create/work with a storage account, etc.  

The AzSK setup installs the required version of AzureRm. It is possible that this is the first time your system is being setup for AzureRm. In such a situation, you will get a 'data collection' related notice/warning from AzureRm. You can choose to 'accept' or 'decline' permission to collect data. The AzSK functionality will not be affected by that.  

#### When will AzSK support the newest AzureRm dependencies? Can I run both side by side? In the meantime, what if I need to run both AzSK and the new version of AzureRm modules (for different tasks)?
At any time, AzSK is bound to a specific version of AzureRm service modules. We have found that it keeps our dependencies in check and limits randomizations from minor version updates of one of the many modules that ship under the "AzureRm umbrella".

However, after each major update to AzureRm, we wait for a dot-release and migrate AzSK to the latest version. This usually happens within a couple of months after the major AzureRm release.

In the interim, if you need to use AzSK as well as the latest AzureRm (for other tasks), this is how you can do it. (We assume that you already have the latest AzSK installed which, in turn, will ensure that you have the version of AzureRm modules that AzSK requires). 
Install the newest AzureRm from a fresh PS console if you haven't done so.
Use separate PS consoles for AzSK and (newer) AzureRM modules work.
For the AzSK console, always start with the following command:
```PowerShell
import-module AzSK
```
This will automatically cause AzSK to load the version of AzureRm modules it requires as opposed to the newest one. Run AzSK commands as needed in this session.
For the (new) AzureRm console, just run whatever AzureRm commands you need to there. The latest installed version of AzureRm will automatically get loaded and used for those. (Do not run AzSK commands in this console.) 

Just note that this assumes that both AzSK and AzureRm were installed with '-Scope CurrentUser'. If a newer AzureRm is installed without an explicit 'CurrentUser' scope, it is possible that by default differnt version of AzureRm modules may get loaded. In such a situation, it is better to explicitly load the version needed with a '-RequiredVersion' flag (or full path to module). Basically, remember that PS will search for a module in the order folders are listed in $Env:PSModulePath and load the first module that exports the function being used.

#### How often should I upgrade my installation of AzSK? How long will it take?
The AzSK team releases a new version of AzSK at the end of each monthly sprint. You should aim to use the latest release always. So, as a regular user, you should upgrade AzSK each month. 

Being on the latest release ensures that you have the latest features, most up to date control evaluation code, coverage for latest Security Verification Tests (SVTs), etc. 
Note that, when you run any AzSK command, if there is a newer version of AzSK available, the command will tell you about it (at the very top). 

Note that, the first time you installed AzSK, it perhaps took a few extra minutes because of the dependencies that had to be installed (especially AzureRm). In most subsequent installations, it will just need to fetch the latest AzSK modules. This will hardly take a couple of minutes.
