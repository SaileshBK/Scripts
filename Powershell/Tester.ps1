try {
    $filePath = Join-Path -Path $PSScriptRoot -ChildPath "Data\SimpleMath.cs"
    # Directory from which the PowerShell script is being run.
    Write-Host "$PSScriptRoot"
    # Our file path
    Write-Host "$filePath"
    Add-Type -Path $filePath

    $math = New-Object SimpleMath
    $result = $math.AddTwoNumber(10, 5)
    Write-Host "10 + 5 = $result"
}
catch {
    Write-Host "Failed to load file: $($_.Exception.Message)"
    if ($_.Exception.InnerException) {
        Write-Host "Inner Exception: $($_.Exception.InnerException.Message)"
        if ($_.Exception.InnerException.LoaderExceptions) {
            foreach ($loaderException in $_.Exception.InnerException.LoaderExceptions) {
                Write-Host "Loader Exception: $($loaderException.Message)"
            }
        }
        else {
            Write-Host "No LoaderExceptions found in InnerException."
        }
    }
    else {
        Write-Host "No InnerException found."
    }
}
