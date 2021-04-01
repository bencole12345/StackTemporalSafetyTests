/**
 * This should cause an exception: the caller's pointer is set to point to a
 * shorter-lifetime value in the callee's scope.
 */

#include "debug.h"

typedef struct object {
    struct object *ptr;
} object;

void callee(object *callerObj)
{
    object calleeObj;

    PRINT_STORE(&(callerObj->ptr), &calleeObj);

    __asm("# Doing the store");
    callerObj->ptr = &calleeObj;
    __asm("# Store complete");
}

int main(int argc, char **argv)
{
    object callerObj;
    callee(&callerObj);

    return 0;
}
