/**
 * This should be fine: the callee stores a pointer to the caller.
 */

#include "debug.h"

typedef struct object {
    struct object *ptr;
} object;

int main(int argc, char **argv)
{
    object obj1;
    object obj2;

    PRINT_STORE(&(obj1.ptr), &obj2);
    __asm("# Doing the first store");
    obj1.ptr = &obj2;
    __asm("# Store complete");

    PRINT_STORE(&(obj2.ptr), &obj1);
    __asm("# Doing the second store");
    obj2.ptr = &obj1;
    __asm("# Store complete");

    return 0;
}
