# Board config for Samsung Galaxy J7 Neo (j7velte) - Halium 9.0

-include device/samsung/universal7870-common/BoardConfigCommon.mk

# Architecture
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_VARIANT := cortex-a53
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_ABI2 :=
TARGET_2ND_ARCH := arm
TARGET_2ND_ARCH_VARIANT := armv7-a-neon
TARGET_2ND_CPU_VARIANT := cortex-a53
TARGET_2ND_CPU_ABI := armeabi-v7a
TARGET_2ND_CPU_ABI2 := armeabi

# Vendor
TARGET_COPY_OUT_VENDOR := vendor

TARGET_BOARD_ODM_DEVICE := samsungexynos7870

# Kernel
TARGET_KERNEL_CONFIG := lineage_j7velte_defconfig
TARGET_KERNEL_VARIANT_CONFIG := kernel_defconfig

BOARD_KERNEL_BASE := 0x10000000
BOARD_KERNEL_PAGESIZE := 2048
BOARD_MKBOOTIMG_ARGS := --kernel_offset 0x00008000 --ramdisk_offset 0x01000000 --tags_offset 0x00000100 --board 0x00000000
BOARD_KERNEL_IMAGE_NAME := Image

# Halium: system-as-root
BOARD_BUILD_SYSTEM_ROOT_IMAGE := true
BOARD_SYSTEMIMAGE_PARTITION_SIZE := 2684354560
BOARD_SYSTEMIMAGE_FILE_SYSTEM_TYPE := ext4

# Vendor / ODM partitions
BOARD_VENDORIMAGE_PARTITION_SIZE := 524288000
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_ODMIMAGE_PARTITION_SIZE := 67108864
BOARD_ODMIMAGE_FILE_SYSTEM_TYPE := ext4

# Cache
BOARD_CACHEIMAGE_PARTITION_SIZE := 52428800
BOARD_CACHEIMAGE_FILE_SYSTEM_TYPE := ext4

# Userdata
BOARD_DATAIMAGE_PARTITION_SIZE := 12884901888
BOARD_DATAIMAGE_FILE_SYSTEM_TYPE := ext4

# Recovery
TARGET_RECOVERY_PIXEL_FORMAT := ABGR_8888
TARGET_USERIMAGES_USE_EXT4 := true

# Kernel cmdline
BOARD_KERNEL_CMDLINE := androidboot.hardware=j7velte console=tty0 androidboot.selinux=enforcing

# Bluetooth
BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR := device/samsung/j7velte/bluetooth
BOARD_BLUETOOTH_USES_HCIATTACH_PROPERTY := true

# Wifi
BOARD_WLAN_DEVICE := bcmdhd
BOARD_WPA_SUPPLICANT_DRIVER := NL80211
BOARD_WPA_SUPPLICANT_PRIVATE_LIB := lib_driver_cmd_bcmdhd
BOARD_HOSTAPD_DRIVER := NL80211
BOARD_HOSTAPD_PRIVATE_LIB := lib_driver_cmd_bcmdhd
WIFI_DRIVER_FW_PATH_PARAM := "/sys/module/bcmdhd/parameters/firmware_path"
WIFI_DRIVER_FW_PATH_AP := "/vendor/etc/firmware/fw_bcmdhd_apsta.bin"
WIFI_DRIVER_FW_PATH_P2P := "/vendor/etc/firmware/fw_bcmdhd_p2p.bin"
WIFI_DRIVER_FW_PATH_STA := "/vendor/etc/firmware/fw_bcmdhd.bin"

# SELinux
BOARD_SEPOLICY_DIRS += device/samsung/j7velte/sepolicy

# Inherit from vendor
-include vendor/samsung/j7velte/BoardConfigVendor.mk
