#!/bin/bash
# Neutron - Restore vendor backup

set -e

ADB="adb"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_FILE="$SCRIPT_DIR/../backups/vendor_backup.img"

echo "============================================"
echo "  Neutron v1.0.0 - Restore Vendor"
echo "============================================"
echo ""

if [ ! -f "$BACKUP_FILE" ]; then
    echo "[!] No backup found at: $BACKUP_FILE"
    echo ""
    echo "  To restore manually:"
    echo "  1. Use SP Flash Tool with your stock firmware"
    echo "  2. Flash only the vendor partition"
    exit 1
fi

ROOT_CHECK=$($ADB shell "su -c 'id'" 2>/dev/null | tr -d '\r')
if [[ "$ROOT_CHECK" != *"uid=0"* ]]; then
    echo "[!] Root required."
    exit 1
fi

echo "[*] Pushing backup to device..."
$ADB push "$BACKUP_FILE" /sdcard/vendor_backup.img

echo "[*] Flashing vendor partition..."
VENDOR_BLOCK=$($ADB shell "ls /dev/block/by-name/vendor 2>/dev/null || ls /dev/block/platform/bootdevice/by-name/vendor 2>/dev/null" | tr -d '\r')
echo "  Target: $VENDOR_BLOCK"

$ADB shell "su -c 'dd if=/sdcard/vendor_backup.img of=$VENDOR_BLOCK'"
$ADB shell "su -c 'rm /sdcard/vendor_backup.img'"

echo ""
echo "============================================"
echo "  Vendor restored!"
echo "  Reboot recommended: adb reboot"
echo "============================================"