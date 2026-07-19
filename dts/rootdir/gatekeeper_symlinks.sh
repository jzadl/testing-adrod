#!/bin/sh
# Create gatekeeper symlinks
ln -sf /vendor/lib64/libSoftGatekeeper.so /vendor/lib64/hw/gatekeeper.default.so 2>/dev/null
ln -sf /vendor/lib/libSoftGatekeeper.so /vendor/lib/hw/gatekeeper.default.so 2>/dev/null
ln -sf /vendor/lib64/egl/libGLES_mali.so /vendor/lib64/hw/vulkan.mt6768.so 2>/dev/null
ln -sf /vendor/lib/egl/libGLES_mali.so /vendor/lib/hw/vulkan.mt6768.so 2>/dev/null
