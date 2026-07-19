<#
.SYNOPSIS
    Neutron - Apply all tweaks at once
.DESCRIPTION
    Runs debloat, performance, battery, display, and memory tweaks.
#>

$ErrorActionPreference = "Stop"

Write-Host "============================================" -ForegroundColor Cyan
Write-Host "  Neutron v1.0.0 - Install All Tweaks" -ForegroundColor Cyan
Write-Host "  Device: Xiaomi Redmi 10 2022 (selene)" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

$rootCheck = adb shell "su -c 'id'" 2>$null
if ($rootCheck -notmatch "uid=0") {
    Write-Host "[!] Root required." -ForegroundColor Red
    exit 1
}

adb shell "su -c 'mount -o remount,rw /vendor'" 2>$null

# Debloat
Write-Host "[*] === DEBLOAT ===" -ForegroundColor Yellow
& "$PSScriptRoot\debloat.ps1"
Write-Host ""

# Performance
Write-Host "[*] === PERFORMANCE ===" -ForegroundColor Yellow
& "$PSScriptRoot\perf.ps1"
Write-Host ""

# Battery
Write-Host "[*] === BATTERY ===" -ForegroundColor Yellow
& "$PSScriptRoot\battery.ps1"
Write-Host ""

# Display
Write-Host "[*] === DISPLAY ===" -ForegroundColor Yellow
& "$PSScriptRoot\display.ps1"
Write-Host ""

# Memory
Write-Host "[*] === MEMORY ===" -ForegroundColor Yellow
& "$PSScriptRoot\memory.ps1"
Write-Host ""

Write-Host "============================================" -ForegroundColor Cyan
Write-Host "  ALL TWEAKS APPLIED!" -ForegroundColor Green
Write-Host "  Reboot recommended: adb reboot" -ForegroundColor Gray
Write-Host "============================================" -ForegroundColor Cyan
