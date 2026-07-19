<#
.SYNOPSIS
    Neutron - Backup vendor partition
.DESCRIPTION
    Creates a backup of the vendor partition before applying tweaks.
#>

$ErrorActionPreference = "Stop"

Write-Host "============================================" -ForegroundColor Cyan
Write-Host "  Neutron v1.0.0 - Backup Vendor" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

# Check device
$serial = (adb shell getprop ro.serialno 2>$null).Trim()
if (-not $serial) {
    Write-Host "[!] No device connected." -ForegroundColor Red
    exit 1
}
Write-Host "[+] Device: $serial" -ForegroundColor Green

# Check root
$rootCheck = adb shell "su -c 'id'" 2>$null
if ($rootCheck -notmatch "uid=0") {
    Write-Host "[!] Root required." -ForegroundColor Red
    exit 1
}

# Create backup directory
$backupDir = Join-Path (Split-Path $PSScriptRoot) "backups"
if (-not (Test-Path $backupDir)) {
    New-Item -ItemType Directory -Path $backupDir | Out-Null
}

$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$backupFile = Join-Path $backupDir "vendor_backup_$timestamp.img"

Write-Host "[*] Backing up vendor partition..." -ForegroundColor Yellow
Write-Host "    This may take a few minutes..." -ForegroundColor Gray

# Get vendor block device
$vendorBlock = adb shell "ls /dev/block/by-name/vendor 2>/dev/null || ls /dev/block/platform/bootdevice/by-name/vendor 2>/dev/null"
$vendorBlock = $vendorBlock.Trim()
Write-Host "    Source: $vendorBlock" -ForegroundColor Gray

# Get partition size
$sizeBytes = adb shell "blockdev --getsize64 $vendorBlock" 2>$null
$sizeMB = [math]::Round([long]$sizeBytes / 1MB)
Write-Host "    Size: ${sizeMB}MB" -ForegroundColor Gray

# Dump partition
adb shell "su -c 'dd if=$vendorBlock of=/sdcard/vendor_backup.img'" 2>$null

# Pull to PC
Write-Host "[*] Pulling backup to PC..." -ForegroundColor Yellow
adb pull /sdcard/vendor_backup.img $backupFile

# Cleanup device
adb shell "su -c 'rm /sdcard/vendor_backup.img'" 2>$null

# Verify
if (Test-Path $backupFile) {
    $fileSize = (Get-Item $backupFile).Length
    $fileSizeMB = [math]::Round($fileSize / 1MB)
    Write-Host ""
    Write-Host "[+] Backup complete!" -ForegroundColor Green
    Write-Host "    File: $backupFile" -ForegroundColor Gray
    Write-Host "    Size: ${fileSizeMB}MB" -ForegroundColor Gray
} else {
    Write-Host "[!] Backup failed!" -ForegroundColor Red
    exit 1
}
