#include "debug.h"

#include <stdio.h>

typedef struct object {
    struct object *ptr;
} object;

object globalObj;

void callee()
{
    object calleeObj;

    PRINT_STORE(&(globalObj.ptr), &calleeObj);

    __asm("# Doing the store");
    globalObj.ptr = &calleeObj;
    __asm("# Store complete");

    printf("Store complete!\n");
    printf("globalObj.ptr = %p\n", globalObj.ptr);
}

int main(int argc, char **argv)
{
    callee();
    return 0;
}
