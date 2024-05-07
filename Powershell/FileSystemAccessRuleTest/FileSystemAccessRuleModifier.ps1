# Set the root directory to the script's directory
Set-Location $PSScriptRoot

$currentRootDirectory = (Get-Location).Path 
Write-Host "current dir: $currentRootDirectory"

$folderDirectory = Join-Path $currentRootDirectory "Folder1"

# Create a new access rule by dynamically grabbing current PS user
#$accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule("Everyone", "Read", "Allow")
$accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule($($env:USERNAME), "Modify", "Allow")

 #Get the current ACL of the file
$acl = Get-Acl -Path $folderDirectory

# Remove all inherited access rules
$acl.SetAccessRuleProtection($true, $false)

# Add the new Access Rule to the ACL
$acl.SetAccessRule($accessRule)

# Apply the modified ACL to the folder
Set-ACL -Path $folderDirectory -AclObject $acl

# Apply the modified ACL recursively to all subdirectories and files
Get-ChildItem $folderDirectory -Recurse -Force | ForEach-Object {
    Set-ACL -Path $_.FullName -AclObject $acl
}

