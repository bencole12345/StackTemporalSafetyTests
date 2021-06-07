#include <stdio.h>
#include <time.h>


#define TIME_AND_RUN_N_TIMES(thing, N)                                  \
    clock_t __start_time = clock();                                     \
    for (long int __i = 0; __i < N; __i++) {                                  \
        thing;                                                          \
    }                                                                   \
    clock_t __end_time = clock();                                       \
    double __time_taken = ((double) (__end_time - __start_time))        \
            / CLOCKS_PER_SEC;                                           \
    printf("%f", __time_taken);
