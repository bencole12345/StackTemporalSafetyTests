#include <stdio.h>

#define PRINT_STORE(lhs, rhs) \
    printf("Storing cap to address: %p\n", rhs); \
    printf("            at address: %p\n", lhs);
