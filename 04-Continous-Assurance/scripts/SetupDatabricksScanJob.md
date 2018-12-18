```PowerShell
function InvokeRestAPICall($EndPoint, $Method, $Body,$ErrorMessage)
{
    $uri = $WorkSpaceBaseUrl + $EndPoint
    try{
        if([string]::IsNullOrEmpty($body))
        {
         $response = Invoke-RestMethod -Method $Method -Uri $uri `
							         -Headers @{"Authorization" = "Bearer "+$PersonalAccessToken} `
							         -ContentType 'application/json' -UseBasicParsing
        }else
        {
         $response = Invoke-RestMethod -Method $Method -Uri $uri `
							           -Headers @{"Authorization" = "Bearer "+$PersonalAccessToken} `
							           -ContentType 'application/json' -Body $Body -UseBasicParsing
        }
    }
    catch{
      
        Write-Host $ErrorMessage -ForegroundColor RED
        throw $_
    }
    return $response
}

function SetupDatabricksScanJob($DatabricksHost)
{
    $WorkSpaceBaseUrl = $DatabricksHost
    $PAT = Read-Host -Prompt 'Input Personal  Access Token(PAT) for Databricks Workspace'
    $PersonalAccessToken = $PAT.Trim()

    # Please don't modify these values
    $ConfigBaseUrl = "https://azsdkosseppreview.azureedge.net/3.9.0/"
    $NotebookBaseUrl = "https://azsdkosseppreview.azureedge.net/1.0.0/"
    $SecretScopeName = "AzSK_CA_Secret_Scope"
    $SecretKeyName = "AzSK_CA_Scan_Key"
    $NotebookFolderPath = "/AzSK"  
    #

    #region Step 1: Create Secret Scope 

     $params = @{
     'scope' = $SecretScopeName
    }

    $bodyJson = $params | ConvertTo-Json

    # Check if Secret Scope already exists
    
    Write-Host "Checking if secret scope [$SecretScopeName] already exists in the workspace..." -ForegroundColor Yellow

    $endPoint =  "/api/2.0/secrets/scopes/list"
    $SecretScopeAlreadyExists = $false
    $SecretScopes = InvokeRestAPICall -EndPoint $endPoint -Method "GET" -ErrorMessage "Unable to fetch secret scope, remaining steps will be skipped."
   
    # todo  : check if scopes property exists
    if($SecretScopes -ne $null -and ("scopes" -in $SecretScopes.PSobject.Properties.Name) -and ($SecretScopes.scopes | Measure-object).Count -gt 0)
    {
     $SecretScope = $SecretScopes.scopes | where {$_.name -eq $SecretScopeName}
     if($SecretScope -ne $null -and ( $SecretScope | Measure-Object).count -gt 0)
     {
        $SecretScopeAlreadyExists = $true
        Write-Host "Secret scope [$SecretScopeName] already exists in the workspace. We will reuse it." -ForegroundColor Cyan
     }
    }
    
    # Create Secret Scope if not already exists
    if(-not $SecretScopeAlreadyExists)
    {
        Write-Host "Creating a new secret scope [$SecretScopeName] in the workspace..." -ForegroundColor Yellow
        $endPoint = "/api/2.0/secrets/scopes/create"
        $ResponseObject =  InvokeRestAPICall -EndPoint $endPoint -Method "POST" -Body $bodyJson -ErrorMessage "Unable to create secret scope, remaining steps will be skipped."
				
        Write-Host "Created scope [$SecretScopeName] successfully." -ForegroundColor Green
    }
    
    #end region

    #region Step 2: PUT Token in Secret Scope

    # If Secret already exists it will update secret value
     
     $params = @{
     'scope' = $SecretScopeName;
      "key" = $SecretKeyName;
      "string_value" = $PersonalAccessToken
    }

    $bodyJson = $params | ConvertTo-Json

    $endPoint = "/api/2.0/secrets/put"

    Write-Host "Creating/Updating value for secret [$SecretKeyName] in the workspace..." -ForegroundColor Yellow

    $ResponseObject = InvokeRestAPICall -EndPoint $endPoint -Method "POST" -Body $bodyJson -ErrorMessage "Unable to create/update secret value, remaining steps will be skipped."

    Write-Host "Created/Updated value for secret [$SecretKeyName] successfully." -ForegroundColor Green

    #end region

    #region Step 3: Set up AzSk Notebook in Databricks workspace

    # Create AzSK folder in user workspace, if folder already exists it will do nothing

     $endPoint = "/api/2.0/workspace/mkdirs"
     
     $body = @{
     "path" = $NotebookFolderPath
    }

    $bodyJson  = $body | ConvertTo-Json

    $ResponseObject = InvokeRestAPICall -EndPoint $endPoint -Method "POST" -Body $bodyJson -ErrorMessage "Unable to create folder in workspace, remaining steps will be skipped."

    # Download notebook from server and store it in temp location

    $NotebookServerUrl = $NotebookBaseUrl + "AzSK_CA_Scan_Notebook.ipynb"
    $ControlJsonUrl = $ConfigBaseUrl + "DatabricksControls.json"
    $filePath = $env:TEMP + "\AzSK_CA_Scan_Notebook.ipynb"
    Invoke-RestMethod  -Method Get -Uri $NotebookServerUrl -OutFile $filePath

    # Bootstrap basic properties and urls in Notebook

    (Get-Content $filePath) -replace '\#DatabricksHostDomain\#', $WorkSpaceBaseUrl | Set-Content $filePath -Force
    (Get-Content $filePath) -replace '\#ControlJsonUrl\#', $ControlJsonUrl | Set-Content $filePath -Force
    $fileContent = get-content $filePath
    $fileContentBytes = [System.Text.Encoding]::UTF8.GetBytes($fileContent)
    $fileContentEncoded = [System.Convert]::ToBase64String($fileContentBytes)

    # Import notebook in user workspace,

    $params = @{
      'path' = $NotebookFolderPath + '/AzSK_CA_Scan_Notebook';
      'format' = 'JUPYTER';
      'language' =  'PYTHON';
      'content'=  $fileContentEncoded;
      'overwrite' = 'true'
    }


    $bodyJson = $params | ConvertTo-Json
    $endPoint = "/api/2.0/workspace/import"
    Write-Host "Importing AzSK_CA_Scan_Notebook into the workspace..." -ForegroundColor Yellow
    $ResponseObject = InvokeRestAPICall -EndPoint $endPoint -Method "POST" -Body $bodyJson -ErrorMessage "Unable to import notebook in workspace, remaining steps will be skipped."
    Write-Host "Successfully imported AzSK_CA_Scan_Notebook." -ForegroundColor Green

    #cleanup notebook from temp location

    Remove-Item $filePath -ErrorAction Ignore

    #end region

    #region Step 4: Schedule Notebook to run periodically,

    # Check if Job already exists

    Write-Host "Checking if Job AzSK_CA_Scan_Job exists in the workspace..." -ForegroundColor Yellow
    $JobAlreadyExists = $false
    $endPoint =  "/api/2.0/jobs/list"
    $JobList = InvokeRestAPICall -EndPoint $endPoint -Method "GET" -ErrorMessage "Unable to list jobs in workspace, remaining steps will be skipped."

    if($JobList -ne $null -and ("jobs" -in $JobList.PSobject.Properties.Name) -and ($JobList.jobs | Measure-object).Count -gt 0)
    {
     $AzSKJobs = $JobList.jobs  | where {$_.settings.name -eq 'AzSK_CA_Scan_Job'}
     if($AzSKJobs -ne $null -and ( $AzSKJobs | Measure-Object).count -gt 0)
     {
        $JobAlreadyExists = $true
        Write-Host "AzSK_CA_Scan_Job already exists in the workspace." -ForegroundColor Cyan
     }
    }

    # Create Job if not already exist

    if(-not $JobAlreadyExists)
    {
        Write-Host "Creating Job 'AzSK_CA_Scan_Job' in the workspace..." -ForegroundColor Yellow
        $JobConfigServerUrl = $ConfigBaseUrl + "DatabricksCAScanJobConfig.json"
        $body = Invoke-RestMethod  -Method Get -Uri $JobConfigServerUrl
        $bodyJson  = $body | ConvertTo-Json
        $endPoint = "/api/2.0/jobs/create"
        $ResponseObject = InvokeRestAPICall -EndPoint $endPoint -Method "POST" -Body $bodyJson -ErrorMessage "Unable to create AzSK_CA_Scan_Job in workspace."
        Write-Host "Successfully created Job 'AzSK_CA_Scan_Job' with JobID: $($ResponseObject.job_id)." -ForegroundColor Green
    }
  
    #end region

}
$databricksHost = "<domain-name-of-your-azure-databricks>"
SetupDatabricksScanJob -DatabricksHost $databricksHost

```
