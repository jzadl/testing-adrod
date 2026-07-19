#!/bin/bash
# Neutron - Debloat MIUI 14 on Xiaomi Redmi 10 2022
# Removes MIUI bloatware and disables telemetry services.

set -e

ADB="adb"

BLOAT_PACKAGES=(
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

TELEMETRY_SERVICES=(
    "miui.daemon"
    "miui.analytics"
    "misight"
)

echo "============================================"
echo "  Neutron v1.0.0 - MIUI Debloat"
echo "  Device: Xiaomi Redmi 10 2022 (selene)"
echo "============================================"
echo ""

# Check ADB
if ! command -v $ADB &> /dev/null; then
    echo "[!] ADB not found. Install Android platform-tools."
    exit 1
fi

# Check device
echo "[*] Checking for device..."
$ADB wait-for-device
SERIAL=$($ADB shell getprop ro.serialno 2>/dev/null | tr -d '\r')
MODEL=$($ADB shell getprop ro.product.model 2>/dev/null | tr -d '\r')
echo "[+] Device: $MODEL ($SERIAL)"

# Check root
ROOT_CHECK=$($ADB shell "su -c 'id'" 2>/dev/null | tr -d '\r')
if [[ "$ROOT_CHECK" != *"uid=0"* ]]; then
    echo "[!] Root required. Please root with Magisk or KernelSU."
    exit 1
fi
echo "[+] Root access confirmed"

echo ""
echo "[*] Removing bloatware packages..."
echo ""

REMOVED=0
SKIPPED=0

for PKG in "${BLOAT_PACKAGES[@]}"; do
    RESULT=$($ADB shell "su -c 'pm uninstall -k --user 0 $PKG'" 2>/dev/null | tr -d '\r')
    if [[ "$RESULT" == *"Success"* ]]; then
        echo "  [+] $PKG"
        REMOVED=$((REMOVED + 1))
    else
        echo "  [-] $PKG (not installed)"
        SKIPPED=$((SKIPPED + 1))
    fi
done

echo ""
echo "[+] Removed: $REMOVED | Skipped: $SKIPPED"
echo ""

echo "[*] Disabling telemetry services..."
for SVC in "${TELEMETRY_SERVICES[@]}"; do
    $ADB shell "su -c 'pm disable $SVC'" 2>/dev/null
    echo "  [+] $SVC"
done

echo ""
echo "============================================"
echo "  Debloat complete!"
echo "  Reboot recommended: adb reboot"
echo "============================================"
