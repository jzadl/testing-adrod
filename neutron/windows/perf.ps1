<#
.SYNOPSIS
    Neutron - Performance tweaks for Xiaomi Redmi 10 2022
.DESCRIPTION
    Applies CPU, GPU, rendering, and animation performance tweaks.
#>

$ErrorActionPreference = "Stop"

Write-Host "============================================" -ForegroundColor Cyan
Write-Host "  Neutron v1.0.0 - Performance Tweaks" -ForegroundColor Cyan
Write-Host "  Device: Xiaomi Redmi 10 2022 (selene)" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

# Check root
$rootCheck = adb shell "su -c 'id'" 2>$null
if ($rootCheck -notmatch "uid=0") {
    Write-Host "[!] Root required." -ForegroundColor Red
    exit 1
}

# Remount vendor
Write-Host "[*] Remounting vendor partition..." -ForegroundColor Yellow
adb shell "su -c 'mount -o remount,rw /vendor'" 2>$null

$Props = @{
    "ro.vendor.qti.cgroup_follow.enable"      = "1"
    "persist.sys.NEON"                          = "true"
    "ro.iorwapd.enable"                        = "false"
    "debug.sf.latch_unsignaled"                = "1"
    "debug.renderengine.backend"               = "skiagl"
    "debug.hwui.renderer"                      = "skiagl"
    "windows.animation.scale"                  = "0.5"
    "transition.animation.scale"               = "0.5"
    "animator.duration.scale"                  = "0.5"
}

Write-Host "[*] Applying performance tweaks to vendor/build.prop..." -ForegroundColor Yellow
Write-Host ""

foreach ($key in $Props.Keys) {
    $val = $Props[$key]
    adb shell "su -c 'sed -i /^$key/d /vendor/build.prop'" 2>$null
    adb shell "su -c 'echo $key=$val >> /vendor/build.prop'" 2>$null
    Write-Host "  [+] $key=$val" -ForegroundColor Green
}

Write-Host ""
Write-Host "[*] Setting CPU governor to performance mode..." -ForegroundColor Yellow
adb shell "su -c 'echo performance > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor'" 2>$null
adb shell "su -c 'echo performance > /sys/devices/system/cpu/cpu4/cpufreq/scaling_governor'" 2>$null
Write-Host "  [+] CPU governor: performance" -ForegroundColor Green

Write-Host ""
Write-Host "[*] Optimizing I/O scheduler..." -ForegroundColor Yellow
adb shell "su -c 'echo bfq > /sys/block/sda/queue/scheduler'" 2>$null
adb shell "su -c 'echo 256 > /sys/block/sda/queue/nr_requests'" 2>$null
Write-Host "  [+] I/O scheduler: bfq" -ForegroundColor Green

Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "  Performance tweaks applied!" -ForegroundColor Green
Write-Host "  Reboot recommended: adb reboot" -ForegroundColor Gray
Write-Host "============================================" -ForegroundColor Cyan
