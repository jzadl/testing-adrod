#!/bin/bash
# Neutron - Apply all tweaks at once

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "============================================"
echo "  Neutron v1.0.0 - Install All Tweaks"
echo "  Device: Xiaomi Redmi 10 2022 (selene)"
echo "============================================"
echo ""

# Check root
ROOT_CHECK=$(adb shell "su -c 'id'" 2>/dev/null | tr -d '\r')
if [[ "$ROOT_CHECK" != *"uid=0"* ]]; then
    echo "[!] Root required."
    exit 1
fi

# Remount
adb shell "su -c 'mount -o remount,rw /vendor'" 2>/dev/null

echo "[*] === DEBLOAT ==="
bash "$SCRIPT_DIR/debloat.sh"
echo ""

echo "[*] === PERFORMANCE ==="
bash "$SCRIPT_DIR/perf.sh"
echo ""

echo "[*] === BATTERY ==="
bash "$SCRIPT_DIR/battery.sh"
echo ""

echo "[*] === DISPLAY ==="
bash "$SCRIPT_DIR/display.sh"
echo ""

echo "[*] === MEMORY ==="
bash "$SCRIPT_DIR/memory.sh"
echo ""

echo "============================================"
echo "  ALL TWEAKS APPLIED!"
echo "  Reboot recommended: adb reboot"
echo "============================================"
