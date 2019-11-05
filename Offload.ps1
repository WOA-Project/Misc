[CmdletBinding()]
param(
    [Parameter(mandatory=$true)]
    [string]$SourceFolder,
    [Parameter(mandatory=$true)]
    [string]$DestinationDrive
)

try 
{

    if (Test-Path $SourceFolder)
    {
        $source = Get-Item $SourceFolder
    } else 
    {
        $source = New-Item $Sourcefolder -ItemType Directory -n | Out-Null
    }
    
    $parent = $source.Parent
    $noQualifierPath = Split-Path $parent.FullName -NoQualifier
    $destFolder = Join-Path $DestinationDrive $noQualifierPath
    
    Write-Host "Copying folder to '$($destFolder)'. Please wait..." 
    Copy-Item $source -Destination $destFolder -Force -Recurse
    Remove-Item $source -Recurse -Force
    cmd /c mklink /j $SourceFolder $destFolder | Out-Null
    Write-Host "Success!" -ForegroundColor Green 
    Write-Host "$($SourceFolder) has been offloaded to $($DestinationDrive)" -ForegroundColor Green 
    
} 
catch
{
    Write-Error "Could not offload $($SourceFolder) to $($DestinationDrive)"
}