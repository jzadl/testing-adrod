# Board config for Xiaomi Redmi 10 2022 (selene) - Halium 11.0
# MediaTek MT6768 (Helio G88)

BOARD_VENDOR := xiaomi

TARGET_BOARD_PLATFORM := mt6768

TARGET_USES_64_BIT_BINDER := true

# Architecture
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_VARIANT := cortex-a53
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_ABI2 :=
TARGET_2ND_ARCH := arm
TARGET_2ND_ARCH_VARIANT := armv8-a
TARGET_2ND_CPU_VARIANT := cortex-a53
TARGET_2ND_CPU_ABI := armeabi-v7a
TARGET_2ND_CPU_ABI2 := armeabi

# Vendor
TARGET_COPY_OUT_VENDOR := vendor

# Kernel (prebuilt, compiled via workflow)
TARGET_PREBUILT_KERNEL := device/xiaomi/selene/prebuilt/Image.gz-dtb
TARGET_NO_KERNEL := false
BOARD_KERNEL_IMAGE_NAME := Image.gz-dtb

BOARD_KERNEL_BASE := 0x40000000
BOARD_KERNEL_PAGESIZE := 2048
BOARD_KERNEL_OFFSET := 0x00008000
BOARD_RAMDISK_OFFSET := 0x07c80000
BOARD_TAGS_OFFSET := 0x0bc80000
BOARD_MKBOOTIMG_ARGS := --kernel_offset $(BOARD_KERNEL_OFFSET) --ramdisk_offset $(BOARD_RAMDISK_OFFSET) --tags_offset $(BOARD_TAGS_OFFSET) --header_version 2

BOARD_KERNEL_CMDLINE := androidboot.hardware=selene androidboot.bootdevice=mtk-msdc.0 bootopt=64S3,32N2,64N2 console=tty0 androidboot.selinux=permissive buildvariant=userdebug

# Halium
BOARD_BUILD_SYSTEM_ROOT_IMAGE := true
BOARD_USES_RECOVERY_AS_BOOT := true
TARGET_NO_BOOTLOADER := true
TARGET_NO_RECOVERY := true
TARGET_FLATTEN_APEX := true

# Filesystem
TARGET_USERIMAGES_USE_EXT4 := true

# Vendor partition
BOARD_VENDORIMAGE_PARTITION_SIZE := 1073741824
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := ext4

# Display
TARGET_USES_HWC2 := true
TARGET_RECOVERY_PIXEL_FORMAT := "RGBX_8888"

# MTK specific
BOARD_USES_MTK_HARDWARE := true

# SELinux
BOARD_SEPOLICY_DIRS += device/xiaomi/selene/sepolicy

# Inherit from vendor
-include vendor/xiaomi/selene/BoardConfigVendor.mk
