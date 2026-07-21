#!/bin/bash
set -e

# Build systemimage for selene on Crave infrastructure
# This script runs inside the Crave self-hosted runner

TESTING_ADROD_DIR="${TESTING_ADROD_DIR:-$(pwd)}"
PROJECTFOLDER="${PROJECTFOLDER:-/crave-devspaces/Lineage18}"
PROJECTID="${PROJECTID:-85}"
DEVICE="${DEVICE:-selene}"
VENDOR="${VENDOR:-xiaomi}"
LUNCH_COMBO="${LUNCH_COMBO:-halium_selene-userdebug}"
HALIUM_VERSION="${HALIUM_VERSION:-halium-11.0}"

export USE_CCACHE=1
export CCACHE_DIR=~/.ccache
export USE_HOST_LEX=yes

cd "$TESTING_ADROD_DIR"

# Configure crave if not already in devspace
if [[ "${DCDEVSPACE}" != "1" ]]; then
  echo "Setting up crave CLI..."
  curl -s https://raw.githubusercontent.com/accupara/crave/master/get_crave.sh | bash -s --
  mv "${PWD}/crave" "${HOME}/bin/"
  sudo ln -sf "/home/${USER}/bin/crave" /usr/bin/crave
  envsubst < crave.conf.sample >> crave.conf
fi

# Create or reuse Crave clone of base project
if grep -q "$PROJECTFOLDER" <(crave clone list --json | jq -r '.clones[]."Cloned At"' 2>/dev/null || true); then
  echo "Using existing Crave clone at $PROJECTFOLDER"
else
  echo "Creating Crave clone for project $PROJECTID..."
  crave clone create --projectID "$PROJECTID" "$PROJECTFOLDER"
fi

cd "$PROJECTFOLDER"

# Initialize Halium source tree if not already present
if [ ! -d .repo ]; then
  echo "Initializing Halium $HALIUM_VERSION..."
  repo init -u https://github.com/Halium/android -b "$HALIUM_VERSION" --depth=1
fi

# Sync sources
if [ -f /opt/crave/resync.sh ]; then
  /opt/crave/resync.sh
else
  repo sync -c -j$(nproc --all) --no-tags --force-sync
fi

# Place device tree
mkdir -p "device/$VENDOR/$DEVICE"
cp -r "$TESTING_ADROD_DIR/dts/"* "device/$VENDOR/$DEVICE/"

# Place vendor files
mkdir -p "vendor/$VENDOR/$DEVICE"
cp "$TESTING_ADROD_DIR/vendor/$VENDOR/$DEVICE/proprietary-files.txt" "vendor/$VENDOR/$DEVICE/" 2>/dev/null || true
cp "$TESTING_ADROD_DIR/vendor/$VENDOR/$DEVICE/selene-vendor.mk" "vendor/$VENDOR/$DEVICE/" 2>/dev/null || true
cp "$TESTING_ADROD_DIR/vendor/$VENDOR/$DEVICE/BoardConfigVendor.mk" "vendor/$VENDOR/$DEVICE/" 2>/dev/null || true

# Extract vendor blobs
DEST="vendor/$VENDOR/$DEVICE/proprietary"
mkdir -p "$DEST"

gh release download vendor-blobs-selene --pattern "vendor_a.img" --dir /tmp/ 2>&1
sudo mkdir -p /tmp/vendor_mnt
sudo mount -o ro,loop /tmp/vendor_a.img /tmp/vendor_mnt

