#include <stdio.h>
#include <stdlib.h>

#include "benchmarking.h"


#define N 1000


void writeToLocal(int value, int bufsize)
{
    char *buffer = malloc(sizeof(char) * bufsize);
    int local_copy = value;
    free(buffer);
}

int main(int argc, char **argv)
{
    int bufsize = atol(argv[1]);

    TIME_AND_RUN_N_TIMES(writeToLocal(1, bufsize), N);

    return 0;
}
