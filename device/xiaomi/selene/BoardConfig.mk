# Board config for Xiaomi Redmi 10 2022 (selene) - Halium 11.0
# MediaTek MT6768 (Helio G88)

TARGET_BOARD_PLATFORM := mt6768

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

# Prebuilt kernel (compiled separately via build-kernel-selene workflow)
TARGET_PREBUILT_KERNEL := device/xiaomi/selene/prebuilt/Image.gz-dtb
TARGET_NO_KERNEL := false
BOARD_INCLUDE_DTB_IN_BOOTIMG := true

BOARD_KERNEL_BASE := 0x40000000
BOARD_KERNEL_PAGESIZE := 2048
BOARD_KERNEL_OFFSET := 0x00008000
BOARD_RAMDISK_OFFSET := 0x07c80000
BOARD_TAGS_OFFSET := 0x0bc80000
BOARD_MKBOOTIMG_ARGS := --kernel_offset $(BOARD_KERNEL_OFFSET) --ramdisk_offset $(BOARD_RAMDISK_OFFSET) --tags_offset $(BOARD_TAGS_OFFSET) --header_version 2
BOARD_KERNEL_IMAGE_NAME := Image.gz-dtb

# Kernel cmdline (stock + Halium additions)
BOARD_KERNEL_CMDLINE := androidboot.hardware=selene androidboot.bootdevice=mtk-msdc.0 bootopt=64S3,32N2,64N2 console=tty0 androidboot.selinux=permissive buildvariant=userdebug

# Halium: system-as-root
BOARD_BUILD_SYSTEM_ROOT_IMAGE := true
BOARD_USES_RECOVERY_AS_BOOT := false
TARGET_NO_RECOVERY := false

# System partition
BOARD_SYSTEMIMAGE_PARTITION_SIZE := 3221225472
BOARD_SYSTEMIMAGE_FILE_SYSTEM_TYPE := ext4

# Vendor partition
BOARD_VENDORIMAGE_PARTITION_SIZE := 1073741824
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := ext4

# ODM partition
BOARD_ODMIMAGE_PARTITION_SIZE := 67108864
BOARD_ODMIMAGE_FILE_SYSTEM_TYPE := ext4

# Cache partition
BOARD_CACHEIMAGE_PARTITION_SIZE := 524288000
BOARD_CACHEIMAGE_FILE_SYSTEM_TYPE := ext4

# Userdata partition
BOARD_DATAIMAGE_PARTITION_SIZE := 118921113600
BOARD_DATAIMAGE_FILE_SYSTEM_TYPE := ext4

# Super partition (dynamic)
BOARD_SUPER_PARTITION_SIZE := 8589934592
BOARD_SUPER_PARTITION_GROUPS := main
BOARD_SUPER_PARTITION_MAIN_PARTITION_LIST := system vendor product odm

# Recovery
TARGET_RECOVERY_PIXEL_FORMAT := ABGR_8888
TARGET_USERIMAGES_USE_EXT4 := true

# Verified Boot
BOARD_AVB_ENABLE := true
BOARD_AVB_MAKE_VBMETA_IMAGE_ARGS += --flags 2

# Display
TARGET_SCREEN_WIDTH := 1080
TARGET_SCREEN_HEIGHT := 2400

# MTK specific
BOARD_USES_MTK_HARDWARE := true
MTK_HARDWARE := true

# Bluetooth
BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR := device/xiaomi/selene/bluetooth

# Wifi
BOARD_WLAN_DEVICE := wlan_gen4m
BOARD_WPA_SUPPLICANT_DRIVER := NL80211
BOARD_WPA_SUPPLICANT_PRIVATE_LIB := lib_driver_cmd_mt66xx
BOARD_HOSTAPD_DRIVER := NL80211
BOARD_HOSTAPD_PRIVATE_LIB := lib_driver_cmd_mt66xx
WIFI_DRIVER_FW_PATH_PARAM := "/proc/driver/wmt_dbg"
WIFI_DRIVER_FW_PATH_AP := "WMT"
WIFI_DRIVER_FW_PATH_P2P := "WMT"
WIFI_DRIVER_FW_PATH_STA := "WMT"

# SELinux
BOARD_SEPOLICY_DIRS += device/xiaomi/selene/sepolicy
BOARD_SEPOLICY_VERS := 30.0

# Inherit from vendor
-include vendor/xiaomi/selene/BoardConfigVendor.mk
