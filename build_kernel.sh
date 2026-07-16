#!/bin/bash
#
# Build Halium kernel for Samsung J7 Neo (j7velte)
#

set -e

DEVICE="j7velte"
KERNEL_REPO="https://github.com/halium-exynos/android_kernel_samsung_exynos7870.git"
KERNEL_BRANCH="halium-9.0"
JOBS=$(nproc --all)

echo "=== Halium Kernel Builder for J7 Neo ==="
echo "Device: $DEVICE"
echo "Kernel: $KERNEL_BRANCH"
echo "Threads: $JOBS"
echo ""

# Check for cross-compiler
if command -v aarch64-linux-gnu-gcc &>/dev/null; then
    export CROSS_COMPILE=aarch64-linux-gnu-
    export CROSS_COMPILE_ARM32=arm-linux-gnueabi-
    echo "Using system cross-compiler: aarch64-linux-gnu-gcc"
else
    echo "ERROR: aarch64-linux-gnu-gcc not found."
    echo "Install with: sudo apt-get install gcc-aarch64-linux-gnu binutils-aarch64-linux-gnu gcc-arm-linux-gnueabi binutils-arm-linux-gnueabi"
    exit 1
fi

# Clone kernel if not present
if [ ! -d "kernel" ]; then
    echo "=== Cloning kernel source ==="
    git clone --depth=1 -b $KERNEL_BRANCH $KERNEL_REPO kernel
else
    echo "=== Using existing kernel source ==="
fi

cd kernel

# Build
echo "=== Building kernel ==="
export ARCH=arm64
export SUBARCH=arm64

make ${DEVICE}_defconfig
make -j$JOBS

# Output
mkdir -p ../out
if [ -f arch/arm64/boot/Image.gz-dtb ]; then
    cp arch/arm64/boot/Image.gz-dtb ../out/
    echo "Output: Image.gz-dtb"
elif [ -f arch/arm64/boot/Image.gz ]; then
    cp arch/arm64/boot/Image.gz ../out/
    echo "Output: Image.gz"
else
    cp arch/arm64/boot/Image ../out/
    echo "Output: Image"
fi

cd ..
echo ""
echo "=== Build complete ==="
ls -la out/
echo "Flash with: fastboot flash boot out/Image.gz-dtb"
