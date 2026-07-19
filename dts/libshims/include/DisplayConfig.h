#ifndef ANDROID_GUI_DISPLAYCONFIG_H
#define ANDROID_GUI_DISPLAYCONFIG.h

#include <cstdint>

namespace android {
namespace ui {

struct DisplayConfig {
    uint32_t width = 0;
    uint32_t height = 0;
    uint32_t vsyncPeriod = 0;
    int32_t densityX = 0;
    int32_t densityY = 0;
    int32_t orientation = 0;
};

} // namespace ui
} // namespace android

#endif
