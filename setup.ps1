param(
    [Alias('y', 'yes')]
    [switch]$Force
)

$ErrorActionPreference = "Stop"
try {
    [Console]::OutputEncoding = [System.Text.Encoding]::UTF8
} catch {
    # ignore on hosts where OutputEncoding is read-only
}
$codeUser = "$env:APPDATA\Code\User"
$scriptDir = $PSScriptRoot

if (-not (Test-Path $codeUser)) {
    New-Item -ItemType Directory -Path $codeUser -Force | Out-Null
}

$codeCmd = Get-Command code -ErrorAction SilentlyContinue
if (-not $codeCmd) {
    Write-Host "=== VS Code Config Setup ===" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "x VS Code no detectado" -ForegroundColor Red
    Write-Host ""
    Write-Host "  Para que 'code' funcione en la terminal:"
    Write-Host "  1. Abrí VS Code"
    Write-Host "  2. View > Command Palette > 'Shell Command: Install 'code' command in PATH'"
    Write-Host "  3. Reiniciá la terminal y volvé a correr el setup"
    exit 1
}

$extCount = 0
if (Test-Path "$scriptDir\extensions.txt") {
    $extCount = @(Get-Content "$scriptDir\extensions.txt" | Where-Object { $_ -and -not $_.StartsWith("#") }).Count
}
$hasKeybindings = Test-Path "$scriptDir\keybindings.json"
$hasSnippets = Test-Path "$scriptDir\snippets"

Write-Host "=== VS Code Config Setup ===" -ForegroundColor Cyan
Write-Host ""
Write-Host "Esto va a:" -ForegroundColor Yellow
Write-Host "  - Respaldar tu config actual en .backups/<timestamp>/ (si existe)" -ForegroundColor Yellow
Write-Host "  - Instalar $extCount extensiones desde extensions.txt" -ForegroundColor Yellow
Write-Host "  - Instalar y registrar la fuente Fira Code" -ForegroundColor Yellow
Write-Host "  - Copiar settings.json a $codeUser" -ForegroundColor Yellow
if ($hasKeybindings) { Write-Host "  - Copiar keybindings.json" -ForegroundColor Yellow }
if ($hasSnippets) { Write-Host "  - Copiar snippets/" -ForegroundColor Yellow }
Write-Host ""

if (-not $Force) {
    $ans = Read-Host "Continuar? [s/N]"
    if ($ans -notin @("s", "S", "y", "Y")) {
        Write-Host "Cancelado." -ForegroundColor Yellow
        exit 0
    }
}

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

$extOutput = & code --list-extensions 2>$null
if ($LASTEXITCODE -eq 0 -and $extOutput) {
    [System.IO.File]::WriteAllText("$backupDir\extensions.txt", ($extOutput -join "`r`n"))
    $hasBackup = $true
}

if ($hasBackup) {
    Write-Host "       Backup en: $backupDir" -ForegroundColor Green
} else {
    Write-Host "       Sin config previa, salto backup." -ForegroundColor Yellow
    Remove-Item $backupDir -Recurse -Force -ErrorAction SilentlyContinue
}

Write-Host ""
Write-Host "[2/4] Instalando extensiones..." -ForegroundColor Yellow
if (-not (Test-Path "$scriptDir\extensions.txt")) {
    Write-Host "       extensions.txt no encontrado, salto." -ForegroundColor Yellow
} elseif ($extCount -eq 0) {
    Write-Host "       extensions.txt esta vacio, salto." -ForegroundColor Yellow
} else {
    $extensions = @(Get-Content "$scriptDir\extensions.txt" | Where-Object { $_ -and -not $_.StartsWith("#") } | ForEach-Object { $_.Trim() })
    $total = $extensions.Count
    $barWidth = 20
    $maxParallel = 4

    $progressDir = Join-Path $env:TEMP "vscode-config-setup-$timestamp"
    New-Item -ItemType Directory -Path $progressDir -Force | Out-Null

    $installBlock = {
        param($idx, $ext, $progressDir)
        try {
            & code --install-extension $ext --force *> $null
            if ($LASTEXITCODE -eq 0) {
                "OK" | Set-Content -Path "$progressDir\$idx.status" -NoNewline
            } else {
                "FAIL" | Set-Content -Path "$progressDir\$idx.status" -NoNewline
            }
        } catch {
            "FAIL" | Set-Content -Path "$progressDir\$idx.status" -NoNewline
        }
    }

    $jobs = @()
    $nextIdx = 0

    try {
        while ($nextIdx -lt $total -and $jobs.Count -lt $maxParallel) {
            $jobs += Start-Job -ScriptBlock $installBlock -ArgumentList $nextIdx, $extensions[$nextIdx], $progressDir
            $nextIdx++
        }

        while ($jobs.Count -gt 0) {
            $done = 0
            for ($j = 0; $j -lt $total; $j++) {
                if (Test-Path "$progressDir\$j.status") { $done++ }
            }

            if ($done -gt 0) {
                $filled = [Math]::Floor($done * $barWidth / $total)
            } else {
                $filled = 0
            }
            $empty = $barWidth - $filled
            if ($empty -gt 0) {
                $emptyStr = [string]::new([char]0x2591, $empty)
            } else {
                $emptyStr = ""
            }
            $bar = "[" + ("#" * $filled) + $emptyStr + "]"
            [Console]::Write("`r{0} {1}/{2}" -f $bar, $done, $total)

            $jobs | Wait-Job -Any | Out-Null
            $jobs = @($jobs | Where-Object { $_.State -eq 'Running' })

            if ($nextIdx -lt $total) {
                $jobs += Start-Job -ScriptBlock $installBlock -ArgumentList $nextIdx, $extensions[$nextIdx], $progressDir
                $nextIdx++
            }

            Start-Sleep -Milliseconds 100
        }

        $barFull = "[" + ("#" * $barWidth) + "]"
        [Console]::WriteLine("`r{0} {1}/{2}" -f $barFull, $total, $total)

        $installed = 0
        $failed = @()
        for ($i = 0; $i -lt $total; $i++) {
            $statusFile = Join-Path $progressDir "$i.status"
            if (Test-Path $statusFile) {
                $status = Get-Content $statusFile
                if ($status -eq "OK") {
                    $installed++
                } else {
                    $failed += $extensions[$i]
                }
            } else {
                $failed += $extensions[$i]
            }
        }

        Write-Host "       OK $installed/$total extensiones instaladas" -ForegroundColor Green
        if ($failed.Count -gt 0) {
            Write-Host "       ! Fallaron $($failed.Count) extensiones:" -ForegroundColor Yellow
            foreach ($ext in $failed) {
                Write-Host "         - $ext" -ForegroundColor Yellow
            }
        }
    } finally {
        if ($jobs) {
            $jobs | Remove-Job -Force -ErrorAction SilentlyContinue
        }
        Remove-Item $progressDir -Recurse -Force -ErrorAction SilentlyContinue
    }
}

