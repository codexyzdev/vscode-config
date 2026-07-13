$ErrorActionPreference = "Stop"
$codeUser = "$env:APPDATA\Code\User"

if (-not (Test-Path $codeUser)) {
    New-Item -ItemType Directory -Path $codeUser -Force | Out-Null
}

Write-Host "=== VS Code Config Setup ===" -ForegroundColor Cyan
Write-Host ""

Write-Host "[1/2] Copiando settings.json..." -ForegroundColor Yellow
Copy-Item -Path ".\settings.json" -Destination "$codeUser\settings.json" -Force
Write-Host "       Listo." -ForegroundColor Green

Write-Host ""
Write-Host "[2/2] Instalando extensiones..." -ForegroundColor Yellow
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
