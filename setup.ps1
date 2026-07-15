$ErrorActionPreference = "Stop"
$codeUser = "$env:APPDATA\Code\User"
$scriptDir = $PSScriptRoot

if (-not (Test-Path $codeUser)) {
    New-Item -ItemType Directory -Path $codeUser -Force | Out-Null
}

Write-Host "=== VS Code Config Setup ===" -ForegroundColor Cyan
Write-Host ""

Write-Host "[1/4] Respaldando config previa..." -ForegroundColor Yellow
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
Write-Host "[2/4] Instalando fuentes Fira Code..." -ForegroundColor Yellow
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
Write-Host "[3/4] Copiando settings.json..." -ForegroundColor Yellow
Copy-Item -Path ".\settings.json" -Destination "$codeUser\settings.json" -Force
Write-Host "       Listo." -ForegroundColor Green

Write-Host ""
Write-Host "[4/4] Instalando extensiones..." -ForegroundColor Yellow
Get-Content .\extensions.txt | ForEach-Object {
    $ext = $_.Trim()
    if ($ext -and -not $ext.StartsWith("#")) {
        Write-Host "       $ext ..." -NoNewline
        code --install-extension $ext --force 2>$null
        Write-Host " OK" -ForegroundColor Green
    }
}

Write-Host ""
Write-Host "=== Setup completado ===" -ForegroundColor Cyan
