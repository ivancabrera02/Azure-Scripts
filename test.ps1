# Iniciar sesión en Azure utilizando Azure CLI
az login

# Obtener todos los servidores SQL
$servers = az sql server list --output json | ConvertFrom-Json

# Iterar sobre cada servidor para obtener las bases de datos y las configuraciones de red
$servers | ForEach-Object {
    $server = $_
    Write-Host "Servidor SQL: $($server.name)"

    # Obtener todas las bases de datos en el servidor específico
    $databases = az sql db list --resource-group $server.resourceGroup --server $server.name --output json | ConvertFrom-Json
    
    # Verificar si hay bases de datos
    if ($databases) {
        $databases | ForEach-Object {
            $database = $_
            Write-Host "  Base de datos: $($database.name)"
            
            # Obtener la configuración de redes del servidor SQL
            $firewallRules = az sql server firewall-rule list --resource-group $server.resourceGroup --server $server.name --output json | ConvertFrom-Json
            
            Write-Host "  Reglas de firewall:"
            $firewallRules | ForEach-Object {
                $rule = $_
                Write-Host "    - Regla: $($rule.name)"
                Write-Host "      IP Inicio: $($rule.startIpAddress)"
                Write-Host "      IP Fin: $($rule.endIpAddress)"
            }
            Write-Host ""
        }
    } else {
        Write-Host "  No hay bases de datos en este servidor."
    }

    Write-Host ""
}

Write-Host "Completado."
