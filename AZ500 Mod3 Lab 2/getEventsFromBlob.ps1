################################################
#options to change
param(
[Parameter(Mandatory = $true)]
$blobName = "",
[Parameter(Mandatory = $true)]
$containerName =""
)
#################################################
# Load the System.Web assembly to enable UrlEncode


$BlobURL = "https://$blobname.blob.core.windows.net/$containerName?restype=container&comp=list&include=metadata"
$bloblist = Invoke-RestMethod -Method Get -Uri $BlobURL -ContentType "application/Xml" -ErrorAction SilentlyContinue
[xml]$bloblist = $bloblist.Substring($bloblist.IndexOf("<"))

$bloblist.EnumerationResults.Blobs.Blob | select name, url, @{n = "Timestamp"; e= {$bloblist.EnumerationResults.Blobs.Blob.Properties.'Last-Modified'[0]}} | ft -AutoSize

