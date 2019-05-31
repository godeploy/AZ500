
<#PSScriptInfo

.VERSION 1.0

.GUID 28b85919-e52e-407e-9833-d46a2d6dff1c

.AUTHOR mike@michaelwhitehouse.com

.COMPANYNAME 

.COPYRIGHT 

.TAGS 

.LICENSEURI 

.PROJECTURI 

.ICONURI 

.EXTERNALMODULEDEPENDENCIES 

.REQUIREDSCRIPTS 

.EXTERNALSCRIPTDEPENDENCIES 

.RELEASENOTES


#>

<# 

.DESCRIPTION 
 Supporting script file for use with godeploy AZ500 labs 

#> 
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


$BlobURL = "https://$blobname.blob.core.windows.net/$containerName`?restype=container&comp=list&include=metadata"
$bloblist = Invoke-RestMethod -Method Get -Uri $BlobURL -ContentType "application/xml" -ErrorAction SilentlyContinue
[xml]$bloblist = $bloblist.Substring($bloblist.IndexOf("<"))

$bloblist.EnumerationResults.Blobs.Blob | select name, url, @{n = "Timestamp"; e= {$bloblist.EnumerationResults.Blobs.Blob.Properties.'Last-Modified'[0]}} | ft -AutoSize


