################################################
#options to change
param(
[Parameter(Mandatory = $true)]
$primarykey = "",
[Parameter(Mandatory = $true)]
$eventhubnamespace = "",
[Parameter(Mandatory = $true)]
$eventhub = "",
[Parameter(Mandatory = $true)]
[string]$numberOfEvents = ""
)
#################################################
# Load the System.Web assembly to enable UrlEncode



[Reflection.Assembly]::LoadFile( `
  'C:\WINDOWS\Microsoft.NET\Framework\v4.0.30319\System.Web.dll')`
  | out-null 

$method = "POST"
$URI = "https://$eventhubnamespace.servicebus.windows.net/$eventhub/messages"
$encodedURI = [System.Web.HttpUtility]::UrlEncode($URI)
$keyname = "RootManageSharedAccessKey"
$key = $primarykey
$startDate = [datetime]"01/01/1970 00:00"
$hour = New-TimeSpan -Hours 1

# Calculate expiry value one hour ahead
$sinceEpoch = New-TimeSpan -Start $startDate -End ((Get-Date) + $hour)
$expiry = [Math]::Floor([decimal]($sinceEpoch.TotalSeconds + 3600))

# Create the signature
$stringToSign = $encodedURI + "`n" + $expiry
$hmacsha = New-Object System.Security.Cryptography.HMACSHA256
$hmacsha.key = [Text.Encoding]::ASCII.GetBytes($key)
$signature = $hmacsha.ComputeHash([Text.Encoding]::ASCII.GetBytes($stringToSign))
$signature = [System.Web.HttpUtility]::UrlEncode([Convert]::ToBase64String($signature))

# API headers
$headers = @{
            "Authorization"="SharedAccessSignature sr=" + $encodedURI + "&sig=" + $signature + "&se=" + $expiry + "&skn=" + $keyname;
            "Content-Type"="application/atom+xml;type=entry;charset=utf-8"
                        }


# create Request Body



for ($i = 0; $i -lt [string]$numberOfEvents; $i++) {
  
  Write-Host "Sending event $i to eventhub"
  $rand = Get-Random -Minimum 25 -Maximum 100
  $body = "{'DeviceId':'dev-$i', 'Temperature':'$rand'}"

# execute the Azure REST API
Invoke-RestMethod -Uri $URI -Method $method -Headers $headers -Body $body

}