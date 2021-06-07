#include <stdio.h>
#include <stdlib.h>

#include "benchmarking.h"


typedef struct demo {
    struct demo *ptr;
} demo_t;

__attribute__((noinline))
void inner(demo_t *outer_obj)
{
    demo_t inner_obj;
    outer_obj->ptr = &inner_obj;
}

__attribute__((noinline))
void outer()
{
    demo_t outer_obj;
    inner(&outer_obj);
}

int main(int argc, char **argv)
{
    long int N = atoi(argv[1]);

    TIME_AND_RUN_N_TIMES(outer(), N);

    return 0;
}
