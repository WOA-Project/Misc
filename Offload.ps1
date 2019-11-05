[CmdletBinding()]
param(
    [Parameter(mandatory=$true)]
    [string]$SourceFolder,
    [Parameter(mandatory=$true)]
    [string]$DestinationDrive
)

if (Test-Path $SourceFolder)
{
    $source = Get-Item $SourceFolder
} else 
{
    $source = New-Item $Sourcefolder -ItemType Directory
}


$noQualifierPath = Split-Path $source.FullName -NoQualifier
$destFolder = Join-Path $DestinationDrive $noQualifierPath
    
if (!(Test-Path $destFolder))
{
    New-Item -Path $destFolder -ItemType Directory
}

Copy-Item $source -Destination $destFolder -Recurse
Remove-Item $source -Recurse -Force
cmd /c mklink /j $SourceFolder $destFolder