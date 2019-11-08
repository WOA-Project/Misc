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
    
    $relativeToRoot = Split-Path $source.FullName -NoQualifier
    $destination = Join-Path $DestinationDrive $relativeToRoot
    
    Write-Host "Copying $($SourceFolder) to '$($destination)'. Please wait..." 
    Copy-Item $source -Destination $destination -Force -Recurse
    Remove-Item $source -Recurse -Force
    cmd /c mklink /j $SourceFolder $destination | Out-Null
    Write-Host "Success!" -ForegroundColor Green 
    Write-Host "$($SourceFolder) has been offloaded to $($DestinationDrive)" -ForegroundColor Green 
    
} 
catch
{
    Write-Error "Could not offload $($SourceFolder) to $($DestinationDrive)"
}