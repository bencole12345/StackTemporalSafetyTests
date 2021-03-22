/**
 * Super simple minimal example that just exits with a "success" code.
 */

#include "_preamble.S"

/**
 * Text section: Where the code goes
 */
 .text

 /**
  * _start is the entry point to this binary.
  */
 .global _start
 _start:

    # Write the value 1 to tohost
    # (This tells Spike/Sail to exit with a success code (0))
    li t0, 1
    la t1, tohost
    sw t0, 0(t1)

    # Spin until exit
1:  j 1b
    