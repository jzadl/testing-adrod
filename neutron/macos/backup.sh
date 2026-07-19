#!/bin/bash
# Neutron - Backup vendor partition

set -e

ADB="adb"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$SCRIPT_DIR/../backups"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="$BACKUP_DIR/vendor_backup_$TIMESTAMP.img"

echo "============================================"
echo "  Neutron v1.0.0 - Backup Vendor"
echo "============================================"
echo ""

# Check device
SERIAL=$($ADB shell getprop ro.serialno 2>/dev/null | tr -d '\r')
if [ -z "$SERIAL" ]; then
    echo "[!] No device connected."
    exit 1
fi
echo "[+] Device: $SERIAL"

# Check root
ROOT_CHECK=$($ADB shell "su -c 'id'" 2>/dev/null | tr -d '\r')
if [[ "$ROOT_CHECK" != *"uid=0"* ]]; then
    echo "[!] Root required."
    exit 1
fi

# Create backup directory
mkdir -p "$BACKUP_DIR"

# Get vendor block device
VENDOR_BLOCK=$($ADB shell "ls /dev/block/by-name/vendor 2>/dev/null || ls /dev/block/platform/bootdevice/by-name/vendor 2>/dev/null" | tr -d '\r')
echo "[*] Backing up vendor partition..."
echo "    Source: $VENDOR_BLOCK"

# Get partition size
SIZE_BYTES=$($ADB shell "blockdev --getsize64 $VENDOR_BLOCK" 2>/dev/null | tr -d '\r')
SIZE_MB=$((SIZE_BYTES / 1024 / 1024))
echo "    Size: ${SIZE_MB}MB"

# Dump partition
$ADB shell "su -c 'dd if=$VENDOR_BLOCK of=/sdcard/vendor_backup.img'"

# Pull to PC
echo "[*] Pulling backup to PC..."
$ADB pull /sdcard/vendor_backup.img "$BACKUP_FILE"

# Cleanup device
$ADB shell "su -c 'rm /sdcard/vendor_backup.img'" 2>/dev/null

# Verify
if [ -f "$BACKUP_FILE" ]; then
    FILE_SIZE=$(stat -f%z "$BACKUP_FILE" 2>/dev/null || stat --printf="%s" "$BACKUP_FILE" 2>/dev/null)
    FILE_SIZE_MB=$((FILE_SIZE / 1024 / 1024))
    echo ""
    echo "[+] Backup complete!"
    echo "    File: $BACKUP_FILE"
    echo "    Size: ${FILE_SIZE_MB}MB"
else
    echo "[!] Backup failed!"
    exit 1
fi
