function Decode_Base64String {
    param (
        [string]$Base64Url
    )

    try {
        # Fix Base64URL encoding to Base64
        $Base64 = $Base64Url -replace '_', '/' -replace '-', '+'

        # Add padding if necessary
        $PaddingLength = 4 - ($Base64.Length % 4)
        if ($PaddingLength -ne 4) {
            $Base64 = $Base64 + ('=' * $PaddingLength)
        }

        # Convert Base64 string to byte array
        $Bytes = [Convert]::FromBase64String($Base64)
        
        # Convert byte array to string (UTF-8)
        return [System.Text.Encoding]::UTF8.GetString($Bytes)
    }
    catch {
        throw "Error decoding Base64Url string: $_"
    }
}

function Parse_JWT_String {
    param (
        [string]$JWT
    )
    
    try {
        # Split the JWT into three parts
        $parts = $JWT -split '\.'

        if ($parts.Length -ne 3) {
            throw "Invalid JWT format. A JWT should consist of three parts (header, payload, signature)."
        }

        $headerBase64 = $parts[0]
        $payloadBase64 = $parts[1]
        $signatureBase64 = $parts[2]

        # Decode the header and payload
        $headerJson = Decode_Base64String -Base64Url $headerBase64
        $payloadJson = Decode_Base64String -Base64Url $payloadBase64

        # Convert the header and payload JSON to PowerShell objects (PSCustomObject)
        $header = $headerJson | ConvertFrom-Json
        $payload = $payloadJson | ConvertFrom-Json

        # Return the decoded JWT parts
        return @{
            Header    = $header
            Payload   = $payload
            Signature = $signatureBase64
        }
    }
    catch {
        throw "Failed to parse JWT: $_"
    }
}

function Write_Colorful_Table {
    param (
        [string]$Title,
        [PSCustomObject]$Data,
        [string]$TitleColor = 'Yellow',
        [string]$KeyColor = 'Cyan',
        [string]$ValueColor = 'Green'
    )
    
    # Title Section with Color
    Write-Host "`n$Title" -ForegroundColor $TitleColor
    Write-Host "-----------------------------"

    # Loop through each property in the PSCustomObject and print it with color
    $Data.PSObject.Properties | ForEach-Object {
        $key = $_.Name
        $value = $_.Value
        
        Write-Host "$key" -ForegroundColor $KeyColor -NoNewline
        Write-Host ": $value" -ForegroundColor $ValueColor
    }
}

function Decrypt_JWT {
    param (
        [string]$JWT
    )
    
    try {
        $decodedJWT = Parse_JWT_String -JWT $JWT

        # Display Header Information
        Write_Colorful_Table -Title '[Header Information]' -Data $decodedJWT.Header -TitleColor 'Yellow' -KeyColor 'Cyan' -ValueColor 'Green'

        # Display Payload Information
        Write_Colorful_Table -Title '[Payload Information]' -Data $decodedJWT.Payload -TitleColor 'Yellow' -KeyColor 'Cyan' -ValueColor 'Green'

        # Display Signature Information
        Write-Host "`n[Signature (Base64 URL)]" -ForegroundColor 'Yellow'
        Write-Host "------------------------------"
        Write-Host $decodedJWT.Signature -ForegroundColor 'Green'
        Write-Host "------------------------------"
    }
    catch {
        Write-Error "Failed to decrypt JWT: $_"
    }
}

# Example usage:
# $JWT = "your-jwt-token-here"
# Decrypt_JWT -JWT $JWT

$JWT = ""
Decrypt_JWT -JWT $JWT
