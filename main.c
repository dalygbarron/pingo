#include "lodepng.h"
#include <janet.h>

Janet readFile(int32_t argc, Janet *argv) {
    janet_fixarity(argc, 2);
    char const *file = janet_getcstring(argv, 0);
    JanetBuffer *buffer = janet_getbuffer(argv, 1);
    unsigned char *data;
    unsigned int width;
    unsigned int height;
    unsigned int error = lodepng_decode32_file(&data, &width, &height, file);
    if (error) {
        janet_panicf("png error %x: %s\n", error, lodepng_error_text(error));
    }
    janet_buffer_setcount(buffer, 0);
    janet_buffer_push_bytes(buffer, data, width * height * 4);
    Janet items[2];
    items[0] = janet_wrap_number(width);
    items[1] = janet_wrap_number(height);
    return janet_wrap_tuple(janet_tuple_n(items, 2));
}

Janet readBytes(int32_t argc, Janet *argv) {
    janet_fixarity(argc, 2);
    JanetBuffer *buffer = janet_getbuffer(argv, 0);
    JanetBuffer *outBuffer = janet_getbuffer(argv, 1);
    unsigned char *data;
    unsigned int width;
    unsigned int height;
    unsigned int error = lodepng_decode32(
        &data,
        &width,
        &height,
        buffer->data,
        buffer->count
    );
    if (error) {
        janet_panicf("png error %x: %s\n", error, lodepng_error_text(error));
    }
    janet_buffer_setcount(outBuffer, 0);
    janet_buffer_push_bytes(outBuffer, data, width * height * 4);
    Janet items[2];
    items[0] = janet_wrap_number(width);
    items[1] = janet_wrap_number(height);
    return janet_wrap_tuple(janet_tuple_n(items, 2));
}

Janet writeFile(int32_t argc, Janet *argv) {
    janet_fixarity(argc, 4);
    char const *file = janet_getcstring(argv, 0);
    JanetBuffer *image = janet_getbuffer(argv, 1);
    int32_t width = janet_getinteger(argv, 2);
    int32_t height = janet_getinteger(argv, 3);
    if (image->count != width * height * 4) {
        janet_panicf(
            "pingo error: width*height*4 is %d, but %d bytes",
            width * height * 4,
            image->count
        );
    }
    unsigned int error = lodepng_encode32_file(
        file,
        image->data,
        width,
        height
    );
    if (error) {
        janet_panicf("lodepng error %x: %s\n", error, lodepng_error_text(error));
    }
    return janet_wrap_nil();
}

Janet writeBytes(int32_t argc, Janet *argv) {
    janet_fixarity(argc, 3);
    JanetBuffer *image = janet_getbuffer(argv, 0);
    int32_t width = janet_getinteger(argv, 1);
    int32_t height = janet_getinteger(argv, 2);
    if (image->count != width * height * 4) {
        janet_panicf(
            "pingo error: width*height*4 is %d, but %d bytes",
            width * height * 4,
            image->count
        );
    }
    unsigned char *data;
    size_t dataSize;
    unsigned int error = lodepng_encode32(
        &data,
        &dataSize,
        image->data,
        width,
        height
    );
    if (error) {
        janet_panicf("png error %x: %s\n", error, lodepng_error_text(error));
    }
    JanetBuffer buffer;
    janet_buffer_push_bytes(&buffer, data, dataSize);
    return janet_wrap_buffer(&buffer);
}

static const JanetReg cfuns[] = {
    {
        "read-file", readFile,
        "(read-file file buffer)\n"
        "Reads in a png file at the given path and gives you a tuple"
        "that contains all the 32 bit pixel data in a buffer, and the width"
        "and the height like (data width height)"
    },
    {
        "read-bytes", readBytes,
        "(read-bytes bytes buffer)\n"
        "same as read file but it reads the image from an array of bytes that"
        "constituted a png file instead of it opening the file itself"
    },
    {
        "write-file", writeFile,
        "(write-file file image width height)\n"
        "Writes pixel data into the given file"
    },
    {
        "write-bytes", writeBytes,
        "(write-bytes image width height buffer)\n"
        "Writes pixel data into a sequence of bytes befitting a png file"
    },
    {NULL, NULL, NULL},
};

JANET_MODULE_ENTRY(JanetTable *env) {
    janet_cfuns(env, "pingo", cfuns);
}