Write-Host ""
Write-Host "[3/4] Instalando fuentes Fira Code..." -ForegroundColor Yellow
$fontDir = "$env:LOCALAPPDATA\Microsoft\Windows\Fonts"
if (-not (Test-Path $fontDir)) { New-Item -ItemType Directory -Path $fontDir -Force | Out-Null }
$fontSourceDir = Join-Path $scriptDir "fire code font\ttf"

if (-not (Test-Path $fontSourceDir)) {
    Write-Host "       No se encontro fire code font/ttf/, salto." -ForegroundColor Yellow
} else {
    if (-not ([System.Management.Automation.PSTypeName]'FontHelper').Type) {
        $fontSig = @"
using System;
using System.Runtime.InteropServices;

public class FontHelper {
    [DllImport("gdi32.dll", CharSet = CharSet.Unicode)]
    public static extern int AddFontResource(string lpFilename);

    [DllImport("user32.dll", CharSet = CharSet.Auto)]
    public static extern IntPtr SendMessageTimeout(IntPtr hWnd, uint Msg, IntPtr wParam, IntPtr lParam, uint fuFlags, uint uTimeout, out IntPtr lpdwResult);
}
"@
        Add-Type -TypeDefinition $fontSig -Language CSharp
    }

    Add-Type -AssemblyName System.Drawing

    $regPath = "HKCU:\Software\Microsoft\Windows NT\CurrentVersion\Fonts"
    $registered = 0
    foreach ($font in Get-ChildItem "$fontSourceDir\*.ttf") {
        $dest = Join-Path $fontDir $font.Name
        if (-not (Test-Path $dest)) {
            Copy-Item $font.FullName $dest
        }

        $displayName = $null
        try {
            $fontInfo = New-Object System.Drawing.Text.PrivateFontCollection
            $fontInfo.AddFontFile($dest)
            if ($fontInfo.Families.Count -gt 0) {
                $displayName = $fontInfo.Families[0].Name
            }
            $fontInfo.Dispose()
        } catch {
            $displayName = $null
        }

        if (-not $displayName) {
            $displayName = (($font.BaseName -replace 'FiraCode', 'Fira Code') -replace '-', ' ')
        }

        $regName = "$displayName (TrueType)"
        $currentReg = Get-ItemProperty -Path $regPath -Name $regName -ErrorAction SilentlyContinue
        if (-not $currentReg -or $currentReg.$regName -ne $font.Name) {
            Set-ItemProperty -Path $regPath -Name $regName -Value $font.Name -Force
        }

        [FontHelper]::AddFontResource($dest) | Out-Null
        $registered++
    }

    $HWND_BROADCAST = [IntPtr]0xffff
    $WM_FONTCHANGE = 0x001D
    [IntPtr]$result = [IntPtr]::Zero
    [FontHelper]::SendMessageTimeout($HWND_BROADCAST, $WM_FONTCHANGE, [IntPtr]::Zero, [IntPtr]::Zero, 2, 1000, [ref]$result) | Out-Null

    Write-Host "       OK $registered fuentes instaladas y registradas" -ForegroundColor Green
}

Write-Host ""
Write-Host "[4/4] Copiando config..." -ForegroundColor Yellow

try {
    Copy-Item -Path "$scriptDir\settings.json" -Destination "$codeUser\settings.json" -Force
    Write-Host "       OK settings.json" -ForegroundColor Green
} catch {
    Write-Host "       x Error copiando settings.json: $_" -ForegroundColor Red
    exit 1
}

if ($hasKeybindings) {
    Copy-Item -Path "$scriptDir\keybindings.json" -Destination "$codeUser\keybindings.json" -Force
    Write-Host "       OK keybindings.json" -ForegroundColor Green
}

if ($hasSnippets) {
    $destSnippets = Join-Path $codeUser "snippets"
    if (Test-Path $destSnippets) { Remove-Item $destSnippets -Recurse -Force }
    Copy-Item -Path "$scriptDir\snippets" -Destination $destSnippets -Recurse -Force
    Write-Host "       OK snippets/" -ForegroundColor Green
}

Write-Host ""
Write-Host "=== Setup completado ===" -ForegroundColor Cyan
Write-Host "Recargá VS Code (Ctrl+Shift+P > 'Developer: Reload Window') para aplicar cambios."
