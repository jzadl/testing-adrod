# Android.mk for Xiaomi Redmi 10 2022 (selene)
# This file is used by the Android build system to define the device module.

LOCAL_PATH := $(call my-dir)

ifeq ($(TARGET_DEVICE),selene)

# Vendor symlinks
include $(CLEAR_VARS)
LOCAL_MODULE := vendor_symlinks
LOCAL_MODULE_CLASS := UTILS
LOCAL_MODULE_TAGS := optional
LOCAL_INSTALLED_MODULE_STAGING_DIR := $(TARGET_OUT staging)
LOCAL_REQUIRED_MODULES := $(addsuffix _symlink,$(PRODUCT_PACKAGES))
include $(BUILD_SYSTEM)/base_rules.mk

$(LOCAL_BUILT_MODULE): $(LOCAL_INSTALLED_MODULE_STAGING_DIR)
$(LOCAL_INSTALLED_MODULE_STAGING_DIR):
	$(hide) mkdir -p $(dir $@)
	$(hide) touch $@

endif
