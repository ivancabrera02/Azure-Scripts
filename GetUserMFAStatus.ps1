# Obtener todos los usuarios de Azure AD
$users = az ad user list --query "[].{UserPrincipalName:userPrincipalName, MFAEnabled:strongAuthenticationMethods}" --output json | ConvertFrom-Json

# Verificar MFA para cada usuario
foreach ($user in $users) {
    $mfaEnabled = $user.MFAEnabled.Count -gt 0
    if ($mfaEnabled) {
        Write-Host "El usuario $($user.UserPrincipalName) tiene MFA habilitado."
    } else {
        Write-Host "El usuario $($user.UserPrincipalName) NO tiene MFA habilitado."
    }
}