<#
.SYNOPSIS
    Neutron - Restore vendor backup
.DESCRIPTION
    Restores the vendor partition from backup.
#>

$ErrorActionPreference = "Stop"

Write-Host "============================================" -ForegroundColor Cyan
Write-Host "  Neutron v1.0.0 - Restore Vendor" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

$BackupFile = Join-Path (Split-Path $PSScriptRoot) "backups\vendor_backup.img"

if (-not (Test-Path $BackupFile)) {
    Write-Host "[!] No backup found at: $BackupFile" -ForegroundColor Red
    Write-Host ""
    Write-Host "  To restore manually:" -ForegroundColor Yellow
    Write-Host "  1. Use SP Flash Tool with your stock firmware" -ForegroundColor Gray
    Write-Host "  2. Flash only the vendor partition" -ForegroundColor Gray
    Write-Host ""
    exit 1
}

$rootCheck = adb shell "su -c 'id'" 2>$null
if ($rootCheck -notmatch "uid=0") {
    Write-Host "[!] Root required." -ForegroundColor Red
    exit 1
}

Write-Host "[*] Pushing backup to device..." -ForegroundColor Yellow
adb push $BackupFile /sdcard/vendor_backup.img

Write-Host "[*] Flashing vendor partition..." -ForegroundColor Yellow
$vendorBlock = adb shell "ls /dev/block/by-name/vendor 2>/dev/null || ls /dev/block/platform/bootdevice/by-name/vendor 2>/dev/null"
$vendorBlock = $vendorBlock.Trim()
Write-Host "  Target: $vendorBlock" -ForegroundColor Gray

adb shell "su -c 'dd if=/sdcard/vendor_backup.img of=$vendorBlock'"
adb shell "su -c 'rm /sdcard/vendor_backup.img'"

Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "  Vendor restored!" -ForegroundColor Green
Write-Host "  Reboot recommended: adb reboot" -ForegroundColor Gray
Write-Host "============================================" -ForegroundColor Cyan
