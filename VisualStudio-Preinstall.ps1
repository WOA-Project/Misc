function Map([string] $source, [string]$destination) 
{
    Remove-Item $source -Recurse -Force
    Remove-Item $destination -Recurse -Force
    New-Item -ItemType Directory -Path $destination
    cmd /c mklink /j $source $destination
}

$drive = "F:\"

$paths = @(
    "Program Files (x86)\Microsoft SDKs",
    "Program Files (x86)\Windows Kits",
    "Program Files (x86)\Microsoft Visual Studio"
)

foreach ($path in $paths) 
{
    $source = Join-Path "c:" $path
    $dest = Join-Path $drive $path
    Map $source $dest
}

