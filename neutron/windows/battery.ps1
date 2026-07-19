<#
.SYNOPSIS
    Neutron - Battery tweaks for Xiaomi Redmi 10 2022
.DESCRIPTION
    Applies battery optimization and power-saving tweaks.
#>

$ErrorActionPreference = "Stop"

Write-Host "============================================" -ForegroundColor Cyan
Write-Host "  Neutron v1.0.0 - Battery Tweaks" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

$rootCheck = adb shell "su -c 'id'" 2>$null
if ($rootCheck -notmatch "uid=0") {
    Write-Host "[!] Root required." -ForegroundColor Red
    exit 1
}

adb shell "su -c 'mount -o remount,rw /vendor'" 2>$null

$Props = @{
    "powersave.enabled"                       = "1"
    "ro.config.alarm_alert"                   = "vibra.ogg"
    "ro.ril.power_collapse"                   = "1"
    "persist.radio.apm_sim_not_pwdn"          = "1"
    "deviceidle.disabled"                     = "false"
    "ro.vendor.qti.cgroup_follow.enable"      = "1"
}

Write-Host "[*] Applying battery tweaks..." -ForegroundColor Yellow
foreach ($key in $Props.Keys) {
    $val = $Props[$key]
    adb shell "su -c 'sed -i /^$key/d /vendor/build.prop'" 2>$null
    adb shell "su -c 'echo $key=$val >> /vendor/build.prop'" 2>$null
    Write-Host "  [+] $key=$val" -ForegroundColor Green
}

Write-Host ""
Write-Host "[*] Configuring Doze mode..." -ForegroundColor Yellow
adb shell "su -c 'settings put global adaptive_battery_saving_enabled 1'" 2>$null
adb shell "su -c 'settings put global always_on_display_constants'" 2>$null
Write-Host "  [+] Adaptive battery enabled" -ForegroundColor Green

Write-Host ""
Write-Host "[*] Reducing wake locks..." -ForegroundColor Yellow
adb shell "su -c 'settings put global sem_power_profile 2'" 2>$null
Write-Host "  [+] Power profile optimized" -ForegroundColor Green

Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "  Battery tweaks applied!" -ForegroundColor Green
Write-Host "  Reboot recommended: adb reboot" -ForegroundColor Gray
Write-Host "============================================" -ForegroundColor Cyan
