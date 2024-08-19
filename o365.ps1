param(
    [string]$email,
    [string]$file,
    [string]$output
)

$url = 'https://login.microsoftonline.com/common/GetCredentialType'

function Test-Email {
    param (
        [string]$emailAddress
    )

    $body = @{
        Username = $emailAddress
    } | ConvertTo-Json

    try {
        $response = Invoke-RestMethod -Uri $url -Method Post -Body $body -ContentType 'application/json'
        if ($response.IfExistsResult -eq 0) {
            return 'VALID'
        } elseif ($response.IfExistsResult -eq 1) {
            return 'INVALID'
        } else {
            return 'UNKNOWN'
        }
    } catch {
        return 'ERROR'
    }
}

if ($file) {
    $emails = Get-Content $file
    foreach ($email in $emails) {
        $email = $email.Trim()
        $status = Test-Email -emailAddress $email
        if ($status -eq 'VALID') {
            Write-Output "$email - VALID"
            if ($output) {
                Add-Content -Path $output -Value $email
            }
        } elseif ($status -eq 'INVALID') {
            Write-Output "$email - INVALID"
        } else {
            Write-Output "$email - $status"
        }
    }
} elseif ($email) {
    $status = Test-Email -emailAddress $email
    if ($status -eq 'VALID') {
        Write-Output "$email - VALID"
        if ($output) {
            Set-Content -Path $output -Value $email
        }
    } elseif ($status -eq 'INVALID') {
        Write-Output "$email - INVALID"
    } else {
        Write-Output "$email - $status"
    }
} else {
    Write-Output "Please provide an email address or a file containing email addresses."
}
