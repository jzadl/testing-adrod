<#
.SYNOPSIS
    Neutron - Display tweaks for Xiaomi Redmi 10 2022 (90Hz panel)
.DESCRIPTION
    Applies display rendering and refresh rate tweaks.
#>

$ErrorActionPreference = "Stop"

Write-Host "============================================" -ForegroundColor Cyan
Write-Host "  Neutron v1.0.0 - Display Tweaks" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

$rootCheck = adb shell "su -c 'id'" 2>$null
if ($rootCheck -notmatch "uid=0") {
    Write-Host "[!] Root required." -ForegroundColor Red
    exit 1
}

adb shell "su -c 'mount -o remount,rw /vendor'" 2>$null

$Props = @{
    "ro.surface_flinger.max_frame_buffer_acquired_buffers" = "3"
    "debug.sf.fps"                                         = "90"
    "debug.sf.latch_unsignaled"                           = "1"
    "debug.renderengine.backend"                          = "skiagl"
    "ro.surface_flinger.running_without_sync_framework"   = "true"
}

Write-Host "[*] Applying display tweaks..." -ForegroundColor Yellow
foreach ($key in $Props.Keys) {
    $val = $Props[$key]
    adb shell "su -c 'sed -i /^$key/d /vendor/build.prop'" 2>$null
    adb shell "su -c 'echo $key=$val >> /vendor/build.prop'" 2>$null
    Write-Host "  [+] $key=$val" -ForegroundColor Green
}

Write-Host ""
Write-Host "[*] Forcing 90Hz refresh rate..." -ForegroundColor Yellow
adb shell "su -c 'settings put system peak_refresh_rate 90'" 2>$null
adb shell "su -c 'settings put system min_refresh_rate 60'" 2>$null
adb shell "su -c 'settings put global display_mode_forced 90'" 2>$null
Write-Host "  [+] Refresh rate: 90Hz" -ForegroundColor Green

Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "  Display tweaks applied!" -ForegroundColor Green
Write-Host "  Reboot recommended: adb reboot" -ForegroundColor Gray
Write-Host "============================================" -ForegroundColor Cyan
