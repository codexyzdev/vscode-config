param(
    [Alias('y', 'yes')]
    [switch]$Force
)

$ErrorActionPreference = "Stop"
$codeUser = "$env:APPDATA\Code\User"
$scriptDir = $PSScriptRoot

if (-not (Test-Path $codeUser)) {
    New-Item -ItemType Directory -Path $codeUser -Force | Out-Null
}

$extCount = @(Get-Content ".\extensions.txt" | Where-Object { $_ -and -not $_.StartsWith("#") }).Count

Write-Host "=== VS Code Config Setup ===" -ForegroundColor Cyan
Write-Host ""
Write-Host "Esto va a:" -ForegroundColor Yellow
Write-Host "  - Respaldar tu config actual en .backups/<timestamp>/ (si existe)" -ForegroundColor Yellow
Write-Host "  - Instalar la fuente Fira Code" -ForegroundColor Yellow
Write-Host "  - Copiar settings.json a $codeUser" -ForegroundColor Yellow
Write-Host "  - Listar $extCount extensiones instaladas (para backup)" -ForegroundColor Yellow
Write-Host ""
Write-Host "Nota: las extensiones NO se instalan desde aca." -ForegroundColor Cyan
Write-Host "      Usa la carpeta .vscode/ o instala manualmente." -ForegroundColor Cyan
Write-Host ""

if (-not $Force) {
    $ans = Read-Host "¿Continuar? [s/N]"
    if ($ans -notin @("s", "S", "y", "Y")) {
        Write-Host "Cancelado." -ForegroundColor Yellow
        exit 0
    }
}

Write-Host ""
Write-Host "[1/3] Respaldando config previa..." -ForegroundColor Yellow
$backupRoot = Join-Path $scriptDir ".backups"
$timestamp = Get-Date -Format "yyyy-MM-dd_HHmmss"
$backupDir = Join-Path $backupRoot $timestamp
New-Item -ItemType Directory -Path $backupDir -Force | Out-Null

$hasBackup = $false
if (Test-Path "$codeUser\settings.json") {
    Copy-Item "$codeUser\settings.json" "$backupDir\settings.json"
    $hasBackup = $true
}
if (Test-Path "$codeUser\keybindings.json") {
    Copy-Item "$codeUser\keybindings.json" "$backupDir\keybindings.json"
    $hasBackup = $true
}
if (Test-Path "$codeUser\snippets") {
    Copy-Item "$codeUser\snippets" "$backupDir\snippets" -Recurse
    $hasBackup = $true
}

$codeCmd = Get-Command code -ErrorAction SilentlyContinue
if ($codeCmd) {
    $extOutput = & code --list-extensions 2>$null
    if ($LASTEXITCODE -eq 0) {
        [System.IO.File]::WriteAllText("$backupDir\extensions.txt", ($extOutput -join "`r`n"))
        $hasBackup = $true
    }
} else {
    Write-Host "       (code no en PATH, lista de extensiones omitida)" -ForegroundColor Yellow
}

if ($hasBackup) {
    Write-Host "       Backup en: $backupDir" -ForegroundColor Green
} else {
    Write-Host "       Sin config previa, salto backup." -ForegroundColor Yellow
    Remove-Item $backupDir -Recurse -Force -ErrorAction SilentlyContinue
}

Write-Host ""
Write-Host "[2/3] Instalando fuentes Fira Code..." -ForegroundColor Yellow
$fontDir = "$env:LOCALAPPDATA\Microsoft\Windows\Fonts"
if (-not (Test-Path $fontDir)) { New-Item -ItemType Directory -Path $fontDir -Force | Out-Null }
Get-ChildItem ".\fire code font\ttf\*.ttf" | ForEach-Object {
    $dest = Join-Path $fontDir $_.Name
    if (-not (Test-Path $dest)) {
        Copy-Item $_.FullName $dest
    }
}
Write-Host "       Listo." -ForegroundColor Green

Write-Host ""
Write-Host "[3/3] Copiando settings.json..." -ForegroundColor Yellow
Copy-Item -Path ".\settings.json" -Destination "$codeUser\settings.json" -Force
Write-Host "       Listo." -ForegroundColor Green

Write-Host ""
Write-Host "=== Setup completado ===" -ForegroundColor Cyan
Write-Host "Para instalar las extensiones recomendadas, abri VS Code y usa la"
Write-Host "carpeta .vscode/extensions.json de este repo, o instalalas manualmente."
