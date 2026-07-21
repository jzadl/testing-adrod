# BoardConfig.mk for Xiaomi Redmi 10 2022 (selene)
# SoC: MediaTek MT6768 (Helio G88)
# Halium 11.0

BOARD_VENDOR := xiaomi

# Platform
TARGET_BOARD_PLATFORM := mt6768
TARGET_USES_64_BIT_BINDER := true

# Architecture
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-2a
TARGET_CPU_VARIANT := cortex-a75
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_ABI2 :=
TARGET_2ND_ARCH := arm
TARGET_2ND_ARCH_VARIANT := armv8-2a
TARGET_2ND_CPU_VARIANT := cortex-a55
TARGET_2ND_CPU_ABI := armeabi-v7a
TARGET_2ND_CPU_ABI2 := armeabi

# Kernel (prebuilt via workflow)
TARGET_PREBUILT_KERNEL := device/xiaomi/selene/prebuilt/Image.gz-dtb
TARGET_NO_KERNEL := false
BOARD_KERNEL_IMAGE_NAME := Image.gz-dtb

BOARD_KERNEL_BASE := 0x40000000
BOARD_KERNEL_PAGESIZE := 2048
BOARD_KERNEL_OFFSET := 0x00008000
BOARD_RAMDISK_OFFSET := 0x07c80000
BOARD_TAGS_OFFSET := 0x0bc80000
BOARD_MKBOOTIMG_ARGS := \
    --kernel_offset $(BOARD_KERNEL_OFFSET) \
    --ramdisk_offset $(BOARD_RAMDISK_OFFSET) \
    --tags_offset $(BOARD_TAGS_OFFSET) \
    --header_version 0

BOARD_KERNEL_CMDLINE := \
    androidboot.hardware=selene \
    androidboot.bootdevice=mtk-msdc.0 \
    bootopt=64S3,32N2,64N2 \
    console=tty0 \
    androidboot.selinux=permissive \
    buildvariant=userdebug

# Halium / Boot
TARGET_NO_BOOTLOADER := true
TARGET_NO_RECOVERY := true
BOARD_USES_RECOVERY_AS_BOOT := true
BOARD_BUILD_SYSTEM_ROOT_IMAGE := true
TARGET_FLATTEN_APEX := true
BOARD_RECOVERY_BLDRMSG_OFFSET := 0

# Filesystem
TARGET_USERIMAGES_USE_EXT4 := true
BOARD_SYSTEMIMAGE_PARTITION_SIZE := 3221225472
BOARD_SYSTEMIMAGE_FILE_SYSTEM_TYPE := ext4

# Vendor partition
TARGET_COPY_OUT_VENDOR := vendor
BOARD_VENDORIMAGE_PARTITION_SIZE := 1073741824
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := ext4

# Display
TARGET_USES_HWC2 := true
TARGET_RECOVERY_PIXEL_FORMAT := "RGBX_8888"

# Init library
TARGET_INIT_VENDOR_LIB := libinit_selene

# Hardware
BOARD_USES_MTK_HARDWARE := true
