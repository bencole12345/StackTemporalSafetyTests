#include <stdio.h>
#include <stdlib.h>

#include "benchmarking.h"


#define N 10000


void writeToLocal(int value, int bufsize)
{
    char buffer[bufsize];
    int local_copy = value;
}

int main(int argc, char **argv)
{
    int bufsize = atol(argv[1]);

    TIME_AND_RUN_N_TIMES(writeToLocal(1, bufsize), N);

    return 0;
}
