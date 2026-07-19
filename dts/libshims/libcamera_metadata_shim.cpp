/*
 * Copyright (C) 2024 The LineageOS Project
 *
 * SPDX-License-Identifier: Apache-2.0
 */

#include <dlfcn.h>
#include <stddef.h>
#include <stdint.h>

/**
 * Correct tag values from AOSP camera_metadata_tags.h
 * Section ANDROID_STATISTICS base = 0x00080000
 *
 * Previous shim had these WRONG:
 *   0x80000 = ANDROID_STATISTICS_FACE_DETECT_MODE  (not what we want)
 *   0x80001 = ANDROID_STATISTICS_FACE_IDS          (correct to keep)
 *   0x80002 = ANDROID_STATISTICS_FACE_LANDMARKS    (not what we want)
 *
 * Correct values for the fields the Java validator complains about:
 *   ANDROID_STATISTICS_FACE_RECTANGLES = 0x00080003
 *   ANDROID_STATISTICS_FACE_SCORES     = 0x00080004
 *
 * The logcat warning is from CameraMetadataJV (Java Validation layer),
 * which checks these two fields specifically after every HAL result.
 * FACE_IDS is also guarded as the validator checks all three together
 * when face detection mode is not OFF.
 */
#define ANDROID_STATISTICS_FACE_IDS        0x00080001
#define ANDROID_STATISTICS_FACE_RECTANGLES 0x00080003
#define ANDROID_STATISTICS_FACE_SCORES     0x00080004

typedef int (*updateImpl_fn)(void*, uint32_t, const void*, size_t);

/**
 * Interposes android::CameraMetadata::updateImpl(uint32_t, const void*, size_t)
 * Mangled: _ZN7android14CameraMetadata10updateImplEjPKvm
 *
 * Uses RTLD_NEXT to chain to the real symbol in libcamera_client.so at
 * runtime. This is the correct approach for a preloaded shim -- no
 * --alias ldflags (which are not a valid GNU ld option) and no direct
 * link-time dependency on libcamera_client needed.
 *
 * When the HAL delivers a frame with no faces detected, it may pass
 * null or zero-count arrays for the face result fields. The Java-side
 * CameraMetadataJV validator rejects both null pointers AND empty
 * arrays, so we must supply a pointer to at least one zeroed element
 * (data_count = 1), not data_count = 0 with a dummy pointer.
 */
extern "C" __attribute__((visibility("default")))
int _ZN7android14CameraMetadata10updateImplEjPKvm(
        void* self, uint32_t tag, const void* data, size_t data_count) {

    // Resolve the real implementation once, lazily.
    static updateImpl_fn real_updateImpl = nullptr;
    if (__builtin_expect(real_updateImpl == nullptr, 0)) {
        real_updateImpl = reinterpret_cast<updateImpl_fn>(
                dlsym(RTLD_NEXT, "_ZN7android14CameraMetadata10updateImplEjPKvm"));
    }

    if (tag == ANDROID_STATISTICS_FACE_RECTANGLES ||
        tag == ANDROID_STATISTICS_FACE_SCORES     ||
        tag == ANDROID_STATISTICS_FACE_IDS) {
        if (data == nullptr || data_count == 0) {
            // One zeroed element satisfies CameraMetadataJV's non-null
            // AND non-empty checks without affecting rendering output.
            static const uint8_t dummy[4] = {0, 0, 0, 0};
            return real_updateImpl(self, tag, dummy, 1);
        }
    }

    return real_updateImpl(self, tag, data, data_count);
}
