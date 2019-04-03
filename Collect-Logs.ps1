[cmdletbinding()]
param ([Parameter(mandatory=$true)][string] $drive)

function CustomCopy
{
    param([string]$source, [string]$dest)

    if (!(Test-Path $dest -PathType Container)) 
    {
        New-Item -Path $dest -ItemType Directory
    }

    Copy-Item $source $dest -ErrorAction SilentlyContinue
}

$tempFolder = New-TemporaryFile | %{ rm $_; mkdir $_ }

CustomCopy (Join-Path $drive "Windows\Panther\*") (Join-Path $tempFolder "Panther")
CustomCopy (Join-Path $drive "Windows\MiniDumps\*") (Join-Path $tempFolder "MiniDumps")
CustomCopy (Join-Path $drive "Windows\CrashDumps\*") (Join-Path $tempFolder "CrashDumps")
CustomCopy (Join-Path $drive "Windows\MEMORY*.dmp")  (Join-Path $tempFolder "")
CustomCopy (Join-Path $drive "Windows\inf\*log*") (Join-Path $tempFolder "inf")

Compress-Archive -Path "$($tempFolder)\*" -DestinationPath "Logs.zip"
Remove-Item $tempFolder -Recurse -Force
