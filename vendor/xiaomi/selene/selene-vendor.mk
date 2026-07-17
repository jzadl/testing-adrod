# Vendor blobs for Xiaomi Redmi 10 2022 (selene)
# Blobs from MIUI V12.5.20.0.RKUMIXM (Android 11, MT6768)

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

# HAL packages provided by vendor
PRODUCT_PACKAGES += \
    android.hardware.audio@6.0-impl \
    android.hardware.audio@6.0-service \
    android.hardware.audio.effect@6.0-impl \
    android.hardware.bluetooth@1.0-impl \
    android.hardware.bluetooth@1.0-service \
    android.hardware.boot@1.1-impl \
    android.hardware.boot@1.1-service \
    android.hardware.camera.provider@2.6-impl \
    android.hardware.drm@1.3-service.clearkey \
    android.hardware.drm@1.3-service.widevine \
    android.hardware.gatekeeper@1.0-impl \
    android.hardware.gatekeeper@1.0-service \
    android.hardware.gnss@2.1-impl \
    android.hardware.gnss@2.1-service \
    android.hardware.graphics.allocator@4.0-impl \
    android.hardware.graphics.allocator@4.0-service \
    android.hardware.graphics.composer@2.1-impl \
    android.hardware.graphics.composer@2.1-service \
    android.hardware.graphics.mapper@4.0-impl \
    android.hardware.health@2.1-impl \
    android.hardware.health@2.1-service \
    android.hardware.ir@1.0-impl \
    android.hardware.ir@1.0-service \
    android.hardware.keymaster@4.0-impl \
    android.hardware.keymaster@4.0-service \
    android.hardware.media.omx@1.0-service \
    android.hardware.memtrack@1.0-impl \
    android.hardware.memtrack@1.0-service \
    android.hardware.renderscript@1.0-impl \
    android.hardware.sensors@2.0-impl \
    android.hardware.sensors@2.0-service \
    android.hardware.thermal@2.0-impl \
    android.hardware.thermal@2.0-service \
    android.hardware.usb@1.1-impl \
    android.hardware.usb@1.1-service \
    android.hardware.vibrator@1.3-impl \
    android.hardware.vibrator@1.3-service \
    android.hardware.wifi@1.0-service \
    android.hardware.wifi.supplicant@1.3
