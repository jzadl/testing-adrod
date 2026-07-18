# Vendor blobs for Xiaomi Redmi 10 2022 (selene)
# Blobs from MIUI V12.5.20.0.RKUMIXM (Android 11, MT6768)
# This file is hand-maintained; vendor-files.mk is auto-generated

$(call inherit-product, vendor/xiaomi/selene/selene-vendor-files.mk)

# Vendor properties
PRODUCT_PROPERTY_OVERRIDES += \
    ro.hardware.chipname=mt6768 \
    ro.vendor.build.security_patch=2022-04-05 \
    ro.vendor.product.cpu.abilist=arm64-v8a,armeabi-v7a,armeabi \
    ro.vendor.product.cpu.abilist32=armeabi-v7a,armeabi \
    ro.vendor.product.cpu.abilist64=arm64-v8a \
    ro.board.platform=mt6768 \
    ro.hardware=mt6768 \
    ro.telephony.default_network=3,1 \
    persist.vendor.wifi.p2p.support=1
