# Vendor properties for Samsung Galaxy J7 Neo (j7velte) - Halium 9.0

# Display
PRODUCT_PROPERTY_OVERRIDES += \
    ro.sf.lcd_density=400 \
    ro.sf.hwrotation=0 \
    persist.sys.sf.native_mode=1 \
    ro.config.ringtone=Over_the_horizon.ogg \
    ro.config.notification_sound=S_Original.ogg

# Audio
PRODUCT_PROPERTY_OVERRIDES += \
    audio.offload.disable=true \
    audio.deep_buffer.media=false \
    audio.mixer.default=audio_hw_primary \
    audio.safemedia.bypass=true \
    media.omap.aal.enabled=1

# Connectivity
PRODUCT_PROPERTY_OVERRIDES += \
    wifi.interface=wlan0 \
    ro.nfc.port=NCI

# Camera
PRODUCT_PROPERTY_OVERRIDES += \
    camera2.portability.force_en=true \
    persist.camera.HAL3.enabled=1

# Bluetooth
PRODUCT_PROPERTY_OVERRIDES += \
    ro.bluetooth.hfp.ver=1.7 \
    ro.bluetooth.dun=false \
    persist.bluetooth.a4wp=false

# NFC
PRODUCT_PROPERTY_OVERRIDES += \
    persist.nfc.feature.version=21000000 \
    nfc.fallback.feature=0x02020400

# Graphics
PRODUCT_PROPERTY_OVERRIDES += \
    debug.hwui.renderer=skiagl \
    ro.hardware.egl=mali

# Samsung specific
PRODUCT_PROPERTY_OVERRIDES += \
    ro.com.google.clientidbase=android-samsung \
    ro.ril.hsxpa=3 \
    ro.ril.gprsclass=12 \
    ro.ril.hev3-ecc=1
