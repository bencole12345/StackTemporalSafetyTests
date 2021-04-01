/**
 * This should be fine: the callee stores a pointer to the caller.
 */

#include "debug.h"

typedef struct object {
    struct object *ptr;
} object;

void callee(object *callerObj)
{
    object calleeObj;

    PRINT_STORE(&(calleeObj.ptr), callerObj);

    __asm("# Doing the store");
    calleeObj.ptr = callerObj;
    __asm("# Store complete");
}

int main(int argc, char **argv)
{
    object callerObj;
    callee(&callerObj);

    return 0;
}
