Set-Location $PSScriptRoot

$currentRootDirectory = (Get-Location).Path 
Write-Host "current dir: $currentRootDirectory"

$folderDirectory = Join-Path $currentRootDirectory "Folder1"

Write-Host "folder dir: $folderDirectory"

# Alternative way to grant permission
#icacls $folderDirectory /grant "$($env:USERNAME):(M)" /t
# Remove the directory and all its contents
Remove-Item -Path $folderDirectory -Recurse -Force