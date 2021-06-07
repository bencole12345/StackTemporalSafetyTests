#include <stdio.h>
#include <stdlib.h>

#include "benchmarking.h"


#define BUFFER_SIZE 4096
#define N 10000


#define DEFINE_WRITE_TO_LOCAL_FUNC(bufsize)     \
void writeToLocal##bufsize(int value)           \
{                                               \
    char buffer[bufsize];                       \
    int local_copy = value;                     \
}

DEFINE_WRITE_TO_LOCAL_FUNC(16)
DEFINE_WRITE_TO_LOCAL_FUNC(32)
DEFINE_WRITE_TO_LOCAL_FUNC(64)
DEFINE_WRITE_TO_LOCAL_FUNC(128)
DEFINE_WRITE_TO_LOCAL_FUNC(256)
DEFINE_WRITE_TO_LOCAL_FUNC(512)
DEFINE_WRITE_TO_LOCAL_FUNC(1024)
DEFINE_WRITE_TO_LOCAL_FUNC(2048)
DEFINE_WRITE_TO_LOCAL_FUNC(4096)
DEFINE_WRITE_TO_LOCAL_FUNC(8192)
DEFINE_WRITE_TO_LOCAL_FUNC(16384)
DEFINE_WRITE_TO_LOCAL_FUNC(32768)


int main(int argc, char **argv)
{
    int buffer_size = atoi(argv[1]);

    switch (buffer_size) {
    case 16: {
        TIME_AND_RUN_N_TIMES(writeToLocal16(1), N);
    } break;
    case 32: {
        TIME_AND_RUN_N_TIMES(writeToLocal32(1), N);
    } break;
    case 64: {
        TIME_AND_RUN_N_TIMES(writeToLocal64(1), N);
    } break;
    case 128: {
        TIME_AND_RUN_N_TIMES(writeToLocal128(1), N);
    } break;
    case 256: {
        TIME_AND_RUN_N_TIMES(writeToLocal256(1), N);
    } break;
    case 512: {
        TIME_AND_RUN_N_TIMES(writeToLocal512(1), N);
    } break;
    case 1024: {
        TIME_AND_RUN_N_TIMES(writeToLocal1024(1), N);
    } break;
    case 2048: {
        TIME_AND_RUN_N_TIMES(writeToLocal2048(1), N);
    } break;
    case 4096: {
        TIME_AND_RUN_N_TIMES(writeToLocal4096(1), N);
    } break;
    case 8192: {
        TIME_AND_RUN_N_TIMES(writeToLocal8192(1), N);
    } break;
    case 16384: {
        TIME_AND_RUN_N_TIMES(writeToLocal16384(1), N);
    } break;
    case 32768: {
        TIME_AND_RUN_N_TIMES(writeToLocal32768(1), N);
    } break;
    default:
        return -1;
    }

    return 0;
}
