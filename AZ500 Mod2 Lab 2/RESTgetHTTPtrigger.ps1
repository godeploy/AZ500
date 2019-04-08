# Replace this with yours ;)
$functionappname = ""
$functionname = "HttpTriggerPowerShell1"
$functionkey = ""

$YourURI = "https://$functionappname.azurewebsites.net/api/$functionname`?code=$functionkey"

# Try a normal GET
Invoke-RestMethod -Method Get -Uri $YourURI
# GET using the "name" query parameter
Invoke-RestMethod -Method Get -Uri "$($YourURI)&name=World!"

# Use the POST method provided
$Body = @{name = 'Max Power'} | ConvertTo-Json
Invoke-RestMethod -Method Post -Body $Body -Uri $YourURI