#!/bin/bash
# Neutron - Memory/ZRAM tweaks for Xiaomi Redmi 10 2022

set -e

ADB="adb"

echo "============================================"
echo "  Neutron v1.0.0 - Memory Tweaks"
echo "============================================"
echo ""

ROOT_CHECK=$($ADB shell "su -c 'id'" 2>/dev/null | tr -d '\r')
if [[ "$ROOT_CHECK" != *"uid=0"* ]]; then
    echo "[!] Root required."
    exit 1
fi

$ADB shell "su -c 'mount -o remount,rw /vendor'" 2>/dev/null

echo "[*] Applying memory tweaks..."
echo ""

declare -A PROPS=(
    ["ro.config.zram"]="true"
    ["ro.lmk.critical_upgrade"]="true"
    ["ro.lmk.upgrade_pressure"]="100"
    ["ro.lmk.downgrade_pressure"]="100"
)

for KEY in "${!PROPS[@]}"; do
    VAL="${PROPS[$KEY]}"
    $ADB shell "su -c 'sed -i /^$KEY/d /vendor/build.prop'" 2>/dev/null
    $ADB shell "su -c 'echo $KEY=$VAL >> /vendor/build.prop'" 2>/dev/null
    echo "  [+] $KEY=$VAL"
done

echo ""
echo "[*] Configuring ZRAM..."
$ADB shell "su -c 'echo lz4 > /sys/block/zram0/comp_algorithm'" 2>/dev/null
$ADB shell "su -c 'swapoff /dev/block/zram0 2>/dev/null'" 2>/dev/null

# Get total RAM and calculate 75%
MEM_TOTAL=$($ADB shell "cat /proc/meminfo | head -1" 2>/dev/null | grep -o '[0-9]*')
ZRAM_SIZE=$((MEM_TOTAL * 75 / 100))

$ADB shell "su -c 'echo $((ZRAM_SIZE * 1024)) > /sys/block/zram0/disksize'" 2>/dev/null
$ADB shell "su -c 'mkswap /dev/block/zram0'" 2>/dev/null
$ADB shell "su -c 'swapon /dev/block/zram0'" 2>/dev/null
echo "  [+] ZRAM: ${ZRAM_SIZE}KB with lz4 compression"

echo ""
echo "[*] Optimizing LMK thresholds..."
$ADB shell "su -c 'echo 18432,0,23040,100,27648,125,32256,150,55296,200 > /sys/module/lowmemorykiller/parameters/minfree'" 2>/dev/null
echo "  [+] LMK thresholds optimized"

echo ""
echo "============================================"
echo "  Memory tweaks applied!"
echo "  Reboot recommended: adb reboot"
echo "============================================"
