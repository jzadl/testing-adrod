// Shim: forward 2-arg GetPreviewImageData to 3-arg version (3rd arg = nullptr)
extern "C" void
_ZN4piex19GetPreviewImageDataEPNS_15StreamInterfaceEPNS_16PreviewImageDataEPNS_22image_type_recognition13RawImageTypesE(
    void* data, void* preview_image_data, void* output_type);

extern "C" void _ZN4piex19GetPreviewImageDataEPNS_15StreamInterfaceEPNS_16PreviewImageDataE(
    void* data, void* preview_image_data) {
    _ZN4piex19GetPreviewImageDataEPNS_15StreamInterfaceEPNS_16PreviewImageDataEPNS_22image_type_recognition13RawImageTypesE(
        data, preview_image_data, nullptr);
}
