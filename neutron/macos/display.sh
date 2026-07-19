#!/bin/bash
# Neutron - Display tweaks for Xiaomi Redmi 10 2022 (90Hz panel)

set -e

ADB="adb"

echo "============================================"
echo "  Neutron v1.0.0 - Display Tweaks"
echo "============================================"
echo ""

ROOT_CHECK=$($ADB shell "su -c 'id'" 2>/dev/null | tr -d '\r')
if [[ "$ROOT_CHECK" != *"uid=0"* ]]; then
    echo "[!] Root required."
    exit 1
fi

$ADB shell "su -c 'mount -o remount,rw /vendor'" 2>/dev/null

echo "[*] Applying display tweaks..."
echo ""

declare -A PROPS=(
    ["ro.surface_flinger.max_frame_buffer_acquired_buffers"]="3"
    ["debug.sf.fps"]="90"
    ["debug.sf.latch_unsignaled"]="1"
    ["debug.renderengine.backend"]="skiagl"
    ["ro.surface_flinger.running_without_sync_framework"]="true"
)

for KEY in "${!PROPS[@]}"; do
    VAL="${PROPS[$KEY]}"
    $ADB shell "su -c 'sed -i /^$KEY/d /vendor/build.prop'" 2>/dev/null
    $ADB shell "su -c 'echo $KEY=$VAL >> /vendor/build.prop'" 2>/dev/null
    echo "  [+] $KEY=$VAL"
done

echo ""
echo "[*] Forcing 90Hz refresh rate..."
$ADB shell "su -c 'settings put system peak_refresh_rate 90'" 2>/dev/null
$ADB shell "su -c 'settings put system min_refresh_rate 60'" 2>/dev/null
$ADB shell "su -c 'settings put global display_mode_forced 90'" 2>/dev/null
echo "  [+] Refresh rate: 90Hz"

echo ""
echo "============================================"
echo "  Display tweaks applied!"
echo "  Reboot recommended: adb reboot"
echo "============================================"