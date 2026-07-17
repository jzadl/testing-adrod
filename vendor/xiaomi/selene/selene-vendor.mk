# Minimal vendor configuration for Xiaomi Redmi 10 2022 (selene)
# This provides a stub vendor to satisfy build system requirements
# without inheriting full vendor blobs that cause import-namespace cycles.

# Vendor properties
PRODUCT_PROPERTY_OVERRIDES += \
    ro.vendor.build.type=userdebug \
    ro.vendor.product.device=selene \
    ro.vendor.product.model="Redmi 10 2022" \
    ro.vendor.product.brand=Xiaomi \
    ro.vendor.product.manufacturer=Xiaomi

# Vendor packages (minimal HAL stubs)
PRODUCT_PACKAGES += \
    android.hardware.health@2.0-impl

# No PRODUCT_SOONG_NAMESPACES here - that was causing import-namespace cycles
