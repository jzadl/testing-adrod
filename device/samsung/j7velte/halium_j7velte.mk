# Halium product configuration for Samsung Galaxy J7 Neo (j7velte)

$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/product_launched_with_n.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/halium.mk)
$(call inherit-product, $(LOCAL_PATH)/device.mk)

PRODUCT_DEVICE := j7velte
PRODUCT_NAME := halium_j7velte
PRODUCT_BRAND := samsung
PRODUCT_MANUFACTURER := samsung
PRODUCT_MODEL := SM-J701F

PRODUCT_PROPERTY_OVERRIDES += \
    ro.product.board=j7velte \
    ro.product.device=j7velte \
    ro.product.first_api_level=24 \
    ro.product.locale=en-US
