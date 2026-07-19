#!/bin/bash
# Neutron - Battery tweaks for Xiaomi Redmi 10 2022

set -e

ADB="adb"

echo "============================================"
echo "  Neutron v1.0.0 - Battery Tweaks"
echo "============================================"
echo ""

ROOT_CHECK=$($ADB shell "su -c 'id'" 2>/dev/null | tr -d '\r')
if [[ "$ROOT_CHECK" != *"uid=0"* ]]; then
    echo "[!] Root required."
    exit 1
fi

$ADB shell "su -c 'mount -o remount,rw /vendor'" 2>/dev/null

echo "[*] Applying battery tweaks..."
echo ""

declare -A PROPS=(
    ["powersave.enabled"]="1"
    ["ro.config.alarm_alert"]="vibra.ogg"
    ["ro.ril.power_collapse"]="1"
    ["persist.radio.apm_sim_not_pwdn"]="1"
    ["deviceidle.disabled"]="false"
    ["ro.vendor.qti.cgroup_follow.enable"]="1"
)

for KEY in "${!PROPS[@]}"; do
    VAL="${PROPS[$KEY]}"
    $ADB shell "su -c 'sed -i /^$KEY/d /vendor/build.prop'" 2>/dev/null
    $ADB shell "su -c 'echo $KEY=$VAL >> /vendor/build.prop'" 2>/dev/null
    echo "  [+] $KEY=$VAL"
done

echo ""
echo "[*] Configuring Doze mode..."
$ADB shell "su -c 'settings put global adaptive_battery_saving_enabled 1'" 2>/dev/null
echo "  [+] Adaptive battery enabled"

echo ""
echo "[*] Reducing wake locks..."
$ADB shell "su -c 'settings put global sem_power_profile 2'" 2>/dev/null
echo "  [+] Power profile optimized"

echo ""
echo "============================================"
echo "  Battery tweaks applied!"
echo "  Reboot recommended: adb reboot"
echo "============================================"