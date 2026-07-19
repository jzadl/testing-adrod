// Shim for keymaster beanpod service
// Provides missing destructor and method symbols

namespace android {
namespace hardware {
namespace keymaster {
namespace V4_0 {

// Empty destructors for response classes
class GenerateKeyResponse {
public:
    ~GenerateKeyResponse() {}
};

class AttestKeyResponse {
public:
    ~AttestKeyResponse() {}
};

}  // namespace V4_0
}  // namespace keymaster
}  // namespace hardware
}  // namespace android

// Provide the symbols
extern "C" {
    void _ZN6android8hardware8keymaster4V4_018GenerateKeyResponseD1Ev() {}
    void _ZN6android8hardware8keymaster4V4_017AttestKeyResponseD1Ev() {}
    void _ZN6android8hardware8keymaster4V4_003Imp5SetKeyMaterialEPKhm() {}
}
