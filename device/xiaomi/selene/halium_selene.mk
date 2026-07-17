# Halium product configuration for Xiaomi Redmi 10 2022 (selene)
# MediaTek MT6768 (Helio G88)

$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/product_launched_with_r.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/halium.mk)

# Inherit device configuration
$(call inherit-product, $(LOCAL_PATH)/device.mk)

# Device identification
PRODUCT_DEVICE := selene
PRODUCT_NAME := halium_selene
PRODUCT_BRAND := Xiaomi
PRODUCT_MANUFACTURER := Xiaomi
PRODUCT_MODEL := Redmi 10 2022

PRODUCT_BUILD_PROP_OVERRIDES += \
    PRODUCT_NAME=selene \
    BUILD_PRODUCT=selene \
    BUILD_DESCRIPTION=selene-userdebug \
    TARGET_DEVICE=selene \
    BUILD_FINGERPRINT="Xiaomi/selene/selene:11/RP1A.200720.012/V13.0.9.0.RKUIDNXM:userdebug/test-keys"
