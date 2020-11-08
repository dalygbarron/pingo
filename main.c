#include "lodepng.h"
#include <janet.h>

void writePng(
    char const *file,
    unsigned char const *pixels,
    unsigned int width,
    unsigned int height
) {
    unsigned int error = lodepng_encode32_file(file, pixels, width, height);
    if (error) 
}

JANET_MODULE_ENTRY(JanetTable *env) {
    janet_cfuns(env, "pngio", cfuns);
}
