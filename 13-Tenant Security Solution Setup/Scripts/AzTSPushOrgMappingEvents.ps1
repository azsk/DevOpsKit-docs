
function PostLAWSData([string] $workspaceId, [string] $sharedKey, $body, $logType, $laType)
	{

			
				[string] $method = "POST"
				[string] $contentType = "application/json"
				[string] $resource = "/api/logs"
				$rfc1123date = [System.DateTime]::UtcNow.ToString("r")
				[int] $contentLength = $body.Length
				[string] $signature = GetLAWSSignature $workspaceId  $sharedKey  $rfc1123date $contentLength $method $contentType $resource
				$LADataCollectorAPI = ".ods.opinsights.azure.com"	
				[string] $uri = "https://" + $workspaceId + $LADataCollectorAPI + $resource + "?api-version=2016-04-01"
				[DateTime] $TimeStampField = [System.DateTime]::UtcNow
				$headers = @{
					"Authorization" = $signature;
					"Log-Type" = $logType;
					"x-ms-date" = $rfc1123date;
					"time-generated-field" = $TimeStampField;
				}
				$response = Invoke-WebRequest -Uri $uri -Method $method -ContentType $contentType -Headers $headers -Body $body -UseBasicParsing
		
}


function GetLAWSSignature ($workspaceId, $sharedKey, $Date, $ContentLength, $Method, $ContentType, $Resource)
	{
			[string] $xHeaders = "x-ms-date:" + $Date
			[string] $stringToHash = $Method + "`n" + $ContentLength + "`n" + $ContentType + "`n" + $xHeaders + "`n" + $Resource
        
			[byte[]]$bytesToHash = [Text.Encoding]::UTF8.GetBytes($stringToHash)
			
			[byte[]]$keyBytes = [Convert]::FromBase64String($sharedKey)

			[System.Security.Cryptography.HMACSHA256] $sha256 = New-Object System.Security.Cryptography.HMACSHA256
			$sha256.Key = $keyBytes
			[byte[]]$calculatedHash = $sha256.ComputeHash($bytesToHash)
			$encodedHash = [Convert]::ToBase64String($calculatedHash)
			$authorization = 'SharedKey {0}:{1}' -f $workspaceId,$encodedHash
			return $authorization   
	}


function PushOrgMappingEvents([string] $OrgMappingFilePath, [string] $LogAnayticsWorkspaceId, [string] $LogAnalyticsSharedKey)
{
    $OrgMappingList = @();
    $FilePath = $OrgMappingFilePath
    $OrgMappingLAType = "AzSK_OrgMapping"
    $LAType = "LAWS"

    try
    {
        Write-Host "Pushing org mapping csv to Log Analytics workspace...`n" -ForegroundColor Cyan
        # Read CSV file here
        if(-not([string]::IsNullOrEmpty($FilePath)) -and (Test-Path -path $FilePath -PathType Leaf))
	    {
	      $body = Get-Content $FilePath | ConvertFrom-Csv
          $body | ForEach-Object {

                $OrgMappingList+= @{ "BGName" = $_.BGName; "ServiceGroupName" = $_.ServiceGroupName; "SubscriptionId" =$_.SubscriptionId; "SubscriptionName" = $_.SubscriptionName; "IsActive" = $_.IsActive; "OwnerDetails" = $_.OwnerDetails }
          }
          $postbody =  $OrgMappingList | ConvertTo-Json
          $lawsBodyByteArray = ([System.Text.Encoding]::UTF8.GetBytes($postbody))

          # Post org mapping data
          PostLAWSData -workspaceId $LogAnayticsWorkspaceId -sharedKey $LogAnalyticsSharedKey -body $lawsBodyByteArray -logType $OrgMappingLAType -laType  $LAType
        }
        else
        {
          Write-Host "Unable to read file, Please check file path and try again." -ForegroundColor Red
          return;
        }
        Write-Host "Successfully pushed org mapping data to Log Analytics workspace." -ForegroundColor Green
    }
    catch
    {
        Write-Host "Error occured while posting data to Log Analytics workspace. Please check file path and try again. ErrorMessage [$($_)]" -ForegroundColor Red

    }

}

PushOrgMappingEvents -OrgMappingFilePath "<OrgMapping.csv File Path>" -LogAnayticsWorkspaceId "<Workspace Id>" -LogAnalyticsSharedKey "<Workspace Key>"
