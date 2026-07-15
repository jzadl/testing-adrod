#!/bin/bash
# CyanogenMod 14.1 Build Script for Samsung J7 Neo (j7velte)
# Usage: ./build.sh [clean|sync|build]

set -e

DEVICE="j7velte"
CM_VERSION="14.1"
CM_BRANCH="cm-${CM_VERSION}"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running as root
if [ "$EUID" -eq 0 ]; then
    print_error "Do not run this script as root"
    exit 1
fi

# Install dependencies
install_deps() {
    print_status "Installing dependencies..."
    sudo apt-get update
    sudo apt-get install -y \
        bc bison build-essential ccache curl flex g++-multilib gcc-multilib \
        git gnupg gperf imagemagick lib32readline-dev lib32z1-dev \
        libelf-dev liblz4-tool libncurses5 libsdl1.2-dev libssl-dev \
        libxml2 libxml2-utils lzop pngcrush rsync schedtool squashfs-tools \
        xsltproc zip zlib1g-dev openjdk-8-jdk python3
    
    # Configure ccache
    mkdir -p ~/.ccache
    echo "max_size = 10G" > ~/.ccache/ccache.conf
    echo "compiler_check = content" >> ~/.ccache/ccache.conf
    
    # Install repo
    mkdir -p ~/bin
    curl https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
    chmod a+x ~/bin/repo
    export PATH=~/bin:$PATH
    
    print_status "Dependencies installed"
}

# Initialize repo
init_repo() {
    print_status "Initializing CyanogenMod manifest..."
    mkdir -p android/cm
    cd android/cm
    
    repo init -u https://github.com/CyanogenMod/android.git \
        -b ${CM_BRANCH} \
        --depth=1
    
    # Add device manifests
    mkdir -p .repo/local_manifests
    cat > .repo/local_manifests/j7velte.xml << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<manifest>
  <project name="samsungexynos7870/android_kernel_samsung_exynos7870"
           path="kernel/samsung/exynos7870"
           remote="github"
           revision="master" />
  <project name="samsungexynos7870/android_device_samsung_j7velte"
           path="device/samsung/j7velte"
           remote="github"
           revision="aex" />
  <project name="samsungexynos7870/android_device_samsung_exynos7870-common"
           path="device/samsung/exynos7870-common"
           remote="github"
           revision="aex" />
  <project name="samsungexynos7870/proprietary_vendor_samsung"
           path="vendor/samsung"
           remote="github"
           revision="aex" />
</manifest>
EOF
    
    print_status "Manifest initialized"
}

# Sync source
sync_source() {
    print_status "Syncing source code..."
    cd android/cm
    
    repo sync -c -j$(nproc --all) \
        --force-sync \
        --no-clone-bundle \
        --no-tags \
        --optimized-fetch \
        --prune \
        --force-remove-dirty
    
    print_status "Source synced"
}

# Build
build_rom() {
    print_status "Building CyanogenMod ${CM_VERSION} for ${DEVICE}..."
    cd android/cm
    
    source build/envsetup.sh
    lunch cm_${DEVICE}-userdebug
    
    mka bacon -j$(nproc --all) 2>&1 | tee build.log
    
    if [ $? -eq 0 ]; then
        print_status "Build successful!"
        print_status "Output: out/target/product/${DEVICE}/"
        ls -la out/target/product/${DEVICE}/*.zip 2>/dev/null || true
    else
        print_error "Build failed. Check build.log for details"
        exit 1
    fi
}

# Clean
clean_build() {
    print_status "Cleaning build environment..."
    cd android/cm
    
    make clean
    make clobber
    
    print_status "Clean completed"
}

# Main
case "${1:-build}" in
    deps)
        install_deps
        ;;
    init)
        init_repo
        ;;
    sync)
        sync_source
        ;;
    build)
        build_rom
        ;;
    clean)
        clean_build
        ;;
    all)
        install_deps
        init_repo
        sync_source
        build_rom
        ;;
    *)
        echo "Usage: $0 [deps|init|sync|build|clean|all]"
        echo ""
        echo "Commands:"
        echo "  deps   - Install dependencies"
        echo "  init   - Initialize repo manifest"
        echo "  sync   - Sync source code"
        echo "  build  - Build ROM"
        echo "  clean  - Clean build environment"
        echo "  all    - Run all steps (deps, init, sync, build)"
        exit 1
        ;;
esac
