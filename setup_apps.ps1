# Pega o diretório onde está o script
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$importFile = Join-Path $scriptDir "apps.json"
$logFile = Join-Path $scriptDir "winget-install-log.txt"

# Verifica se está sendo executado como administrador
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
    [Security.Principal.WindowsBuiltInRole] "Administrator"))
{
    # Reexecuta o script como administrador
    Start-Process powershell "-ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

# Escreve no log que a instalação começou
Add-Content $logFile "`n--- Instalação iniciada em $(Get-Date) ---"

# Executa o winget import com log
try {
    winget import --import-file "$importFile" --accept-package-agreements --accept-source-agreements *>> $logFile
    Add-Content $logFile "`n--- Instalação finalizada em $(Get-Date) ---"
} catch {
    Add-Content $logFile "`n[ERRO] Algo deu errado: $_"
}
