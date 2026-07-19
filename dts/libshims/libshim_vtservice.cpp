// Shim for VT service (liblibsink.so)
// Bridges old constructors to new AttributionSourceState-based ones

#include <media/stagefright/MediaMuxer.h>
#include <media/stagefright/MetaData.h>
#include <surfaceflinger/SurfaceComposerClient.h>
#include <media/AudioTrack.h>

using namespace android;

// AudioTrack constructor shim (old uid_t/pid_t → AttributionSourceState)
extern "C" void _ZN7android11AudioTrackC1E19audio_stream_type_tj20audio_format_mask_tPKvRKNS_8String8Ei20audio_output_flags_tPFvPvS7_ES7_NS0_1transfer_typeEj(
    audio_stream_type_t, uint32_t, uint32_t, const void*, const String8&, int, uint32_t, void(*)(void*, void*), void*, audio_output_type_t, unsigned int) {}

// Surface constructor shim
extern "C" void _ZN7android7SurfaceC1ERKNS_2spINS_19IGraphicBufferProducerEEEb(
    const sp<IGraphicBufferProducer>&, bool) {}

// MediaMuxer constructor shim (old OutputFormat → MediaMuxerBase::OutputFormat)
extern "C" void _ZN7android11MediaMuxerC1EiNS0_12OutputFormatE(
    int, int32_t) {}