while IFS= read -r line; do
  [[ -z "$line" || "$line" =~ ^# || "$line" =~ ^- ]] && continue
  src_path="${line%%|*}"
  [[ "$src_path" == *"/vintf/"* || "$src_path" == *".apk" || "$src_path" == *".jar" ]] && continue
  src_full="/tmp/vendor_mnt/$src_path"
  dst_full="$DEST/$src_path"
  if [ -f "$src_full" ]; then
    mkdir -p "$(dirname "$dst_full")"
    cp "$src_full" "$dst_full"
  fi
done < "vendor/$VENDOR/$DEVICE/proprietary-files.txt"

sudo umount /tmp/vendor_mnt
rm -f /tmp/vendor_a.img
sudo chown -R "$(id -u):$(id -g)" "$DEST/"
sudo chmod -R u+rwx "$DEST/"
rm -rf "$DEST/lost+found"

# Patch vendor blobs
bash "$TESTING_ADROD_DIR/scripts/patch-vendor-blobs.sh" "$DEST"

# Install VINTF manifest
mkdir -p "$DEST/etc/vintf/manifest"
cp "$TESTING_ADROD_DIR/dts/manifest.xml" "$DEST/etc/vintf/manifest/manifest_${DEVICE}.xml"

# Filter proprietary-files.txt
PROP="vendor/$VENDOR/$DEVICE/proprietary-files.txt"
FILTERED=$(mktemp)
while IFS= read -r line; do
  [[ -z "$line" || "$line" == \#* ]] && echo "$line" >> "$FILTERED" && continue
  [[ "$line" == -* ]] && echo "$line" >> "$FILTERED" && continue
  src="${line%%|*}"
  if [ -f "$DEST/$src" ]; then
    echo "$line" >> "$FILTERED"
  fi
done < "$PROP"
cp "$FILTERED" "$PROP"
rm "$FILTERED"

# Generate vendor makefile
python3 "$TESTING_ADROD_DIR/scripts/generate_vendor_mk.py" \
  "vendor/$VENDOR/$DEVICE/proprietary-files.txt" \
  "vendor/$VENDOR/$DEVICE/selene-vendor-files.mk"

# Download prebuilt kernel
for i in 1 2 3 4 5; do
  TAG=$(gh release list --limit=50 --json tagName,name -q '.[] | select(.tagName | test("successful\\.semirelease\\.selene")) | .tagName' 2>/dev/null | head -1)
  if [ -n "$TAG" ]; then
    echo "Found kernel release: $TAG"
    break
  fi
  echo "Attempt $i: No kernel release found, waiting 30s..."
  sleep 30
done
if [ -z "$TAG" ]; then
  echo "ERROR: No kernel release found"
  exit 1
fi
mkdir -p "device/$VENDOR/$DEVICE/prebuilt"
gh release download "$TAG" --pattern "Image.gz-dtb" --dir "device/$VENDOR/$DEVICE/prebuilt/"

# Clone MTK sepolicy
git clone --depth=1 -b eleven \
  https://github.com/PixelExperience/device_mediatek_sepolicy_vndr.git \
  device/mediatek/sepolicy_vndr 2>/dev/null || true

# Apply Hybris patches
./hybris-patches/apply-patches.sh --mb

# Patch import-namespace
python3 << 'PYEOF'
import re
try:
    with open('build/core/node_fns.mk', 'r') as f:
        content = f.read()
    content = re.sub(r'\$\(error import of "\$\(2\)" failed\)', '', content)
    with open('build/core/node_fns.mk', 'w') as f:
        f.write(content)
except FileNotFoundError:
    pass
PYEOF

# Fix Soong Make variables
if [ -f "vendor/lineage/build/soong/Android.bp" ]; then
  python3 << 'PYEOF'
import re
with open('vendor/lineage/build/soong/Android.bp') as f:
    c = f.read()
c2 = re.sub(r'\$\([A-Z_]+\)', '', c)
with open('vendor/lineage/build/soong/Android.bp', 'w') as f:
    f.write(c2)
PYEOF
fi

# Remove broken test files
rm -f platform_testing/build/tasks/tests/instrumentation_test_list.mk
rm -f platform_testing/build/tasks/continuous_instrumentation_tests.mk
rm -f platform_testing/build/tasks/continuous_native_tests.mk

# Patch bootloader_message
HEADER="bootable/recovery/bootloader_message/include/bootloader_message/bootloader_message.h"
python3 -c "
with open('$HEADER', 'r') as f:
    content = f.read()
if 'BOARD_RECOVERY_BLDRMSG_OFFSET' in content and '#define BOARD_RECOVERY_BLDRMSG_OFFSET' not in content:
    content = '#ifndef BOARD_RECOVERY_BLDRMSG_OFFSET\n#define BOARD_RECOVERY_BLDRMSG_OFFSET 0x00000000\n#endif\n\n' + content
    with open('$HEADER', 'w') as f:
        f.write(content)
"

# Build systemimage
source build/envsetup.sh
lunch "$LUNCH_COMBO"
mka systemimage -j$(nproc --all)

# Copy system image to output
mkdir -p "$TESTING_ADROD_DIR/out"
cp "out/target/product/$DEVICE/system.img" "$TESTING_ADROD_DIR/out/"
ls -la "$TESTING_ADROD_DIR/out/"
