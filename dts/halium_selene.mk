# halium_selene.mk - Product configuration for Xiaomi Redmi 10 2022
# Halium 11.0

$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, vendor/halium/config/halium.mk)
$(call inherit-product, $(LOCAL_PATH)/device.mk)

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
    BUILD_FINGERPRINT="Xiaomi/selene/selene:11/RP1A.200720.012/V12.5.20.0.RKUMIXM:userdebug/test-keys"
