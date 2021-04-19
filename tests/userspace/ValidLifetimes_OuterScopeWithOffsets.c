/**
 * Tests that offsets are handled correctly.
 */

#include "debug.h"

typedef struct object {
    struct object *ptr1;
    struct object *ptr2;
} object;

void callee(object *callerObj)
{
    object calleeObj;

    PRINT_STORE(&(calleeObj.ptr1), callerObj);
    PRINT_STORE(&(calleeObj.ptr2), callerObj);

    __asm("# Doing the store");
    calleeObj.ptr1 = callerObj;
    calleeObj.ptr2 = callerObj;
    __asm("# Store complete");
}

int main(int argc, char **argv)
{
    object callerObj;
    // char unusedBuffer[65536];
    
    callee(&callerObj);

    return 0;
}
