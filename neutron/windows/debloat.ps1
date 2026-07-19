<#
.SYNOPSIS
    Neutron - Debloat MIUI 14 on Xiaomi Redmi 10 2022
.DESCRIPTION
    Removes MIUI bloatware and disables telemetry services.
    Device must be rooted with Magisk/KernelSU.
.USAGE
    .\debloat.ps1
    .\debloat.ps1 -ListPackages
    .\debloat.ps1 -Restore
#>

param(
    [switch]$ListPackages,
    [switch]$Restore
)

$ErrorActionPreference = "Stop"
$ADB = "adb"

$BloatPackages = @(
    "com.miui.player"
    "com.miui.video"
    "com.miui.gallery"
    "com.miui.calculator"
    "com.miui.compass"
    "com.miui.fm"
    "com.miui.screenrecorder"
    "com.miui.weather2"
    "com.miui.notes"
    "com.miui.mishare.connectivity"
    "com.xiaomi.misettings"
    "com.miui.daemon"
    "com.miui.hybrid"
    "com.miui.personalassistant"
    "com.milink.service"
    "com.xiaomi.finddevice"
    "com.miui.miwallpaper"
    "com.miui.guardprovider"
    "com.miui.securityadd"
    "com.google.android.youtube"
    "com.google.android.music"
    "com.google.android.videos"
)

$TelemetryServices = @(
    "miui.daemon"
    "miui.analytics"
    "misight"
)

function Write-Header {
    Write-Host ""
    Write-Host "============================================" -ForegroundColor Cyan
    Write-Host "  Neutron v1.0.0 - MIUI Debloat" -ForegroundColor Cyan
    Write-Host "  Device: Xiaomi Redmi 10 2022 (selene)" -ForegroundColor Cyan
    Write-Host "============================================" -ForegroundColor Cyan
    Write-Host ""
}

function Test-ADB {
    try {
        $ver = & $ADB version 2>$null
        return $ver -match "Android Debug Bridge"
    } catch {
        return $false
    }
}

function Get-DeviceInfo {
    & $ADB wait-for-device
    $serial = (& $ADB shell getprop ro.serialno 2>$null).Trim()
    $model = (& $ADB shell getprop ro.product.model 2>$null).Trim()
    $android = (& $ADB shell getprop ro.build.version.release 2>$null).Trim()
    $miui = (& $ADB shell getprop ro.miui.ui.version.name 2>$null).Trim()
    
    Write-Host "[+] Device: $model ($serial)" -ForegroundColor Green
    Write-Host "[+] Android: $android | MIUI: $miui" -ForegroundColor Green
    Write-Host ""
}

function Test-Root {
    $result = & $ADB shell "su -c 'id'" 2>$null
    if ($result -match "uid=0") {
        Write-Host "[+] Root access confirmed" -ForegroundColor Green
        return $true
    }
    Write-Host "[!] Root required. Please root with Magisk or KernelSU." -ForegroundColor Red
    return $false
}

function Invoke-SU {
    param([string]$Command)
    return (& $ADB shell "su -c '$Command'" 2>$null)
}

function Remove-Bloat {
    Write-Host "[*] Removing bloatware packages..." -ForegroundColor Yellow
    Write-Host ""
    
    $removed = 0
    $skipped = 0
    
    foreach ($pkg in $BloatPackages) {
        $result = Invoke-SU "pm uninstall -k --user 0 $pkg"
        if ($result -match "Success") {
            Write-Host "  [+] $pkg" -ForegroundColor Green
            $removed++
        } else {
            Write-Host "  [-] $pkg (not installed)" -ForegroundColor DarkGray
            $skipped++
        }
    }
    
    Write-Host ""
    Write-Host "[+] Removed: $removed | Skipped: $skipped" -ForegroundColor Cyan
}

function Disable-Telemetry {
    Write-Host "[*] Disabling telemetry services..." -ForegroundColor Yellow
    Write-Host ""
    
    foreach ($svc in $TelemetryServices) {
        $result = Invoke-SU "pm disable $svc"
        if ($result -match "disabled") {
            Write-Host "  [+] $svc" -ForegroundColor Green
        } else {
            Write-Host "  [-] $svc (not found)" -ForegroundColor DarkGray
        }
    }
    Write-Host ""
}

function Show-BloatList {
    Write-Host "[*] Bloatware packages to remove:" -ForegroundColor Yellow
    Write-Host ""
    foreach ($pkg in $BloatPackages) {
        $installed = & $ADB shell "pm list packages | grep $pkg" 2>$null
        if ($installed) {
            Write-Host "  [INSTALLED] $pkg" -ForegroundColor Red
        } else {
            Write-Host "  [NOT FOUND] $pkg" -ForegroundColor DarkGray
        }
    }
    Write-Host ""
    Write-Host "[*] Telemetry services to disable:" -ForegroundColor Yellow
    foreach ($svc in $TelemetryServices) {
        $installed = & $ADB shell "pm list packages | grep $svc" 2>$null
        if ($installed) {
            Write-Host "  [INSTALLED] $svc" -ForegroundColor Red
        } else {
            Write-Host "  [NOT FOUND] $svc" -ForegroundColor DarkGray
        }
    }
}

function Restore-Packages {
    Write-Host "[*] Restoring bloatware packages..." -ForegroundColor Yellow
    Write-Host ""
    
    foreach ($pkg in $BloatPackages) {
        $result = Invoke-SU "cmd package install-existing $pkg"
        Write-Host "  [~] $pkg" -ForegroundColor Cyan
    }
    
    foreach ($svc in $TelemetryServices) {
        $result = Invoke-SU "pm enable $svc"
        Write-Host "  [~] $svc" -ForegroundColor Cyan
    }
    
    Write-Host ""
    Write-Host "[+] Packages restored!" -ForegroundColor Green
}

# Main
Write-Header

if (-not (Test-ADB)) {
    Write-Host "[!] ADB not found. Install Android platform-tools." -ForegroundColor Red
    exit 1
}

Get-DeviceInfo

if (-not (Test-Root)) {
    exit 1
}

if ($ListPackages) {
    Show-BloatList
    exit 0
}

if ($Restore) {
    Restore-Packages
    exit 0
}

Remove-Bloat
Disable-Telemetry

Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "  Debloat complete!" -ForegroundColor Green
Write-Host "  Reboot recommended: adb reboot" -ForegroundColor Gray
Write-Host "============================================" -ForegroundColor Cyan
