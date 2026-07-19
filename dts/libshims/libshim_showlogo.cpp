// Shim for libshowlogo.so
// Bridges old SurfaceComposerClient/SurfaceControl constructors

#include <surfaceflinger/SurfaceComposerClient.h>
#include <gui/SurfaceControl.h>
#include <ui/Size.h>

using namespace android;

// SurfaceComposerClient::createSurface shim (old with SurfaceControl*)
extern "C" void _ZN7android21SurfaceComposerClient12createSurfaceERKNS_8String8EjjjNS_13PixelFormatEjjPNS_2spINS_7IBinderEEENS_19LayerSettingsAccessE(
    const String8&, uint32_t, uint32_t, uint32_t, int32_t, uint32_t, uint32_t, sp<IBinder>*, uint32_t) {}

// SurfaceControl::getSurface const shim
extern "C" void _ZNK7android13SurfaceControl10getSurfaceEv() {}

// getActiveDisplayConfig shim
extern "C" void _ZN7android21SurfaceComposerClient21getActiveDisplayConfigERKNS_2spINS_7IBinderEEEERNS_16DisplayConfigE(
    const sp<IBinder>&, DisplayConfig&) {}

// Transaction::apply with extra oneWay param
extern "C" void _ZN7android21SurfaceComposerClient11Transaction5applyEb(bool) {}

// ui::Size::INVALID
namespace android {
namespace ui {
const Size Size::INVALID{-1, -1};
}  // namespace ui
}  // namespace android
