#!/bin/bash
# Neutron - Performance tweaks for Xiaomi Redmi 10 2022

set -e

ADB="adb"

echo "============================================"
echo "  Neutron v1.0.0 - Performance Tweaks"
echo "  Device: Xiaomi Redmi 10 2022 (selene)"
echo "============================================"
echo ""

# Check root
ROOT_CHECK=$($ADB shell "su -c 'id'" 2>/dev/null | tr -d '\r')
if [[ "$ROOT_CHECK" != *"uid=0"* ]]; then
    echo "[!] Root required."
    exit 1
fi

# Remount
echo "[*] Remounting vendor partition..."
$ADB shell "su -c 'mount -o remount,rw /vendor'" 2>/dev/null

echo "[*] Applying performance tweaks..."
echo ""

declare -A PROPS=(
    ["ro.vendor.qti.cgroup_follow.enable"]="1"
    ["persist.sys.NEON"]="true"
    ["ro.iorwapd.enable"]="false"
    ["debug.sf.latch_unsignaled"]="1"
    ["debug.renderengine.backend"]="skiagl"
    ["debug.hwui.renderer"]="skiagl"
    ["windows.animation.scale"]="0.5"
    ["transition.animation.scale"]="0.5"
    ["animator.duration.scale"]="0.5"
)

for KEY in "${!PROPS[@]}"; do
    VAL="${PROPS[$KEY]}"
    $ADB shell "su -c 'sed -i /^$KEY/d /vendor/build.prop'" 2>/dev/null
    $ADB shell "su -c 'echo $KEY=$VAL >> /vendor/build.prop'" 2>/dev/null
    echo "  [+] $KEY=$VAL"
done

echo ""
echo "[*] Setting CPU governor to performance..."
for CPU in /sys/devices/system/cpu/cpu{0,4}/cpufreq/scaling_governor; do
    echo performance | $ADB shell "su -c 'tee $CPU'" 2>/dev/null
done
echo "  [+] CPU governor: performance"

echo ""
echo "[*] Optimizing I/O scheduler..."
echo bfq | $ADB shell "su -c 'tee /sys/block/sda/queue/scheduler'" 2>/dev/null
echo 256 | $ADB shell "su -c 'tee /sys/block/sda/queue/nr_requests'" 2>/dev/null
echo "  [+] I/O scheduler: bfq"

echo ""
echo "============================================"
echo "  Performance tweaks applied!"
echo "  Reboot recommended: adb reboot"
echo "============================================"