#include "lodepng.h"
#include <janet.h>

Janet readPng(int32_t argc, Janet *argv) {
    return janet_wrap_nil();
}

Janet writePng(int32_t argc, Janet *argv) {
    unsigned int error = lodepng_encode32_file(file, pixels, width, height);
    if (error) {
        janet_panicf("pingo error %u: %s\n", error, lodepng_error_text(error));
    }
    return janet_wrap_nil();
}

Janet freePng(int32_t argc, Janet *argc) {
    return janet_wrap_nil();
}

static const JanetReg cfuns[] = {
    {
        "read", readPng,
        "(read file)\n\n"
        "Reads in a png file and gives you a nice struct yeet"
    },
    {
        "write", writePng,
        "(write file image)\n\n",
        "Writes pixel data into the given file"
    },
    {
        "free", freePng,
        "(free image)\n\n",
        "Deletes pixel data"
    },
    {NULL, NULL, NULL},
};

JANET_MODULE_ENTRY(JanetTable *env) {
    janet_cfuns(env, "pngio", cfuns);
}
