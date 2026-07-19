#!/bin/bash
# Neutron blob patching script
# Patches vendor binaries with shim libraries and fixes
# Based on selene-devs extract-files.sh

set -e

VENDOR_DIR="$1"

if [ -z "$VENDOR_DIR" ] || [ ! -d "$VENDOR_DIR" ]; then
    echo "Usage: $0 <vendor_dir>"
    echo "  vendor_dir: path to extracted vendor partition"
    exit 1
fi

echo "=== Neutron Blob Patcher ==="
echo "Patching vendor blobs in: $VENDOR_DIR"
echo ""

# Helper: add-needed to ELF binary
add_needed() {
    local binary="$1"
    local lib="$2"
    if [ -f "$binary" ]; then
        if command -v patchelf &>/dev/null; then
            patchelf --add-needed "$lib" "$binary" 2>/dev/null && echo "  [+] add-needed $lib → $(basename $binary)" || echo "  [-] Failed: $(basename $binary)"
        else
            # Fallback: try to patch with sed (less reliable)
            echo "  [!] patchelf not available, skipping $(basename $binary)"
        fi
    fi
}

# Helper: replace-needed in ELF binary
replace_needed() {
    local binary="$1"
    local old="$2"
    local new="$3"
    if [ -f "$binary" ]; then
        if command -v patchelf &>/dev/null; then
            patchelf --replace-needed "$old" "$new" "$binary" 2>/dev/null && echo "  [+] replace-needed $old→$new → $(basename $binary)" || echo "  [-] Failed: $(basename $binary)"
        fi
    fi
}

# Helper: set soname
set_soname() {
    local binary="$1"
    local name="$2"
    if [ -f "$binary" ]; then
        if command -v patchelf &>/dev/null; then
            patchelf --set-soname "$name" "$binary" 2>/dev/null && echo "  [+] set-soname $name → $(basename $binary)" || echo "  [-] Failed: $(basename $binary)"
        fi
    fi
}

echo "[1/4] Adding shim libraries..."
add_needed "$VENDOR_DIR/lib/libsink.so" "libshim_vtservice.so"
add_needed "$VENDOR_DIR/vendor/lib/hw/audio.primary.mt6768.so" "libshim_audio.so"
add_needed "$VENDOR_DIR/vendor/lib64/hw/audio.primary.mt6768.so" "libshim_audio.so"
add_needed "$VENDOR_DIR/vendor/bin/hw/android.hardware.keymaster@4.0-service.beanpod" "libshim_beanpod.so"
add_needed "$VENDOR_DIR/lib/libshowlogo.so" "libshim_showlogo.so"

echo ""
echo "[2/4] Fixing sonames..."
set_soname "$VENDOR_DIR/vendor/lib64/libwifi-hal-mtk.so" "libwifi-hal-mtk.so"

echo ""
echo "[3/4] Replacing VNDK libraries..."
replace_needed "$VENDOR_DIR/vendor/bin/hw/android.hardware.thermal@2.0-service.mtk" "libutils.so" "libutils-v32.so"
replace_needed "$VENDOR_DIR/vendor/lib*/hw/dfps.mt6768.so" "libutils.so" "libutils-v32.so"
replace_needed "$VENDOR_DIR/vendor/lib*/hw/vendor.mediatek.hardware.pq@2.6-impl.so" "libutils.so" "libutils-v32.so"
replace_needed "$VENDOR_DIR/vendor/lib64/libmtkcam_stdutils.so" "libutils.so" "libutils-v32.so"
replace_needed "$VENDOR_DIR/vendor/lib/libMtkOmxVdecEx.so" "libui.so" "libui-v32.so"

echo ""
echo "[4/4] Binary hex patches..."
# Patch libmtkcam_featurepolicy.so - fix evaluateCaptureConfiguration()
TARGET="$VENDOR_DIR/vendor/lib64/libmtkcam_featurepolicy.so"
if [ -f "$TARGET" ]; then
    python3 -c "
import sys
data = open(sys.argv[1], 'rb').read()
old = bytes.fromhex('90b0034e8874039')
new = bytes.fromhex('90b003428028052')
idx = data.find(old)
if idx >= 0:
    data = data[:idx] + new + data[idx+len(old):]
    open(sys.argv[1], 'wb').write(data)
    print(f'  [+] Patched libmtkcam_featurepolicy.so at offset {idx}')
else:
    print('  [-] Pattern not found in libmtkcam_featurepolicy.so')
" "$TARGET" 2>/dev/null || echo "  [-] Hex patch failed"
fi

echo ""
echo "=== Patching complete ==="
