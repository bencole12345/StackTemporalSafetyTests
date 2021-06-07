#include <stdio.h>
#include <stdlib.h>

#include "benchmarking.h"


__attribute__((noinline))
void functionToCall()
{
    // Do nothing
    return;
}

int main(int argc, char **argv)
{
    long int N = atol(argv[1]);

    TIME_AND_RUN_N_TIMES(functionToCall(), N);

    return 0;
}
