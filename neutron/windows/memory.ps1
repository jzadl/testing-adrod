<#
.SYNOPSIS
    Neutron - Memory/ZRAM tweaks for Xiaomi Redmi 10 2022
.DESCRIPTION
    Optimizes RAM management and ZRAM compression.
#>

$ErrorActionPreference = "Stop"

Write-Host "============================================" -ForegroundColor Cyan
Write-Host "  Neutron v1.0.0 - Memory Tweaks" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

$rootCheck = adb shell "su -c 'id'" 2>$null
if ($rootCheck -notmatch "uid=0") {
    Write-Host "[!] Root required." -ForegroundColor Red
    exit 1
}

adb shell "su -c 'mount -o remount,rw /vendor'" 2>$null

$Props = @{
    "ro.config.zram"              = "true"
    "ro.lmk.critical_upgrade"     = "true"
    "ro.lmk.upgrade_pressure"     = "100"
    "ro.lmk.downgrade_pressure"   = "100"
}

Write-Host "[*] Applying memory tweaks..." -ForegroundColor Yellow
foreach ($key in $Props.Keys) {
    $val = $Props[$key]
    adb shell "su -c 'sed -i /^$key/d /vendor/build.prop'" 2>$null
    adb shell "su -c 'echo $key=$val >> /vendor/build.prop'" 2>$null
    Write-Host "  [+] $key=$val" -ForegroundColor Green
}

Write-Host ""
Write-Host "[*] Configuring ZRAM..." -ForegroundColor Yellow
$memTotal = (adb shell "cat /proc/meminfo | head -1" 2>$null) -replace '[^0-9]', ''
$zramSize = [math]::Round([int]$memTotal * 0.75)
adb shell "su -c 'echo lz4 > /sys/block/zram0/comp_algorithm'" 2>$null
adb shell "su -c 'swapoff /dev/block/zram0 2>/dev/null'" 2>$null
adb shell "su -c 'echo $([math]::Round($zramSize * 1024)) > /sys/block/zram0/disksize'" 2>$null
adb shell "su -c 'mkswap /dev/block/zram0'" 2>$null
adb shell "su -c 'swapon /dev/block/zram0'" 2>$null
Write-Host "  [+] ZRAM: ${zramSize}KB with lz4 compression" -ForegroundColor Green

Write-Host ""
Write-Host "[*] Optimizing LMK thresholds..." -ForegroundColor Yellow
adb shell "su -c 'echo 18432,0,23040,100,27648,125,32256,150,55296,200 > /sys/module/lowmemorykiller/parameters/minfree'" 2>$null
Write-Host "  [+] LMK thresholds optimized" -ForegroundColor Green

Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "  Memory tweaks applied!" -ForegroundColor Green
Write-Host "  Reboot recommended: adb reboot" -ForegroundColor Gray
Write-Host "============================================" -ForegroundColor Cyan
