$ErrorActionPreference = "Stop"
$codeUser = "$env:APPDATA\Code\User"

if (-not (Test-Path $codeUser)) {
    New-Item -ItemType Directory -Path $codeUser -Force | Out-Null
}

Write-Host "=== VS Code Config Setup ===" -ForegroundColor Cyan
Write-Host ""

Write-Host "[1/3] Instalando fuentes Fira Code..." -ForegroundColor Yellow
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
Write-Host "[2/3] Copiando settings.json..." -ForegroundColor Yellow
Copy-Item -Path ".\settings.json" -Destination "$codeUser\settings.json" -Force
Write-Host "       Listo." -ForegroundColor Green

Write-Host ""
Write-Host "[3/3] Instalando extensiones..." -ForegroundColor Yellow
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
