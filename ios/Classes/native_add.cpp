#include <stdint.h>
#include <stdio.h>

// Avoiding name mangling
extern "C" {
    // Attributes to prevent 'unused' function from being removed and to make it visible
    __attribute__((visibility("default"))) __attribute__((used))
    const char* version() {
        return "CV_VERSION";
    }

    // Attributes to prevent 'unused' function from being removed and to make it visible
    __attribute__((visibility("default"))) __attribute__((used))
    int32_t native_add(int32_t x, int32_t y) {
        return x + y;
    }

    // Attributes to prevent 'unused' function from being removed and to make it visible
    __attribute__((visibility("default"))) __attribute__((used))
    float hex_to_float(char hex[4]) {
        float f = *((float *)hex);
        return f;
    }
}
