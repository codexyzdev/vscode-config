param(
    [string]$Timestamp = "",
    [switch]$Force
)

$ErrorActionPreference = "Stop"
$scriptDir = $PSScriptRoot
$backupRoot = Join-Path $scriptDir ".backups"
$codeUser = "$env:APPDATA\Code\User"

function Show-Usage {
    Write-Host "Uso: .\restore.ps1 [opciones] [timestamp]"
    Write-Host ""
    Write-Host "Opciones:"
    Write-Host "  -Timestamp <id>  Backup específico (formato: yyyy-MM-dd_HHmmss)"
    Write-Host "  -Force           No pedir confirmación"
    Write-Host "  -?               Mostrar esta ayuda"
    Write-Host ""
    Write-Host "Si no se pasa -Timestamp, se usa el backup más reciente en .backups/."
    exit 0
}

if ($args -contains "-?" -or $args -contains "--help" -or $args -contains "-h") {
    Show-Usage
}

if (-not (Test-Path $backupRoot)) {
    Write-Host "Error: No existe la carpeta $backupRoot. Ejecute setup.ps1 primero." -ForegroundColor Red
    exit 1
}

if (-not $Timestamp) {
    $latest = Get-ChildItem -Directory $backupRoot | Sort-Object Name | Select-Object -Last 1
    if (-not $latest) {
        Write-Host "Error: No hay backups en $backupRoot." -ForegroundColor Red
        exit 1
    }
    $Timestamp = $latest.Name
    Write-Host "Usando el backup más reciente: $Timestamp" -ForegroundColor Cyan
}

$backupDir = Join-Path $backupRoot $Timestamp
if (-not (Test-Path $backupDir)) {
    Write-Host "Error: No existe el backup $backupDir." -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "Esto va a restaurar tu config desde:" -ForegroundColor Yellow
Write-Host "  $backupDir" -ForegroundColor Yellow
Write-Host "  a: $codeUser" -ForegroundColor Yellow
Write-Host ""

if (-not $Force) {
    $ans = Read-Host "¿Continuar? [s/N]"
    if ($ans -notin @("s", "S", "y", "Y")) {
        Write-Host "Cancelado." -ForegroundColor Yellow
        exit 0
    }
}

if (-not (Test-Path $codeUser)) {
    New-Item -ItemType Directory -Path $codeUser -Force | Out-Null
}

$settingsFile = Join-Path $backupDir "settings.json"
if (Test-Path $settingsFile) {
    Copy-Item $settingsFile "$codeUser\settings.json" -Force
    Write-Host "[OK] settings.json" -ForegroundColor Green
}
$keybindingsFile = Join-Path $backupDir "keybindings.json"
if (Test-Path $keybindingsFile) {
    Copy-Item $keybindingsFile "$codeUser\keybindings.json" -Force
    Write-Host "[OK] keybindings.json" -ForegroundColor Green
}
$snippetsDir = Join-Path $backupDir "snippets"
if (Test-Path $snippetsDir) {
    $destSnippets = Join-Path $codeUser "snippets"
    if (Test-Path $destSnippets) { Remove-Item $destSnippets -Recurse -Force }
    Copy-Item $snippetsDir $destSnippets -Recurse -Force
    Write-Host "[OK] snippets/" -ForegroundColor Green
}

$extList = Join-Path $backupDir "extensions.txt"
if (Test-Path $extList) {
    $codeCmd = Get-Command code -ErrorAction SilentlyContinue
    if (-not $codeCmd) {
        Write-Host "[SKIP] code no en PATH, no se restauran extensiones." -ForegroundColor Yellow
    } else {
        Write-Host ""
        Write-Host "Restaurando extensiones..." -ForegroundColor Yellow
        $currentExt = @(& code --list-extensions 2>$null)
        $backupExt = @(Get-Content $extList | Where-Object { $_.Trim() -ne "" })

        foreach ($ext in $currentExt) {
            if ($backupExt -notcontains $ext) {
                Write-Host "       uninstall $ext ..." -NoNewline
                & code --uninstall-extension $ext 2>$null | Out-Null
                Write-Host " OK" -ForegroundColor Green
            }
        }
        foreach ($ext in $backupExt) {
            if ($currentExt -notcontains $ext) {
                Write-Host "       install   $ext ..." -NoNewline
                & code --install-extension $ext --force 2>$null | Out-Null
                Write-Host " OK" -ForegroundColor Green
            }
        }
    }
}

Write-Host ""
Write-Host "=== Restauración completada ===" -ForegroundColor Cyan
