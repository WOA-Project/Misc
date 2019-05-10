[cmdletbinding()]
param ([Parameter(mandatory=$true)][string] $drive)

function CustomCopy
{
    param([string]$source, [string]$dest)

    if (!(Test-Path $dest -PathType Container)) 
    {
        New-Item -Path $dest -ItemType Directory
    }

    Copy-Item $source $dest -ErrorAction SilentlyContinue -Recurse
}

$tempFolder = New-TemporaryFile | %{ rm $_; mkdir $_ }

CustomCopy (Join-Path $drive "Windows\Panther\*") (Join-Path $tempFolder "Panther")
CustomCopy (Join-Path $drive "Windows\MiniDump\*") (Join-Path $tempFolder "MiniDump")
CustomCopy (Join-Path $drive "Windows\CrashDump\*") (Join-Path $tempFolder "CrashDump")
CustomCopy (Join-Path $drive "Windows\MEMORY*.dmp")  (Join-Path $tempFolder "")
CustomCopy (Join-Path $drive "Windows\inf\*log*") (Join-Path $tempFolder "inf")
CustomCopy (Join-Path $drive "Windows\Logs\**") (Join-Path $tempFolder "Logs")

Compress-Archive -Path "$($tempFolder)\*" -DestinationPath "Logs.zip"
Remove-Item $tempFolder -Recurse -Force
